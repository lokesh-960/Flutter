import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/course_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../courses/providers/course_provider.dart';
import '../../learning/providers/learning_provider.dart';
import '../../quizzes/providers/quiz_provider.dart';
import '../../admin/providers/admin_provider.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final courses = context.watch<CourseProvider>();
    final learning = context.watch<LearningProvider>();
    final quiz = context.watch<QuizProvider>();
    final admin = context.watch<AdminProvider>();

    final user = auth.currentUser;
    final userName = user?.displayName ?? 'Learner';

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.school, color: AppColors.primary),
            SizedBox(width: 8),
            Text(AppStrings.appShortName, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'SDG 4 Quality Education Impact',
            onPressed: () => context.push('/sdg-impact'),
          ),
          IconButton(
            icon: const Icon(Icons.campaign_outlined),
            tooltip: 'Announcements',
            onPressed: () => context.push('/announcements'),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile & Settings',
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner
                  _buildWelcomeBanner(context, userName, isDark),
                  const SizedBox(height: 24),

                  // Analytics Metric Cards
                  _buildMetricCards(context, learning, quiz, isDark),
                  const SizedBox(height: 28),

                  // Quick Action Navigation Bar
                  _buildQuickActionBar(context),
                  const SizedBox(height: 28),

                  // Enrolled Courses (Continue Learning)
                  _buildEnrolledCoursesSection(context, learning, courses),
                  const SizedBox(height: 32),

                  // Featured Courses Catalog Preview
                  _buildFeaturedCoursesSection(context, courses, learning),
                  const SizedBox(height: 32),

                  // Global Announcements Section
                  _buildAnnouncementsSection(context, admin, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, String userName, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SDG 4: Quality Education Platform',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome back, $userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Continue your self-paced learning journey with free, open-access STEM modules.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white24,
            child: Icon(Icons.auto_stories, size: 36, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCards(
    BuildContext context,
    LearningProvider learning,
    QuizProvider quiz,
    bool isDark,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        final cardWidth = isNarrow ? (constraints.maxWidth - 12) / 2 : (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildMetricItem(
              title: 'Enrolled Courses',
              value: '${learning.totalEnrolledCount}',
              icon: Icons.bookmark_added_outlined,
              color: AppColors.primary,
              width: cardWidth,
            ),
            _buildMetricItem(
              title: 'Completed Lessons',
              value: '${learning.totalCompletedLessonsCount}',
              icon: Icons.check_circle_outline,
              color: AppColors.success,
              width: cardWidth,
            ),
            _buildMetricItem(
              title: 'Quizzes Passed',
              value: '${quiz.passedQuizzesCount}',
              icon: Icons.quiz_outlined,
              color: AppColors.secondary,
              width: cardWidth,
            ),
            _buildMetricItem(
              title: 'Avg. Assessment',
              value: '${quiz.averageScorePercentage.toStringAsFixed(0)}%',
              icon: Icons.analytics_outlined,
              color: AppColors.warning,
              width: cardWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.push('/courses'),
            icon: const Icon(Icons.explore_outlined, size: 18),
            label: const Text('Browse Catalog'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/progress'),
            icon: const Icon(Icons.military_tech_outlined, size: 18),
            label: const Text('Achievements'),
          ),
        ),
      ],
    );
  }

  Widget _buildEnrolledCoursesSection(
    BuildContext context,
    LearningProvider learning,
    CourseProvider courses,
  ) {
    final theme = Theme.of(context);
    final enrolledList = learning.enrollments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Continue Learning',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (enrolledList.isNotEmpty)
              TextButton(
                onPressed: () => context.push('/courses'),
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (enrolledList.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Icon(Icons.auto_stories_outlined, size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text(
                  'No courses enrolled yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Discover foundational courses in programming, web development, and digital literacy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push('/courses'),
                  child: const Text('Explore Courses'),
                ),
              ],
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 550 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: enrolledList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.88,
                ),
                itemBuilder: (context, index) {
                  final enr = enrolledList[index];
                  final course = courses.getCourseById(enr.courseId);
                  if (course == null) return const SizedBox.shrink();

                  final progress = enr.calculateProgress(course.lessonCount);

                  return CourseCard(
                    course: course,
                    progress: progress,
                    onTap: () => context.push('/course-details/${course.id}'),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildFeaturedCoursesSection(
    BuildContext context,
    CourseProvider courses,
    LearningProvider learning,
  ) {
    final theme = Theme.of(context);
    final featured = courses.courses.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Curricula',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.push('/courses'),
              child: const Text('Explore Catalog'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 550 ? 2 : 1);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: featured.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                final course = featured[index];
                final isEnrolled = learning.isEnrolled(course.id);
                final progress = isEnrolled
                    ? learning.getCourseProgress(course.id, course.lessonCount)
                    : null;

                return CourseCard(
                  course: course,
                  progress: progress,
                  onTap: () => context.push('/course-details/${course.id}'),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnnouncementsSection(
    BuildContext context,
    AdminProvider admin,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final announcements = admin.announcements;

    if (announcements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.campaign, color: AppColors.secondary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Institutional Announcements',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...announcements.map((ann) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ann.isHighPriority ? AppColors.sdgRed.withOpacity(0.4) : (isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (ann.isHighPriority)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.sdgRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'URGENT',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          ann.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ann.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
