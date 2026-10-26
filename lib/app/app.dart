import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'app_theme.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/courses/providers/course_provider.dart';
import '../features/learning/providers/learning_provider.dart';
import '../features/quizzes/providers/quiz_provider.dart';
import '../features/instructor/providers/instructor_provider.dart';
import '../features/admin/providers/admin_provider.dart';

class DLMSApp extends StatelessWidget {
  const DLMSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => LearningProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProxyProvider2<CourseProvider, QuizProvider, InstructorProvider>(
          create: (context) => InstructorProvider(
            context.read<CourseProvider>(),
            context.read<QuizProvider>(),
          ),
          update: (_, course, quiz, previous) =>
              previous ?? InstructorProvider(course, quiz),
        ),
        ChangeNotifierProxyProvider3<CourseProvider, LearningProvider, QuizProvider, AdminProvider>(
          create: (context) => AdminProvider(
            context.read<CourseProvider>(),
            context.read<LearningProvider>(),
            context.read<QuizProvider>(),
          ),
          update: (_, course, learning, quiz, previous) =>
              previous ?? AdminProvider(course, learning, quiz),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final router = createRouter(authProvider);

          return MaterialApp.router(
            title: 'Digital Learning Management System',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
