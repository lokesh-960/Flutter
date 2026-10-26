import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/progress_badge.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/instructor_provider.dart';
import '../../courses/models/course_model.dart';

class InstructorDashboardScreen extends StatelessWidget {
  const InstructorDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final instructor = context.watch<InstructorProvider>();

    final user = auth.currentUser;
    final instructorId = user?.uid ?? 'instructor-demo-01';
    final myCourses = instructor.getCoursesForInstructor(instructorId);
    final totalStudents = instructor.getTotalStudents(instructorId);
    final publishedCount = instructor.getPublishedCount(instructorId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructor Academic Studio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/instructor/create-course'),
        icon: const Icon(Icons.add),
        label: const Text('Create Course'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Studio Header
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instructor Console — ${user?.displayName ?? 'Professor'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Manage curriculum modules, author verified quizzes, and track cohort enrollment.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.architecture_rounded, size: 48, color: Colors.white70),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Analytics Summary
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          'Courses Created',
                          '${myCourses.length}',
                          Icons.menu_book,
                          AppColors.primary,
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          'Published Courses',
                          '$publishedCount',
                          Icons.visibility,
                          AppColors.success,
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          'Enrolled Students',
                          '$totalStudents',
                          Icons.groups,
                          AppColors.secondary,
                          isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Course Management List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Authored Curricula',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () => context.push('/instructor/create-course'),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Course'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (myCourses.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.auto_stories, size: 40, color: AppColors.textMutedLight),
                            const SizedBox(height: 12),
                            const Text(
                              'You have not created any courses yet.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.push('/instructor/create-course'),
                              child: const Text('Create First Course'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...myCourses.map((c) => _buildCourseRow(context, c, instructor, isDark)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseRow(
    BuildContext context,
    CourseModel course,
    InstructorProvider instructor,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 80,
              height: 60,
              color: AppColors.primaryContainer,
              child: course.thumbnailUrl.isNotEmpty
                  ? Image.network(
                      course.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.school, color: AppColors.primary),
                    )
                  : const Icon(Icons.school, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProgressBadge(
                      label: course.isPublished ? 'Published' : 'Draft',
                      color: course.isPublished ? AppColors.success : AppColors.warning,
                      isSmall: true,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      course.category,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  course.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${course.modules.length} modules • ${course.lessonCount} lessons • ${course.enrollmentCount} students enrolled',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              course.isPublished ? Icons.visibility : Icons.visibility_off,
              color: course.isPublished ? AppColors.success : AppColors.textMutedLight,
            ),
            tooltip: course.isPublished ? 'Unpublish Course' : 'Publish Course',
            onPressed: () => instructor.togglePublishStatus(course),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Course & Curriculum',
            onPressed: () => context.push('/instructor/edit-course/${course.id}'),
          ),
        ],
      ),
    );
  }
}
