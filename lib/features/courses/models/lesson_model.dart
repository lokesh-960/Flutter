class LessonModel {
  final String id;
  final String courseId;
  final String moduleId;
  final String title;
  final int orderIndex;
  final String content;
  final String? videoUrl;
  final List<String> resourceUrls;
  final int estimatedMinutes;
  final bool isFreePreview;

  const LessonModel({
    required this.id,
    required this.courseId,
    required this.moduleId,
    required this.title,
    required this.orderIndex,
    required this.content,
    this.videoUrl,
    this.resourceUrls = const [],
    this.estimatedMinutes = 15,
    this.isFreePreview = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'moduleId': moduleId,
      'title': title,
      'orderIndex': orderIndex,
      'content': content,
      'videoUrl': videoUrl,
      'resourceUrls': resourceUrls,
      'estimatedMinutes': estimatedMinutes,
      'isFreePreview': isFreePreview,
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
      moduleId: map['moduleId'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Lesson',
      orderIndex: map['orderIndex'] as int? ?? 0,
      content: map['content'] as String? ?? '',
      videoUrl: map['videoUrl'] as String?,
      resourceUrls: List<String>.from(map['resourceUrls'] as List? ?? []),
      estimatedMinutes: map['estimatedMinutes'] as int? ?? 15,
      isFreePreview: map['isFreePreview'] as bool? ?? false,
    );
  }
}
