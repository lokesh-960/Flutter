import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz_attempt_model.dart';

class QuizResultScreen extends StatelessWidget {
  final String attemptId;

  const QuizResultScreen({Key? key, required this.attemptId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quizProvider = context.watch<QuizProvider>();

    final attempt = quizProvider.attempts.firstWhere(
      (a) => a.id == attemptId,
      orElse: () => QuizAttemptModel(
        id: '',
        quizId: '',
        courseId: '',
        userId: '',
        score: 0,
        totalPoints: 0,
        percentage: 0.0,
        passed: false,
        selectedAnswers: {},
        submittedAt: DateTime.now(),
      ),
    );

    final quiz = quizProvider.getQuizById(attempt.quizId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Column(
                children: [
                  // Score Banner Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: attempt.passed ? AppColors.success.withOpacity(0.4) : AppColors.error.withOpacity(0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: attempt.passed
                                ? AppColors.successBg
                                : AppColors.errorBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            attempt.passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                            size: 44,
                            color: attempt.passed ? AppColors.success : AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          attempt.passed ? 'Assessment Passed! 🎉' : 'Assessment Not Passed',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: attempt.passed ? AppColors.success : AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          attempt.passed
                              ? 'Congratulations! You demonstrated proficiency in the curriculum objectives.'
                              : 'Review the explanations below and feel free to retake the assessment.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                        ),
                        const SizedBox(height: 20),

                        // Score metrics
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildScoreMetric('Score', '${attempt.score} / ${attempt.totalPoints}'),
                            const SizedBox(width: 32),
                            _buildScoreMetric('Percentage', '${attempt.percentage.toStringAsFixed(0)}%'),
                            const SizedBox(width: 32),
                            _buildScoreMetric('Passing Threshold', '${quiz?.passingScorePercentage ?? 70}%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.pushReplacement('/quiz/${attempt.quizId}'),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Retake Quiz'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/course-details/${attempt.courseId}'),
                          icon: const Icon(Icons.menu_book, size: 16),
                          label: const Text('Back to Course'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Answer Review Section
                  if (quiz != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Detailed Answer Review',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(quiz.questions.length, (index) {
                      final q = quiz.questions[index];
                      final selectedIdx = attempt.selectedAnswers[q.id];
                      final isCorrect = selectedIdx != null && selectedIdx == q.correctOptionIndex;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCorrect
                                ? AppColors.success.withOpacity(0.4)
                                : AppColors.error.withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? AppColors.success : AppColors.error,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Question ${index + 1}: ${q.questionText}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Your Answer: ${selectedIdx != null ? q.options[selectedIdx] : 'Unanswered'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: isCorrect ? AppColors.success : AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (!isCorrect) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Correct Answer: ${q.options[q.correctOptionIndex]}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            if (q.explanation.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardDark : AppColors.primaryContainer.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Explanation: ${q.explanation}',
                                  style: const TextStyle(fontSize: 12, height: 1.4),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
        ),
      ],
    );
  }
}
