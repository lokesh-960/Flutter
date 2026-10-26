import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProgressBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final bool isSmall;

  const ProgressBadge({
    Key? key,
    required this.label,
    this.color,
    this.icon,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color effectiveColor = color ?? AppColors.primary;

    if (color == null) {
      switch (label.toLowerCase()) {
        case 'beginner':
          effectiveColor = AppColors.success;
          break;
        case 'intermediate':
          effectiveColor = AppColors.primary;
          break;
        case 'advanced':
          effectiveColor = AppColors.warning;
          break;
        case 'completed':
          effectiveColor = AppColors.success;
          break;
        case 'in progress':
          effectiveColor = AppColors.secondary;
          break;
        case 'high':
          effectiveColor = AppColors.error;
          break;
        default:
          effectiveColor = AppColors.primary;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: effectiveColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 12 : 14, color: effectiveColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: effectiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
