import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../auth/models/user_model.dart';
import '../../courses/models/course_model.dart';
import '../../announcements/models/announcement_model.dart';
import '../../courses/providers/course_provider.dart';
import '../../learning/providers/learning_provider.dart';
import '../../quizzes/providers/quiz_provider.dart';
import '../../../seed/seed_data.dart';

class AdminProvider extends ChangeNotifier {
  final CourseProvider _courseProvider;
  final LearningProvider _learningProvider;
  final QuizProvider _quizProvider;

  List<UserModel> _users = [];
  List<AnnouncementModel> _announcements = [];
  List<Map<String, dynamic>> _issueReports = [];

  List<UserModel> get users => _users;
  List<AnnouncementModel> get announcements => _announcements;
  List<Map<String, dynamic>> get issueReports => _issueReports;

  AdminProvider(this._courseProvider, this._learningProvider, this._quizProvider) {
    _init();
  }

  void _init() {
    _users = List.from(SeedData.sampleUsers);
    _announcements = List.from(SeedData.sampleAnnouncements);
    _issueReports = [
      {
        'id': 'issue-01',
        'reportedBy': 'student@dlms.edu',
        'courseTitle': 'Programming Fundamentals: Python for Everyone',
        'message': 'Typo identified in Lesson 1.2 code snippet.',
        'status': 'Resolved',
        'createdAt': DateTime(2026, 2, 10),
      },
      {
        'id': 'issue-02',
        'reportedBy': 'student@dlms.edu',
        'courseTitle': 'Digital Literacy & Online Safety',
        'message': 'Audio narration link requested for accessibility.',
        'status': 'Under Review',
        'createdAt': DateTime(2026, 2, 14),
      },
    ];
  }

  int get totalUsersCount => _users.length;
  int get totalStudentsCount => _users.where((u) => u.isStudent).length;
  int get totalInstructorsCount => _users.where((u) => u.isInstructor).length;
  int get totalCoursesCount => _courseProvider.courses.length;
  int get totalEnrollmentsCount => _learningProvider.totalEnrolledCount;
  int get totalQuizzesCompleted => _quizProvider.totalAttemptsCount;

  void updateUserRole(String uid, String newRole) {
    final index = _users.indexWhere((u) => u.uid == uid);
    if (index != -1) {
      _users[index] = _users[index].copyWith(role: newRole);
      notifyListeners();
    }
  }

  void toggleCoursePublish(CourseModel course) {
    final updated = course.copyWith(isPublished: !course.isPublished);
    _courseProvider.updateCourse(updated);
    notifyListeners();
  }

  void addAnnouncement({
    required String title,
    required String content,
    required String authorName,
    required String priority,
  }) {
    final newAnn = AnnouncementModel(
      id: const Uuid().v4(),
      title: title,
      content: content,
      authorName: authorName,
      authorRole: 'admin',
      priority: priority,
      createdAt: DateTime.now(),
    );
    _announcements.insert(0, newAnn);
    notifyListeners();
  }

  void deleteAnnouncement(String id) {
    _announcements.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
