import 'package:go_router/go_router.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/unauthorized_screen.dart';
import '../features/dashboard/screens/student_dashboard_screen.dart';
import '../features/courses/screens/course_catalog_screen.dart';
import '../features/courses/screens/course_details_screen.dart';
import '../features/learning/screens/lesson_player_screen.dart';
import '../features/quizzes/screens/quiz_screen.dart';
import '../features/quizzes/screens/quiz_result_screen.dart';
import '../features/progress/screens/progress_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/instructor/screens/instructor_dashboard_screen.dart';
import '../features/instructor/screens/course_editor_screen.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../features/admin/screens/user_management_screen.dart';
import '../features/impact/screens/sdg_impact_screen.dart';
import '../features/announcements/screens/announcements_screen.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/unauthorized',
        builder: (context, state) => const UnauthorizedScreen(),
      ),
      GoRoute(
        path: '/student',
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: '/courses',
        builder: (context, state) => const CourseCatalogScreen(),
      ),
      GoRoute(
        path: '/course-details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CourseDetailsScreen(courseId: id);
        },
      ),
      GoRoute(
        path: '/lesson/:courseId/:lessonId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          final lessonId = state.pathParameters['lessonId'] ?? '';
          return LessonPlayerScreen(courseId: courseId, lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/quiz/:quizId',
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          return QuizScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: '/quiz-result/:attemptId',
        builder: (context, state) {
          final attemptId = state.pathParameters['attemptId'] ?? '';
          return QuizResultScreen(attemptId: attemptId);
        },
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/instructor',
        builder: (context, state) {
          if (!authProvider.isInstructor && !authProvider.isAdmin) {
            return const UnauthorizedScreen();
          }
          return const InstructorDashboardScreen();
        },
      ),
      GoRoute(
        path: '/instructor/create-course',
        builder: (context, state) {
          if (!authProvider.isInstructor && !authProvider.isAdmin) {
            return const UnauthorizedScreen();
          }
          return const CourseEditorScreen();
        },
      ),
      GoRoute(
        path: '/instructor/edit-course/:id',
        builder: (context, state) {
          if (!authProvider.isInstructor && !authProvider.isAdmin) {
            return const UnauthorizedScreen();
          }
          final id = state.pathParameters['id'];
          return CourseEditorScreen(courseId: id);
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) {
          if (!authProvider.isAdmin) {
            return const UnauthorizedScreen();
          }
          return const AdminDashboardScreen();
        },
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) {
          if (!authProvider.isAdmin) {
            return const UnauthorizedScreen();
          }
          return const UserManagementScreen();
        },
      ),
      GoRoute(
        path: '/sdg-impact',
        builder: (context, state) => const SdgImpactScreen(),
      ),
      GoRoute(
        path: '/announcements',
        builder: (context, state) => const AnnouncementsScreen(),
      ),
    ],
  );
}
