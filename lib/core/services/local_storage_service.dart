import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../features/auth/models/user_model.dart';
import '../../features/learning/models/enrollment_model.dart';
import '../../features/quizzes/models/quiz_attempt_model.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _prefs;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // --- Auth User Persistence ---
  Future<void> saveUser(UserModel user) async {
    await _prefs?.setString(AppConstants.keyAuthUser, jsonEncode(user.toMap()));
  }

  UserModel? getUser() {
    final raw = _prefs?.getString(AppConstants.keyAuthUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() async {
    await _prefs?.remove(AppConstants.keyAuthUser);
  }

  // --- Enrollments Persistence ---
  Future<void> saveEnrollments(List<EnrollmentModel> enrollments) async {
    final list = enrollments.map((e) => e.toMap()).toList();
    await _prefs?.setString(AppConstants.keyEnrollments, jsonEncode(list));
  }

  List<EnrollmentModel> getEnrollments() {
    final raw = _prefs?.getString(AppConstants.keyEnrollments);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((item) => EnrollmentModel.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // --- Bookmarks Persistence ---
  Future<void> saveBookmarks(List<String> courseIds) async {
    await _prefs?.setStringList(AppConstants.keyBookmarks, courseIds);
  }

  List<String> getBookmarks() {
    return _prefs?.getStringList(AppConstants.keyBookmarks) ?? [];
  }

  // --- Quiz Attempts Persistence ---
  Future<void> saveQuizAttempts(List<QuizAttemptModel> attempts) async {
    final list = attempts.map((a) => a.toMap()).toList();
    await _prefs?.setString('dlms_quiz_attempts', jsonEncode(list));
  }

  List<QuizAttemptModel> getQuizAttempts() {
    final raw = _prefs?.getString('dlms_quiz_attempts');
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((item) => QuizAttemptModel.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // --- Theme Mode Persistence ---
  Future<void> saveThemeMode(bool isDark) async {
    await _prefs?.setBool(AppConstants.keyThemeMode, isDark);
  }

  bool isDarkMode() {
    return _prefs?.getBool(AppConstants.keyThemeMode) ?? false;
  }
}
