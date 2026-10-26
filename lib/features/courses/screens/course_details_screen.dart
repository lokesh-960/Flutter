import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/progress_badge.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/course_provider.dart';
import '../../learning/providers/learning_provider.dart';
import '../../quizzes/providers/quiz_provider.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailsScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final courseProvider = context.watch<CourseProvider>();
    final learningProvider = context.watch<LearningProvider>();
    final authProvider = context.watch<AuthProvider>();
    final quizProvider = context.watch<QuizProvider>();

    final course = courseProvider.getCourseById(courseId);

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Not Found')),
        body: const Center(child: Text('The requested course does not exist.')),
      );
    }

    final isEnrolled = learningProvider.isEnrolled(courseId);
    final progress = isEnrolled
        ? learningProvider.getCourseProgress(courseId, course.lessonCount)
        : null;
    final isBookmarked = courseProvider.isBookmarked(courseId);
    final quiz = quizProvider.getQuizByCourseId(courseId);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.primary : null,
            ),
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark Course',
            onPressed: () => courseProvider.toggleBookmark(courseId),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Header with Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      color: AppColors.primaryContainer,
                      child: course.thumbnailUrl.isNotEmpty
                          ? Image.network(
                              course.thumbnailUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildFallbackImage(),
                            )
                          : _buildFallbackImage(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category & Badges Row
                  Row(
                    children: [
                      ProgressBadge(label: course.category, color: AppColors.primary),
                      const SizedBox(width: 8),
                      ProgressBadge(label: course.difficulty),
                      const Spacer(),
                      const Icon(Icons.schedule, size: 16, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDuration(course.durationMinutes),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title & Instructor
                  Text(
                    course.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primaryContainer,
                        child: Icon(Icons.person, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Taught by ${course.instructorName}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Enrollment & Progress Action Card
                  _buildEnrollmentActionCard(
                    context: context,
                    isEnrolled: isEnrolled,
                    progress: progress,
                    course: course,
                    authProvider: authProvider,
                    learningProvider: learningProvider,
                    theme: theme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About This Course',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Learning Objectives
                  if (course.objectives.isNotEmpty) ...[
                    Text(
                      'What You Will Learn',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...course.objectives.map((obj) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle, size: 18, color: AppColors.success),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(obj, style: theme.textTheme.bodyMedium),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                  ],

                  // Curriculum Structure (Modules & Lessons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Course Curriculum',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${course.modules.length} modules • ${course.lessonCount} lessons',
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...course.modules.map((module) => _buildModuleCard(
                        context: context,
                        module: module,
                        isEnrolled: isEnrolled,
                        courseId: course.id,
                        learningProvider: learningProvider,
                        theme: theme,
                        isDark: isDark,
                      )),
                  const SizedBox(height: 24),

                  // Assessment / Quiz Card
                  if (quiz != null)
                    _buildQuizCard(
                      context: context,
                      quiz: quiz,
                      isEnrolled: isEnrolled,
                      courseId: course.id,
                      theme: theme,
                      isDark: isDark,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnrollmentActionCard({
    required BuildContext context,
    required bool isEnrolled,
    required double? progress,
    required dynamic course,
    required AuthProvider authProvider,
    required LearningProvider learningProvider,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEnrolled) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified, size: 18, color: AppColors.success),
                    SizedBox(width: 6),
                    Text(
                      'You are enrolled in this course',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  '${((progress ?? 0) * 100).toInt()}% completed',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress ?? 0.0,
                minHeight: 8,
                backgroundColor: AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                  (progress ?? 0.0) >= 1.0 ? AppColors.success : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: (progress ?? 0.0) >= 1.0 ? 'Review Lessons' : 'Continue Learning',
              icon: Icons.play_arrow,
              onPressed: () {
                // Navigate to first lesson
                if (course.modules.isNotEmpty && course.modules.first.lessons.isNotEmpty) {
                  final firstLesson = course.modules.first.lessons.first;
                  context.push('/lesson/${course.id}/${firstLesson.id}');
                }
              },
            ),
          ] else ...[
            const Row(
              children: [
                Icon(Icons.public, size: 20, color: AppColors.sdgRed),
                SizedBox(width: 8),
                Text(
                  'Open Access Learning (SDG 4)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Free enrollment provided under our equitable quality education commitment. Access all modules, source code, and certified assessments.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Enroll Now (Free Access)',
              icon: Icons.school_outlined,
              onPressed: () async {
                final userId = authProvider.currentUser?.uid ?? 'guest-student';
                final success = await learningProvider.enrollInCourse(
                  courseId: course.id,
                  userId: userId,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enrollment successful! Welcome to the course.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required BuildContext context,
    required dynamic module,
    required bool isEnrolled,
    required String courseId,
    required LearningProvider learningProvider,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          module.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          '${module.lessons.length} lessons • ${DateFormatter.formatDuration(module.totalMinutes)}',
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
        ),
        children: module.lessons.map<Widget>((lesson) {
          final isCompleted = learningProvider.isLessonCompleted(courseId, lesson.id);

          return ListTile(
            leading: Icon(
              isCompleted
                  ? Icons.check_circle
                  : (lesson.isFreePreview ? Icons.lock_open_outlined : Icons.play_circle_outline),
              color: isCompleted ? AppColors.success : theme.colorScheme.primary,
              size: 20,
            ),
            title: Text(
              lesson.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            subtitle: Text(
              DateFormatter.formatDuration(lesson.estimatedMinutes),
              style: const TextStyle(fontSize: 11),
            ),
            trailing: isEnrolled || lesson.isFreePreview
                ? const Icon(Icons.arrow_forward_ios, size: 12)
                : const Icon(Icons.lock_outline, size: 14, color: AppColors.textMutedLight),
            onTap: () {
              if (isEnrolled || lesson.isFreePreview) {
                context.push('/lesson/$courseId/${lesson.id}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enroll in this course to access this lesson.'),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuizCard({
    required BuildContext context,
    required dynamic quiz,
    required bool isEnrolled,
    required String courseId,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.quiz, color: AppColors.secondary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  '${quiz.questionCount} questions • ${quiz.timeLimitMinutes} min • Passing: ${quiz.passingScorePercentage}%',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
            onPressed: isEnrolled
                ? () => context.push('/quiz/${quiz.id}')
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enroll in this course to take the certification quiz.'),
                      ),
                    );
                  },
            child: const Text('Take Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.school, size: 56, color: Colors.white70),
      ),
    );
  }
}
