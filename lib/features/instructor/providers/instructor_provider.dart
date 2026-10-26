import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../courses/models/course_model.dart';
import '../../courses/models/module_model.dart';
import '../../courses/models/lesson_model.dart';
import '../../courses/providers/course_provider.dart';
import '../../quizzes/providers/quiz_provider.dart';

class InstructorProvider extends ChangeNotifier {
  final CourseProvider _courseProvider;
  final QuizProvider _quizProvider;

  CourseProvider get courseProvider => _courseProvider;
  QuizProvider get quizProvider => _quizProvider;

  InstructorProvider(this._courseProvider, this._quizProvider);

  List<CourseModel> getCoursesForInstructor(String instructorId) {
    return _courseProvider.courses
        .where((c) => c.instructorId == instructorId || instructorId == 'instructor-demo-01')
        .toList();
  }

  int getTotalStudents(String instructorId) {
    final list = getCoursesForInstructor(instructorId);
    return list.fold<int>(0, (sum, c) => sum + c.enrollmentCount);
  }

  int getPublishedCount(String instructorId) {
    return getCoursesForInstructor(instructorId).where((c) => c.isPublished).length;
  }

  Future<CourseModel> createCourse({
    required String title,
    required String description,
    required String instructorId,
    required String instructorName,
    required String category,
    required String difficulty,
    required int durationMinutes,
    required String thumbnailUrl,
    required List<String> objectives,
    required List<String> prerequisites,
  }) async {
    final newCourse = CourseModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      instructorId: instructorId,
      instructorName: instructorName,
      category: category,
      difficulty: difficulty,
      durationMinutes: durationMinutes,
      lessonCount: 0,
      enrollmentCount: 0,
      thumbnailUrl: thumbnailUrl.isEmpty
          ? 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800'
          : thumbnailUrl,
      isPublished: true,
      createdAt: DateTime.now(),
      objectives: objectives,
      prerequisites: prerequisites,
      modules: const [],
    );

    _courseProvider.addCourse(newCourse);
    notifyListeners();
    return newCourse;
  }

  Future<void> updateCourse(CourseModel updated) async {
    _courseProvider.updateCourse(updated);
    notifyListeners();
  }

  Future<void> togglePublishStatus(CourseModel course) async {
    final updated = course.copyWith(isPublished: !course.isPublished);
    _courseProvider.updateCourse(updated);
    notifyListeners();
  }

  Future<void> addModuleToCourse({
    required String courseId,
    required String title,
    required String description,
  }) async {
    final course = _courseProvider.getCourseById(courseId);
    if (course == null) return;

    final newModule = ModuleModel(
      id: const Uuid().v4(),
      courseId: courseId,
      title: title,
      orderIndex: course.modules.length,
      description: description,
      lessons: const [],
    );

    final updatedModules = List<ModuleModel>.from(course.modules)..add(newModule);
    final updatedCourse = course.copyWith(modules: updatedModules);
    _courseProvider.updateCourse(updatedCourse);
    notifyListeners();
  }

  Future<void> addLessonToModule({
    required String courseId,
    required String moduleId,
    required String title,
    required String content,
    int estimatedMinutes = 15,
    bool isFreePreview = false,
  }) async {
    final course = _courseProvider.getCourseById(courseId);
    if (course == null) return;

    final moduleIndex = course.modules.indexWhere((m) => m.id == moduleId);
    if (moduleIndex == -1) return;

    final targetModule = course.modules[moduleIndex];
    final newLesson = LessonModel(
      id: const Uuid().v4(),
      courseId: courseId,
      moduleId: moduleId,
      title: title,
      orderIndex: targetModule.lessons.length,
      content: content,
      estimatedMinutes: estimatedMinutes,
      isFreePreview: isFreePreview,
    );

    final updatedLessons = List<LessonModel>.from(targetModule.lessons)..add(newLesson);
    final updatedModule = ModuleModel(
      id: targetModule.id,
      courseId: targetModule.courseId,
      title: targetModule.title,
      orderIndex: targetModule.orderIndex,
      description: targetModule.description,
      lessons: updatedLessons,
    );

    final updatedModules = List<ModuleModel>.from(course.modules);
    updatedModules[moduleIndex] = updatedModule;

    final totalLessons = updatedModules.fold<int>(0, (sum, m) => sum + m.lessons.length);
    final updatedCourse = course.copyWith(
      modules: updatedModules,
      lessonCount: totalLessons,
    );

    _courseProvider.updateCourse(updatedCourse);
    notifyListeners();
  }
}
