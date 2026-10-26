import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/progress_badge.dart';
import '../providers/admin_provider.dart';
import '../../courses/providers/course_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  void _showAddAnnouncementDialog(BuildContext context, AdminProvider admin) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String priority = 'normal';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Post Campus Announcement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(label: 'Title', hint: 'Announcement headline', controller: titleCtrl),
              const SizedBox(height: 12),
              CustomTextField(label: 'Content', hint: 'Detailed message...', controller: contentCtrl, maxLines: 3),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(labelText: 'Priority Level'),
                items: const [
                  DropdownMenuItem(value: 'normal', child: Text('Normal Priority')),
                  DropdownMenuItem(value: 'high', child: Text('Urgent / High Priority')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => priority = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                  admin.addAnnouncement(
                    title: titleCtrl.text,
                    content: contentCtrl.text,
                    authorName: 'System Administrator',
                    priority: priority,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Broadcast'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final admin = context.watch<AdminProvider>();
    final courses = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator Governance Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'Manage Users',
            onPressed: () => context.push('/admin/users'),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Admin Header
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFFC5192D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Institutional Admin Console',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Platform governance, role assignment, course moderation, and SDG 4 quality assurance.',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.admin_panel_settings, size: 48, color: Colors.white70),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Global KPI Statistics
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildKpiCard('Total Users', '${admin.totalUsersCount}', Icons.people, AppColors.primary, isDark),
                      _buildKpiCard('Courses Active', '${admin.totalCoursesCount}', Icons.menu_book, AppColors.secondary, isDark),
                      _buildKpiCard('Total Enrollments', '${admin.totalEnrollmentsCount}', Icons.school, AppColors.success, isDark),
                      _buildKpiCard('Assessments Taken', '${admin.totalQuizzesCompleted}', Icons.quiz, AppColors.warning, isDark),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Quick Action Links
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/admin/users'),
                          icon: const Icon(Icons.manage_accounts, size: 18),
                          label: const Text('Manage User Roles'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddAnnouncementDialog(context, admin),
                          icon: const Icon(Icons.campaign, size: 18),
                          label: const Text('Post Announcement'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Course Catalog Moderation
                  Text(
                    'Curriculum Moderation',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...courses.courses.map((c) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    '${c.category} • Instructor: ${c.instructorName} • Status: ${c.isPublished ? 'Published' : 'Unpublished'}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: c.isPublished,
                              activeColor: AppColors.success,
                              onChanged: (val) => admin.toggleCoursePublish(c),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 32),

                  // Reported Issues / Feedback Monitoring
                  Text(
                    'Learner Issue Reports & Quality Audits',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...admin.issueReports.map((report) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.report_problem_outlined, color: AppColors.warning, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report['courseTitle'] as String,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    report['message'] as String,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                  ),
                                ],
                              ),
                            ),
                            ProgressBadge(
                              label: report['status'] as String,
                              color: report['status'] == 'Resolved' ? AppColors.success : AppColors.warning,
                              isSmall: true,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      width: 220,
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
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }
}
