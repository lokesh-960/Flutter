import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../../courses/providers/course_provider.dart';
import '../providers/instructor_provider.dart';

class CourseEditorScreen extends StatefulWidget {
  final String? courseId;

  const CourseEditorScreen({Key? key, this.courseId}) : super(key: key);

  @override
  State<CourseEditorScreen> createState() => _CourseEditorScreenState();
}

class _CourseEditorScreenState extends State<CourseEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _durationController = TextEditingController(text: '120');
  final _thumbnailController = TextEditingController();

  String _selectedCategory = 'Programming Fundamentals';
  String _selectedDifficulty = 'Beginner';
  bool _isSaving = false;

  final List<String> _categories = [
    'Programming Fundamentals',
    'Java Programming',
    'Web Development',
    'Database Management',
    'Digital Literacy',
    'Mathematics or Science',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      final course = context.read<CourseProvider>().getCourseById(widget.courseId!);
      if (course != null) {
        _titleController.text = course.title;
        _descController.text = course.description;
        _durationController.text = course.durationMinutes.toString();
        _thumbnailController.text = course.thumbnailUrl;
        _selectedCategory = course.category;
        _selectedDifficulty = course.difficulty;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final auth = context.read<AuthProvider>();
    final instructor = context.read<InstructorProvider>();
    final courseProvider = context.read<CourseProvider>();

    final user = auth.currentUser;
    final duration = int.tryParse(_durationController.text) ?? 120;

    if (widget.courseId != null) {
      // Editing existing course
      final existing = courseProvider.getCourseById(widget.courseId!);
      if (existing != null) {
        final updated = existing.copyWith(
          title: _titleController.text,
          description: _descController.text,
          category: _selectedCategory,
          difficulty: _selectedDifficulty,
          durationMinutes: duration,
          thumbnailUrl: _thumbnailController.text,
        );
        await instructor.updateCourse(updated);
      }
    } else {
      // Creating new course
      await instructor.createCourse(
        title: _titleController.text,
        description: _descController.text,
        instructorId: user?.uid ?? 'instructor-demo-01',
        instructorName: user?.displayName ?? 'Academic Instructor',
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
        durationMinutes: duration,
        thumbnailUrl: _thumbnailController.text,
        objectives: [
          'Master core computational logic and syntax',
          'Solve practical computer science problems',
        ],
        prerequisites: ['Basic computer familiarity'],
      );
    }

    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course saved successfully!')),
      );
      context.go('/instructor');
    }
  }

  void _showAddModuleDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Curriculum Module'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Module Title',
              hint: 'e.g. Module 1: Foundational Syntax',
              controller: titleCtrl,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Module Description',
              hint: 'Brief overview of competencies taught',
              controller: descCtrl,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isNotEmpty && widget.courseId != null) {
                await context.read<InstructorProvider>().addModuleToCourse(
                      courseId: widget.courseId!,
                      title: titleCtrl.text,
                      description: descCtrl.text,
                    );
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add Module'),
          ),
        ],
      ),
    );
  }

  void _showAddLessonDialog(String moduleId) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final durationCtrl = TextEditingController(text: '15');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Lesson to Module'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Lesson Title',
                hint: 'e.g. 1.1 Introduction to Variables',
                controller: titleCtrl,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Estimated Minutes',
                hint: '15',
                controller: durationCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Lesson Content (Markdown / Code)',
                hint: '# Lesson Notes\n\nExplain key concepts and code snippets...',
                controller: contentCtrl,
                maxLines: 6,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isNotEmpty && widget.courseId != null) {
                final duration = int.tryParse(durationCtrl.text) ?? 15;
                await context.read<InstructorProvider>().addLessonToModule(
                      courseId: widget.courseId!,
                      moduleId: moduleId,
                      title: titleCtrl.text,
                      content: contentCtrl.text,
                      estimatedMinutes: duration,
                    );
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save Lesson'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.courseId != null;
    final course = isEditing ? context.watch<CourseProvider>().getCourseById(widget.courseId!) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Course Curriculum' : 'Create New Course'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    CustomTextField(
                      label: 'Course Title',
                      hint: 'e.g. Full-Stack Web Development',
                      controller: _titleController,
                      validator: (val) => Validators.validateRequired(val, 'Course Title'),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    CustomTextField(
                      label: 'Course Description',
                      hint: 'Provide a detailed overview of what students will achieve...',
                      controller: _descController,
                      maxLines: 3,
                      validator: (val) => Validators.validateRequired(val, 'Description'),
                    ),
                    const SizedBox(height: 16),

                    // Category & Difficulty Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(labelText: 'Category'),
                            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedDifficulty,
                            decoration: const InputDecoration(labelText: 'Difficulty Level'),
                            items: const [
                              DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                              DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                              DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedDifficulty = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Duration & Thumbnail Row
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomTextField(
                            label: 'Estimated Total Minutes',
                            hint: '120',
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            validator: (val) => Validators.validateNumber(val, 'Duration', min: 10),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            label: 'Thumbnail URL (Optional)',
                            hint: 'https://images.unsplash.com/...',
                            controller: _thumbnailController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Curriculum Modules Section (If editing existing course)
                    if (isEditing && course != null) ...[
                      const Divider(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Curriculum Modules & Lessons',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          OutlinedButton.icon(
                            onPressed: _showAddModuleDialog,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add Module'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      if (course.modules.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'No modules added yet. Click "Add Module" to begin creating lessons.',
                              style: TextStyle(color: AppColors.textSecondaryLight),
                            ),
                          ),
                        )
                      else
                        ...course.modules.map((mod) => Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          mod.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        TextButton.icon(
                                          onPressed: () => _showAddLessonDialog(mod.id),
                                          icon: const Icon(Icons.add, size: 14),
                                          label: const Text('Add Lesson', style: TextStyle(fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ...mod.lessons.map((les) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.description_outlined, size: 16, color: AppColors.primary),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  les.title,
                                                  style: const TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Text(
                                                '${les.estimatedMinutes} min',
                                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            )),
                      const SizedBox(height: 24),
                    ],

                    // Save Button
                    CustomButton(
                      text: isEditing ? 'Save Changes' : 'Create Course',
                      isLoading: _isSaving,
                      onPressed: _handleSave,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
