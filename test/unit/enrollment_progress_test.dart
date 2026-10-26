import 'package:flutter_test/flutter_test.dart';
import 'package:dlms_app/features/learning/models/enrollment_model.dart';

void main() {
  group('Enrollment Progress Logic Tests', () {
    test('Calculates 0.0 progress for unstarted course', () {
      final enrollment = EnrollmentModel(
        id: 'enr-1',
        userId: 'user-1',
        courseId: 'course-1',
        enrolledAt: DateTime.now(),
        completedLessonIds: [],
        lastAccessedAt: DateTime.now(),
      );

      expect(enrollment.calculateProgress(4), equals(0.0));
      expect(enrollment.isCompleted, isFalse);
    });

    test('Calculates partial completion accurately based on genuine lesson count', () {
      final enrollment = EnrollmentModel(
        id: 'enr-1',
        userId: 'user-1',
        courseId: 'course-1',
        enrolledAt: DateTime.now(),
        completedLessonIds: ['les-1', 'les-2'],
        lastAccessedAt: DateTime.now(),
      );

      // 2 out of 4 lessons = 0.5 (50%)
      expect(enrollment.calculateProgress(4), equals(0.5));
    });

    test('Calculates 100% completion when all lessons are finished', () {
      final enrollment = EnrollmentModel(
        id: 'enr-1',
        userId: 'user-1',
        courseId: 'course-1',
        enrolledAt: DateTime.now(),
        completedLessonIds: ['les-1', 'les-2', 'les-3', 'les-4'],
        isCompleted: true,
        lastAccessedAt: DateTime.now(),
      );

      expect(enrollment.calculateProgress(4), equals(1.0));
      expect(enrollment.isCompleted, isTrue);
    });

    test('Handles zero total lessons edge case gracefully', () {
      final enrollment = EnrollmentModel(
        id: 'enr-1',
        userId: 'user-1',
        courseId: 'course-1',
        enrolledAt: DateTime.now(),
        completedLessonIds: [],
        lastAccessedAt: DateTime.now(),
      );

      expect(enrollment.calculateProgress(0), equals(0.0));
    });
  });
}
