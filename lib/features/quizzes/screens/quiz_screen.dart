import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/quiz_provider.dart';
import '../../auth/providers/auth_provider.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, int> _selectedAnswers = {}; // questionId -> selectedOptionIndex
  bool _isSubmitting = false;

  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quiz = context.read<QuizProvider>().getQuizById(widget.quizId);
      if (quiz != null) {
        setState(() {
          _secondsRemaining = quiz.timeLimitMinutes * 60;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _autoSubmit();
      }
    });
  }

  void _autoSubmit() {
    if (!_isSubmitting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time expired! Submitting answers automatically...')),
      );
      _handleSubmit();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final quiz = context.read<QuizProvider>().getQuizById(widget.quizId);
    if (quiz == null || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final auth = context.read<AuthProvider>();
    final userId = auth.currentUser?.uid ?? 'guest-student';

    final attempt = await context.read<QuizProvider>().submitQuizAttempt(
      quiz: quiz,
      userId: userId,
      answers: _selectedAnswers,
    );

    if (mounted) {
      context.pushReplacement('/quiz-result/${attempt.id}');
    }
  }

  void _confirmSubmitDialog() {
    final quiz = context.read<QuizProvider>().getQuizById(widget.quizId);
    final unanswered = (quiz?.questionCount ?? 0) - _selectedAnswers.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Assessment?'),
        content: Text(
          unanswered > 0
              ? 'You have $unanswered unanswered question${unanswered == 1 ? '' : 's'}. Are you sure you wish to submit?'
              : 'Are you sure you want to finalize and submit your answers?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Review Answers'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSubmit();
            },
            child: const Text('Confirm & Submit'),
          ),
        ],
      ),
    );
  }

  String _formatTimer(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quiz = context.watch<QuizProvider>().getQuizById(widget.quizId);

    if (quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Assessment')),
        body: const Center(child: Text('Quiz assessment not found.')),
      );
    }

    final question = quiz.questions[_currentQuestionIndex];
    final selectedOption = _selectedAnswers[question.id];

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _secondsRemaining < 120
                  ? AppColors.errorBg
                  : (isDark ? AppColors.surfaceDark : AppColors.primaryContainer),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _secondsRemaining < 120 ? AppColors.error : AppColors.primary,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: _secondsRemaining < 120 ? AppColors.error : AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTimer(_secondsRemaining),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _secondsRemaining < 120 ? AppColors.error : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${quiz.questionCount}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${question.points} point${question.points > 1 ? 's' : ''}',
                        style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / quiz.questionCount,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Text(
                      question.questionText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Multiple Choice Options
                  ...List.generate(question.options.length, (optIndex) {
                    final isChosen = selectedOption == optIndex;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isChosen
                            ? theme.colorScheme.primary.withOpacity(0.08)
                            : (isDark ? AppColors.cardDark : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isChosen
                              ? theme.colorScheme.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: isChosen ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            _selectedAnswers[question.id] = optIndex;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isChosen
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isChosen
                                        ? theme.colorScheme.primary
                                        : AppColors.textMutedLight,
                                    width: 2,
                                  ),
                                ),
                                child: isChosen
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : Center(
                                        child: Text(
                                          String.fromCharCode(65 + optIndex), // A, B, C, D
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondaryLight,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  question.options[optIndex],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isChosen ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 28),

                  // Bottom Navigation & Submit Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentQuestionIndex > 0)
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentQuestionIndex--;
                            });
                          },
                          child: const Text('Previous'),
                        )
                      else
                        const SizedBox.shrink(),
                      if (_currentQuestionIndex < quiz.questionCount - 1)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentQuestionIndex++;
                            });
                          },
                          child: const Text('Next Question'),
                        )
                      else
                        CustomButton(
                          text: 'Submit Assessment',
                          isLoading: _isSubmitting,
                          onPressed: _confirmSubmitDialog,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
