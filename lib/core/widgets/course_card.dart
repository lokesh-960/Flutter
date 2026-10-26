import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/date_formatter.dart';
import '../../features/courses/models/course_model.dart';
import 'progress_badge.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final double? progress; // null if not enrolled, 0.0 - 1.0 if enrolled
  final bool isCompact;

  const CourseCard({
    Key? key,
    required this.course,
    required this.onTap,
    this.progress,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with gradient overlay & badges
            Stack(
              children: [
                Container(
                  height: isCompact ? 130 : 160,
                  width: double.infinity,
                  color: isDark ? AppColors.surfaceDark : AppColors.primaryContainer,
                  child: course.thumbnailUrl.isNotEmpty
                      ? Image.network(
                          course.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildFallbackHeader(),
                        )
                      : _buildFallbackHeader(),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: ProgressBadge(
                    label: course.difficulty,
                    isSmall: true,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.formatDuration(course.durationMinutes),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.menu_book_outlined, size: 13, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 3),
                          Text(
                            '${course.lessonCount} lessons',
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isCompact) ...[
                    const SizedBox(height: 6),
                    Text(
                      course.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.primaryContainer,
                        child: Icon(Icons.person, size: 12, color: AppColors.primary),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          course.instructorName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (course.enrollmentCount > 0)
                        Row(
                          children: [
                            const Icon(Icons.group_outlined, size: 13, color: AppColors.textMutedLight),
                            const SizedBox(width: 3),
                            Text(
                              '${course.enrollmentCount}',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                    ],
                  ),

                  // Progress Bar if enrolled
                  if (progress != null) ...[
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              progress! >= 1.0 ? 'Completed' : 'Course Progress',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: progress! >= 1.0
                                    ? AppColors.success
                                    : theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              '${(progress! * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: isDark
                                ? AppColors.borderDark
                                : AppColors.primaryContainer.withOpacity(0.5),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress! >= 1.0 ? AppColors.success : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.school, size: 48, color: Colors.white70),
      ),
    );
  }
}
