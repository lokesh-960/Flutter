class QuizQuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final int points;

  const QuizQuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    this.explanation = '',
    this.points = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'points': points,
    };
  }

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map) {
    return QuizQuestionModel(
      id: map['id'] as String? ?? '',
      questionText: map['questionText'] as String? ?? '',
      options: List<String>.from(map['options'] as List? ?? []),
      correctOptionIndex: map['correctOptionIndex'] as int? ?? 0,
      explanation: map['explanation'] as String? ?? '',
      points: map['points'] as int? ?? 1,
    );
  }
}

class QuizModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int timeLimitMinutes;
  final int passingScorePercentage;
  final List<QuizQuestionModel> questions;

  const QuizModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    this.timeLimitMinutes = 15,
    this.passingScorePercentage = 70,
    this.questions = const [],
  });

  int get totalPoints => questions.fold(0, (sum, q) => sum + q.points);
  int get questionCount => questions.length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'timeLimitMinutes': timeLimitMinutes,
      'passingScorePercentage': passingScorePercentage,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
      title: map['title'] as String? ?? 'Quiz Assessment',
      description: map['description'] as String? ?? '',
      timeLimitMinutes: map['timeLimitMinutes'] as int? ?? 15,
      passingScorePercentage: map['passingScorePercentage'] as int? ?? 70,
      questions: (map['questions'] as List? ?? [])
          .map((q) => QuizQuestionModel.fromMap(Map<String, dynamic>.from(q as Map)))
          .toList(),
    );
  }
}
