import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/local_storage_service.dart';
import '../models/enrollment_model.dart';

class LearningProvider extends ChangeNotifier {
  List<EnrollmentModel> _enrollments = [];
  bool _isLoading = false;

  List<EnrollmentModel> get enrollments => _enrollments;
  bool get isLoading => _isLoading;

  int get totalEnrolledCount => _enrollments.length;
  int get completedCoursesCount => _enrollments.where((e) => e.isCompleted).length;
  int get inProgressCoursesCount => _enrollments.where((e) => !e.isCompleted).length;
  int get totalCompletedLessonsCount =>
      _enrollments.fold(0, (sum, e) => sum + e.completedLessonIds.length);

  LearningProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    final storage = await LocalStorageService.getInstance();
    _enrollments = storage.getEnrollments();

    // Default sample enrollment for demo student
    if (_enrollments.isEmpty) {
      _enrollments = [
        EnrollmentModel(
          id: 'enr-demo-01',
          userId: 'student-demo-01',
          courseId: 'course-python-101',
          enrolledAt: DateTime(2026, 1, 16),
          completedLessonIds: ['les-py-1', 'les-py-2'],
          isCompleted: false,
          lastAccessedLessonId: 'les-py-2',
          lastAccessedAt: DateTime(2026, 2, 1),
        ),
      ];
      await storage.saveEnrollments(_enrollments);
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isEnrolled(String courseId) {
    return _enrollments.any((e) => e.courseId == courseId);
  }

  EnrollmentModel? getEnrollment(String courseId) {
    try {
      return _enrollments.firstWhere((e) => e.courseId == courseId);
    } catch (_) {
      return null;
    }
  }

  double getCourseProgress(String courseId, int totalLessons) {
    final enrollment = getEnrollment(courseId);
    if (enrollment == null) return 0.0;
    return enrollment.calculateProgress(totalLessons);
  }

  Future<bool> enrollInCourse({
    required String courseId,
    required String userId,
  }) async {
    // Duplicate prevention
    if (isEnrolled(courseId)) {
      return false;
    }

    final newEnrollment = EnrollmentModel(
      id: const Uuid().v4(),
      userId: userId,
      courseId: courseId,
      enrolledAt: DateTime.now(),
      completedLessonIds: const [],
      isCompleted: false,
      lastAccessedAt: DateTime.now(),
    );

    _enrollments.insert(0, newEnrollment);

    final storage = await LocalStorageService.getInstance();
    await storage.saveEnrollments(_enrollments);

    notifyListeners();
    return true;
  }

  Future<void> markLessonComplete({
    required String courseId,
    required String lessonId,
    required int totalLessons,
  }) async {
    final index = _enrollments.indexWhere((e) => e.courseId == courseId);
    if (index == -1) return;

    final current = _enrollments[index];
    final updatedLessonIds = List<String>.from(current.completedLessonIds);

    if (!updatedLessonIds.contains(lessonId)) {
      updatedLessonIds.add(lessonId);
    }

    final isNowCompleted = totalLessons > 0 && updatedLessonIds.length >= totalLessons;

    final updated = current.copyWith(
      completedLessonIds: updatedLessonIds,
      isCompleted: isNowCompleted,
      completedAt: isNowCompleted ? (current.completedAt ?? DateTime.now()) : null,
      lastAccessedLessonId: lessonId,
      lastAccessedAt: DateTime.now(),
    );

    _enrollments[index] = updated;

    final storage = await LocalStorageService.getInstance();
    await storage.saveEnrollments(_enrollments);

    notifyListeners();
  }

  bool isLessonCompleted(String courseId, String lessonId) {
    final enrollment = getEnrollment(courseId);
    if (enrollment == null) return false;
    return enrollment.completedLessonIds.contains(lessonId);
  }
}
