import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/progress_badge.dart';
import '../../courses/providers/course_provider.dart';
import '../../learning/providers/learning_provider.dart';
import '../../quizzes/providers/quiz_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final learning = context.watch<LearningProvider>();
    final quiz = context.watch<QuizProvider>();
    final courses = context.watch<CourseProvider>();

    final enrolledList = learning.enrollments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Progress & Milestones'),
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
                  // Overview Stats Grid
                  _buildSummaryCards(learning, quiz, isDark),
                  const SizedBox(height: 28),

                  // Achievement Badges Section
                  Text(
                    'Milestone Achievements',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementBadges(learning, quiz, isDark),
                  const SizedBox(height: 32),

                  // Course-by-Course Progress Breakdown
                  Text(
                    'Course-by-Course Breakdown',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (enrolledList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: Text(
                          'No courses enrolled yet. Browse the catalog to begin tracking progress.',
                          style: TextStyle(color: AppColors.textSecondaryLight),
                        ),
                      ),
                    )
                  else
                    ...enrolledList.map((enr) {
                      final course = courses.getCourseById(enr.courseId);
                      if (course == null) return const SizedBox.shrink();

                      final progress = enr.calculateProgress(course.lessonCount);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    course.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ProgressBadge(
                                  label: progress >= 1.0 ? 'Completed' : 'In Progress',
                                  color: progress >= 1.0 ? AppColors.success : AppColors.primary,
                                  isSmall: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${enr.completedLessonIds.length} of ${course.lessonCount} lessons completed',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress >= 1.0 ? AppColors.success : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(LearningProvider learning, QuizProvider quiz, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCol('Enrolled', '${learning.totalEnrolledCount}', AppColors.primary),
          _buildSummaryCol('Completed', '${learning.completedCoursesCount}', AppColors.success),
          _buildSummaryCol('Lessons', '${learning.totalCompletedLessonsCount}', AppColors.secondary),
          _buildSummaryCol('Quizzes', '${quiz.passedQuizzesCount}', AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildSummaryCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
        ),
      ],
    );
  }

  Widget _buildAchievementBadges(LearningProvider learning, QuizProvider quiz, bool isDark) {
    final badges = [
      {
        'title': 'First Step',
        'desc': 'Enrolled in your first course',
        'unlocked': learning.totalEnrolledCount > 0,
        'icon': Icons.flag_circle,
        'color': AppColors.primary,
      },
      {
        'title': 'Knowledge Seeker',
        'desc': 'Completed at least 2 structured lessons',
        'unlocked': learning.totalCompletedLessonsCount >= 2,
        'icon': Icons.menu_book,
        'color': AppColors.secondary,
      },
      {
        'title': 'Certified Scholar',
        'desc': 'Passed a curriculum certification quiz',
        'unlocked': quiz.passedQuizzesCount >= 1,
        'icon': Icons.workspace_premium,
        'color': AppColors.warning,
      },
      {
        'title': 'SDG 4 Champion',
        'desc': 'Advancing digital literacy & quality education',
        'unlocked': true,
        'icon': Icons.public,
        'color': AppColors.sdgRed,
      },
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: badges.map((badge) {
        final isUnlocked = badge['unlocked'] as bool;
        final color = badge['color'] as Color;

        return Container(
          width: 200,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUnlocked
                ? color.withOpacity(0.08)
                : (isDark ? AppColors.surfaceDark : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnlocked ? color.withOpacity(0.3) : Colors.grey.shade300,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                badge['icon'] as IconData,
                size: 28,
                color: isUnlocked ? color : Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                badge['title'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isUnlocked ? null : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                badge['desc'] as String,
                style: TextStyle(
                  fontSize: 11,
                  color: isUnlocked ? AppColors.textSecondaryLight : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
