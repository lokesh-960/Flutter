class EnrollmentModel {
  final String id;
  final String userId;
  final String courseId;
  final DateTime enrolledAt;
  final List<String> completedLessonIds;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? lastAccessedLessonId;
  final DateTime lastAccessedAt;

  const EnrollmentModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
    this.completedLessonIds = const [],
    this.isCompleted = false,
    this.completedAt,
    this.lastAccessedLessonId,
    required this.lastAccessedAt,
  });

  double calculateProgress(int totalLessons) {
    if (totalLessons <= 0) return 0.0;
    final progress = completedLessonIds.length / totalLessons;
    return progress > 1.0 ? 1.0 : progress;
  }

  int get progressPercentage => (calculateProgress(100) * 100).round();

  EnrollmentModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    DateTime? enrolledAt,
    List<String>? completedLessonIds,
    bool? isCompleted,
    DateTime? completedAt,
    String? lastAccessedLessonId,
    DateTime? lastAccessedAt,
  }) {
    return EnrollmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      lastAccessedLessonId: lastAccessedLessonId ?? this.lastAccessedLessonId,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'enrolledAt': enrolledAt.toIso8601String(),
      'completedLessonIds': completedLessonIds,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'lastAccessedLessonId': lastAccessedLessonId,
      'lastAccessedAt': lastAccessedAt.toIso8601String(),
    };
  }

  factory EnrollmentModel.fromMap(Map<String, dynamic> map) {
    return EnrollmentModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
      enrolledAt: map['enrolledAt'] != null
          ? DateTime.tryParse(map['enrolledAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      completedLessonIds: List<String>.from(map['completedLessonIds'] as List? ?? []),
      isCompleted: map['isCompleted'] as bool? ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String)
          : null,
      lastAccessedLessonId: map['lastAccessedLessonId'] as String?,
      lastAccessedAt: map['lastAccessedAt'] != null
          ? DateTime.tryParse(map['lastAccessedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
