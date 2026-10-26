class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String authorRole;
  final String? courseId;
  final String priority; // 'high' | 'normal' | 'low'
  final DateTime createdAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorRole,
    this.courseId,
    this.priority = 'normal',
    required this.createdAt,
  });

  bool get isGlobal => courseId == null || courseId!.isEmpty;
  bool get isHighPriority => priority == 'high';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorName': authorName,
      'authorRole': authorRole,
      'courseId': courseId,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Announcement',
      content: map['content'] as String? ?? '',
      authorName: map['authorName'] as String? ?? 'Administrator',
      authorRole: map['authorRole'] as String? ?? 'admin',
      courseId: map['courseId'] as String?,
      priority: map['priority'] as String? ?? 'normal',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
