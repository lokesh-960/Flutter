import 'module_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final String instructorName;
  final String category;
  final String difficulty;
  final int durationMinutes;
  final int lessonCount;
  final int enrollmentCount;
  final String thumbnailUrl;
  final bool isPublished;
  final DateTime createdAt;
  final List<String> objectives;
  final List<String> prerequisites;
  final List<ModuleModel> modules;
  final String? quizId;
  final bool isFeatured;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.category,
    this.difficulty = 'Beginner',
    this.durationMinutes = 60,
    this.lessonCount = 0,
    this.enrollmentCount = 0,
    required this.thumbnailUrl,
    this.isPublished = true,
    required this.createdAt,
    this.objectives = const [],
    this.prerequisites = const [],
    this.modules = const [],
    this.quizId,
    this.isFeatured = false,
  });

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? instructorId,
    String? instructorName,
    String? category,
    String? difficulty,
    int? durationMinutes,
    int? lessonCount,
    int? enrollmentCount,
    String? thumbnailUrl,
    bool? isPublished,
    DateTime? createdAt,
    List<String>? objectives,
    List<String>? prerequisites,
    List<ModuleModel>? modules,
    String? quizId,
    bool? isFeatured,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      lessonCount: lessonCount ?? this.lessonCount,
      enrollmentCount: enrollmentCount ?? this.enrollmentCount,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      objectives: objectives ?? this.objectives,
      prerequisites: prerequisites ?? this.prerequisites,
      modules: modules ?? this.modules,
      quizId: quizId ?? this.quizId,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'category': category,
      'difficulty': difficulty,
      'durationMinutes': durationMinutes,
      'lessonCount': lessonCount,
      'enrollmentCount': enrollmentCount,
      'thumbnailUrl': thumbnailUrl,
      'isPublished': isPublished,
      'createdAt': createdAt.toIso8601String(),
      'objectives': objectives,
      'prerequisites': prerequisites,
      'modules': modules.map((m) => m.toMap()).toList(),
      'quizId': quizId,
      'isFeatured': isFeatured,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Course',
      description: map['description'] as String? ?? '',
      instructorId: map['instructorId'] as String? ?? '',
      instructorName: map['instructorName'] as String? ?? 'Academic Instructor',
      category: map['category'] as String? ?? 'General',
      difficulty: map['difficulty'] as String? ?? 'Beginner',
      durationMinutes: map['durationMinutes'] as int? ?? 60,
      lessonCount: map['lessonCount'] as int? ?? 0,
      enrollmentCount: map['enrollmentCount'] as int? ?? 0,
      thumbnailUrl: map['thumbnailUrl'] as String? ?? '',
      isPublished: map['isPublished'] as bool? ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      objectives: List<String>.from(map['objectives'] as List? ?? []),
      prerequisites: List<String>.from(map['prerequisites'] as List? ?? []),
      modules: (map['modules'] as List? ?? [])
          .map((m) => ModuleModel.fromMap(Map<String, dynamic>.from(m as Map)))
          .toList(),
      quizId: map['quizId'] as String?,
      isFeatured: map['isFeatured'] as bool? ?? false,
    );
  }
}
