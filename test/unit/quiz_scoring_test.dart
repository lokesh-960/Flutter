import 'package:flutter_test/flutter_test.dart';
import 'package:dlms_app/features/quizzes/models/quiz_model.dart';

void main() {
  group('Quiz Engine & Scoring Tests', () {
    const testQuiz = QuizModel(
      id: 'quiz-unit-test',
      courseId: 'course-101',
      title: 'Unit Test Assessment',
      description: 'Testing authoritative scoring logic',
      timeLimitMinutes: 10,
      passingScorePercentage: 75,
      questions: [
        QuizQuestionModel(
          id: 'q1',
          questionText: 'Question 1',
          options: ['Option A', 'Option B', 'Option C'],
          correctOptionIndex: 1, // Option B
          points: 2,
        ),
        QuizQuestionModel(
          id: 'q2',
          questionText: 'Question 2',
          options: ['Option X', 'Option Y', 'Option Z'],
          correctOptionIndex: 0, // Option X
          points: 2,
        ),
      ],
    );

    test('Quiz total points and questions count calculation', () {
      expect(testQuiz.questionCount, equals(2));
      expect(testQuiz.totalPoints, equals(4));
    });

    test('Authoritative scoring correctly calculates perfect score', () {
      final userAnswers = {'q1': 1, 'q2': 0}; // Both correct

      int score = 0;
      for (final q in testQuiz.questions) {
        if (userAnswers[q.id] == q.correctOptionIndex) {
          score += q.points;
        }
      }

      final percentage = (score / testQuiz.totalPoints) * 100;
      final passed = percentage >= testQuiz.passingScorePercentage;

      expect(score, equals(4));
      expect(percentage, equals(100.0));
      expect(passed, isTrue);
    });

    test('Authoritative scoring fails when passing score is not met', () {
      final userAnswers = {'q1': 1, 'q2': 2}; // 1 correct (2 pts), 1 incorrect

      int score = 0;
      for (final q in testQuiz.questions) {
        if (userAnswers[q.id] == q.correctOptionIndex) {
          score += q.points;
        }
      }

      final percentage = (score / testQuiz.totalPoints) * 100; // 50%
      final passed = percentage >= testQuiz.passingScorePercentage; // 50% < 75%

      expect(score, equals(2));
      expect(percentage, equals(50.0));
      expect(passed, isFalse);
    });
  });
}
