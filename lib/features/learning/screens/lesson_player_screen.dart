import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../courses/providers/course_provider.dart';
import '../providers/learning_provider.dart';
import '../../courses/models/lesson_model.dart';
import '../../courses/models/module_model.dart';

class LessonPlayerScreen extends StatelessWidget {
  final String courseId;
  final String lessonId;

  const LessonPlayerScreen({
    Key? key,
    required this.courseId,
    required this.lessonId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final courseProvider = context.watch<CourseProvider>();
    final learningProvider = context.watch<LearningProvider>();

    final course = courseProvider.getCourseById(courseId);

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: Text('Course not found.')),
      );
    }

    // Find current lesson and flatten all lessons to support prev/next
    LessonModel? currentLesson;
    ModuleModel? currentModule;
    final allLessons = <LessonModel>[];

    for (final mod in course.modules) {
      for (final les in mod.lessons) {
        allLessons.add(les);
        if (les.id == lessonId) {
          currentLesson = les;
          currentModule = mod;
        }
      }
    }

    if (currentLesson == null) {
      return Scaffold(
        appBar: AppBar(title: Text(course.title)),
        body: const Center(child: Text('Lesson not found.')),
      );
    }

    final currentIndex = allLessons.indexWhere((l) => l.id == lessonId);
    final prevLesson = currentIndex > 0 ? allLessons[currentIndex - 1] : null;
    final nextLesson = currentIndex < allLessons.length - 1 ? allLessons[currentIndex + 1] : null;

    final isCompleted = learningProvider.isLessonCompleted(courseId, lessonId);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: const TextStyle(fontSize: 14)),
            Text(
              currentLesson.title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: isCompleted ? AppColors.success : null,
            ),
            tooltip: isCompleted ? 'Completed' : 'Mark as Complete',
            onPressed: () async {
              await learningProvider.markLessonComplete(
                courseId: courseId,
                lessonId: lessonId,
                totalLessons: course.lessonCount,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lesson marked as completed! Progress updated.'),
                    backgroundColor: AppColors.success,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Module Header Breadcrumb
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentModule?.title.toUpperCase() ?? 'CURRICULUM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Lesson Title
                  Text(
                    currentLesson.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Metadata Row
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text(
                        '${currentLesson.estimatedMinutes} minutes estimated reading',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      if (isCompleted)
                        const Row(
                          children: [
                            Icon(Icons.check, size: 14, color: AppColors.success),
                            SizedBox(width: 4),
                            Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const Divider(height: 36),

                  // Lesson Body Content
                  _buildFormattedContent(currentLesson.content, theme, isDark),
                  const SizedBox(height: 36),

                  // Interactive "Mark Complete" Bar
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.success.withOpacity(0.3)
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isCompleted ? AppColors.success : AppColors.textSecondaryLight,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCompleted
                                    ? 'Lesson Completed'
                                    : 'Finished reading this lesson?',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                isCompleted
                                    ? 'Your progress has been recorded towards course completion.'
                                    : 'Marking complete calculates your authoritative course progress.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCompleted ? AppColors.success : AppColors.primary,
                          ),
                          onPressed: () async {
                            await learningProvider.markLessonComplete(
                              courseId: courseId,
                              lessonId: lessonId,
                              totalLessons: course.lessonCount,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isCompleted
                                      ? 'Lesson is already completed.'
                                      : 'Great work! Lesson completed.'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            }
                          },
                          child: Text(isCompleted ? 'Completed ✓' : 'Mark Complete'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Navigation Prev / Next
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (prevLesson != null)
                        OutlinedButton.icon(
                          onPressed: () => context.pushReplacement(
                            '/lesson/$courseId/${prevLesson.id}',
                          ),
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Previous Lesson'),
                        )
                      else
                        const SizedBox.shrink(),
                      if (nextLesson != null)
                        ElevatedButton.icon(
                          onPressed: () => context.pushReplacement(
                            '/lesson/$courseId/${nextLesson.id}',
                          ),
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('Next Lesson'),
                        )
                      else if (course.quizId != null)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                          onPressed: () => context.push('/quiz/${course.quizId}'),
                          icon: const Icon(Icons.quiz, size: 16),
                          label: const Text('Take Course Quiz'),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormattedContent(String markdown, ThemeData theme, bool isDark) {
    final lines = markdown.split('\n');
    final widgets = <Widget>[];

    bool inCodeBlock = false;
    final codeLines = <String>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.trim().startsWith('```')) {
        if (inCodeBlock) {
          // Close code block
          widgets.add(_buildCodeContainer(codeLines.join('\n'), isDark));
          codeLines.clear();
          inCodeBlock = false;
        } else {
          inCodeBlock = true;
        }
        continue;
      }

      if (inCodeBlock) {
        codeLines.add(line);
        continue;
      }

      if (line.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            line.substring(2),
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(
            line.substring(3),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Text(
            line.substring(4),
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(line.substring(2), style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
        ));
      } else if (line.trim().isNotEmpty) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(line, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
        ));
      }
    }

    if (inCodeBlock && codeLines.isNotEmpty) {
      widgets.add(_buildCodeContainer(codeLines.join('\n'), isDark));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildCodeContainer(String code, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: Color(0xFFE2E8F0),
          height: 1.5,
        ),
      ),
    );
  }
}
