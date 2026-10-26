import 'package:flutter_test/flutter_test.dart';
import 'package:dlms_app/features/courses/models/course_model.dart';
import 'package:dlms_app/features/courses/models/module_model.dart';
import 'package:dlms_app/features/courses/models/lesson_model.dart';

void main() {
  group('Course & Module Models Tests', () {
    test('CourseModel serialization toMap and fromMap works seamlessly', () {
      final now = DateTime.now();
      final course = CourseModel(
        id: 'test-c1',
        title: 'Test Course',
        description: 'Test Description',
        instructorId: 'inst-1',
        instructorName: 'Instructor Name',
        category: 'Programming Fundamentals',
        difficulty: 'Beginner',
        durationMinutes: 90,
        thumbnailUrl: 'https://example.com/thumb.jpg',
        createdAt: now,
        objectives: ['Learn A', 'Learn B'],
        prerequisites: ['Basic Logic'],
      );

      final map = course.toMap();
      final reconstructed = CourseModel.fromMap(map);

      expect(reconstructed.id, equals(course.id));
      expect(reconstructed.title, equals(course.title));
      expect(reconstructed.category, equals(course.category));
      expect(reconstructed.objectives.length, equals(2));
    });

    test('Module total minutes calculates sum of estimated lesson times', () {
      const module = ModuleModel(
        id: 'mod-1',
        courseId: 'c-1',
        title: 'Module 1',
        orderIndex: 0,
        lessons: [
          LessonModel(
            id: 'l1',
            courseId: 'c-1',
            moduleId: 'mod-1',
            title: 'L1',
            orderIndex: 0,
            content: 'Content',
            estimatedMinutes: 20,
          ),
          LessonModel(
            id: 'l2',
            courseId: 'c-1',
            moduleId: 'mod-1',
            title: 'L2',
            orderIndex: 1,
            content: 'Content',
            estimatedMinutes: 30,
          ),
        ],
      );

      expect(module.totalMinutes, equals(50));
    });
  });
}
