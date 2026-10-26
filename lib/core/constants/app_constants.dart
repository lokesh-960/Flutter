class AppConstants {
  static const double defaultBorderRadius = 14.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 650.0;
  static const double tabletBreakpoint = 1050.0;

  // Quiz defaults
  static const int defaultPassingScorePercentage = 70;
  static const int defaultQuizTimeMinutes = 15;

  // Local Storage Keys
  static const String keyAuthUser = 'dlms_auth_user';
  static const String keyAuthToken = 'dlms_auth_token';
  static const String keyThemeMode = 'dlms_theme_mode';
  static const String keyEnrollments = 'dlms_enrollments';
  static const String keyBookmarks = 'dlms_bookmarks';
  static const String keyCompletedLessons = 'dlms_completed_lessons';
  static const String keyCachedCourses = 'dlms_cached_courses';
  static const String keyOfflineMode = 'dlms_offline_mode';
}
