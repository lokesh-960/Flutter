class QuizAttemptModel {
  final String id;
  final String quizId;
  final String courseId;
  final String userId;
  final int score;
  final int totalPoints;
  final double percentage;
  final bool passed;
  final Map<String, int> selectedAnswers; // questionId -> selectedOptionIndex
  final DateTime submittedAt;

  const QuizAttemptModel({
    required this.id,
    required this.quizId,
    required this.courseId,
    required this.userId,
    required this.score,
    required this.totalPoints,
    required this.percentage,
    required this.passed,
    required this.selectedAnswers,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quizId': quizId,
      'courseId': courseId,
      'userId': userId,
      'score': score,
      'totalPoints': totalPoints,
      'percentage': percentage,
      'passed': passed,
      'selectedAnswers': selectedAnswers,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory QuizAttemptModel.fromMap(Map<String, dynamic> map) {
    return QuizAttemptModel(
      id: map['id'] as String? ?? '',
      quizId: map['quizId'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      score: map['score'] as int? ?? 0,
      totalPoints: map['totalPoints'] as int? ?? 0,
      percentage: (map['percentage'] as num? ?? 0.0).toDouble(),
      passed: map['passed'] as bool? ?? false,
      selectedAnswers: Map<String, int>.from(map['selectedAnswers'] as Map? ?? {}),
      submittedAt: map['submittedAt'] != null
          ? DateTime.tryParse(map['submittedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
