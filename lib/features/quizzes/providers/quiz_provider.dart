import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../seed/seed_data.dart';
import '../models/quiz_model.dart';
import '../models/quiz_attempt_model.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizModel> _quizzes = [];
  List<QuizAttemptModel> _attempts = [];
  bool _isLoading = false;

  List<QuizModel> get quizzes => _quizzes;
  List<QuizAttemptModel> get attempts => _attempts;
  bool get isLoading => _isLoading;

  int get totalAttemptsCount => _attempts.length;
  int get passedQuizzesCount => _attempts.where((a) => a.passed).length;

  double get averageScorePercentage {
    if (_attempts.isEmpty) return 0.0;
    final sum = _attempts.fold(0.0, (acc, a) => acc + a.percentage);
    return sum / _attempts.length;
  }

  QuizProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    _quizzes = List.from(SeedData.sampleQuizzes);

    final storage = await LocalStorageService.getInstance();
    _attempts = storage.getQuizAttempts();

    _isLoading = false;
    notifyListeners();
  }

  QuizModel? getQuizByCourseId(String courseId) {
    try {
      return _quizzes.firstWhere((q) => q.courseId == courseId);
    } catch (_) {
      return null;
    }
  }

  QuizModel? getQuizById(String quizId) {
    try {
      return _quizzes.firstWhere((q) => q.id == quizId);
    } catch (_) {
      return null;
    }
  }

  List<QuizAttemptModel> getAttemptsForQuiz(String quizId, String userId) {
    return _attempts
        .where((a) => a.quizId == quizId && a.userId == userId)
        .toList();
  }

  QuizAttemptModel? getBestAttempt(String quizId, String userId) {
    final list = getAttemptsForQuiz(quizId, userId);
    if (list.isEmpty) return null;
    list.sort((a, b) => b.score.compareTo(a.score));
    return list.first;
  }

  /// Authoritative server/backend score calculation
  Future<QuizAttemptModel> submitQuizAttempt({
    required QuizModel quiz,
    required String userId,
    required Map<String, int> answers,
  }) async {
    _isLoading = true;
    notifyListeners();

    int earnedScore = 0;
    int totalPossiblePoints = 0;

    for (final question in quiz.questions) {
      totalPossiblePoints += question.points;
      final selectedOption = answers[question.id];
      if (selectedOption != null && selectedOption == question.correctOptionIndex) {
        earnedScore += question.points;
      }
    }

    final double calculatedPercentage = totalPossiblePoints > 0
        ? (earnedScore / totalPossiblePoints) * 100
        : 0.0;

    final bool isPassed = calculatedPercentage >= quiz.passingScorePercentage;

    final attempt = QuizAttemptModel(
      id: const Uuid().v4(),
      quizId: quiz.id,
      courseId: quiz.courseId,
      userId: userId,
      score: earnedScore,
      totalPoints: totalPossiblePoints,
      percentage: calculatedPercentage,
      passed: isPassed,
      selectedAnswers: answers,
      submittedAt: DateTime.now(),
    );

    _attempts.insert(0, attempt);

    final storage = await LocalStorageService.getInstance();
    await storage.saveQuizAttempts(_attempts);

    _isLoading = false;
    notifyListeners();
    return attempt;
  }

  // Instructor/Admin Quiz Creation & Editing
  void addQuiz(QuizModel quiz) {
    _quizzes.add(quiz);
    notifyListeners();
  }

  void updateQuiz(QuizModel updated) {
    final index = _quizzes.indexWhere((q) => q.id == updated.id);
    if (index != -1) {
      _quizzes[index] = updated;
      notifyListeners();
    }
  }
}
