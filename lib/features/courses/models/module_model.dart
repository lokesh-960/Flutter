import 'lesson_model.dart';

class ModuleModel {
  final String id;
  final String courseId;
  final String title;
  final int orderIndex;
  final String description;
  final List<LessonModel> lessons;

  const ModuleModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.orderIndex,
    this.description = '',
    this.lessons = const [],
  });

  int get totalMinutes => lessons.fold(0, (sum, l) => sum + l.estimatedMinutes);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'orderIndex': orderIndex,
      'description': description,
      'lessons': lessons.map((l) => l.toMap()).toList(),
    };
  }

  factory ModuleModel.fromMap(Map<String, dynamic> map) {
    return ModuleModel(
      id: map['id'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Module',
      orderIndex: map['orderIndex'] as int? ?? 0,
      description: map['description'] as String? ?? '',
      lessons: (map['lessons'] as List? ?? [])
          .map((item) => LessonModel.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}
