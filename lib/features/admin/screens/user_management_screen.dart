import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/progress_badge.dart';
import '../providers/admin_provider.dart';
import '../../auth/models/user_model.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _search = '';

  void _showRoleChangeDialog(BuildContext context, UserModel user, AdminProvider admin) {
    String selectedRole = user.role;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Change Role: ${user.displayName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Email: ${user.email}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
              const SizedBox(height: 16),
              RadioListTile<String>(
                title: const Text('Student'),
                value: 'student',
                groupValue: selectedRole,
                onChanged: (val) => setState(() => selectedRole = val!),
              ),
              RadioListTile<String>(
                title: const Text('Instructor'),
                value: 'instructor',
                groupValue: selectedRole,
                onChanged: (val) => setState(() => selectedRole = val!),
              ),
              RadioListTile<String>(
                title: const Text('Administrator'),
                value: 'admin',
                groupValue: selectedRole,
                onChanged: (val) => setState(() => selectedRole = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                admin.updateUserRole(user.uid, selectedRole);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated ${user.displayName} to $selectedRole role.')),
                );
              },
              child: const Text('Update Role'),
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

    final userList = admin.users.where((u) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return u.displayName.toLowerCase().contains(q) || u.email.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management & Permissions'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 950),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search user by name or email...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) => setState(() => _search = val),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Registered Users (${userList.length})',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...userList.map((u) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primaryContainer,
                              child: Text(
                                u.displayName.isNotEmpty ? u.displayName[0].toUpperCase() : 'U',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    u.displayName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    u.email,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Joined: ${DateFormatter.formatShortDate(u.createdAt)}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                                  ),
                                ],
                              ),
                            ),
                            ProgressBadge(
                              label: u.role.toUpperCase(),
                              color: u.isAdmin
                                  ? AppColors.error
                                  : (u.isInstructor ? AppColors.secondary : AppColors.primary),
                              isSmall: true,
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              tooltip: 'Change User Role',
                              onPressed: () => _showRoleChangeDialog(context, u, admin),
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
}
