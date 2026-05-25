import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    this.onActionTap,
    this.emphasizeAction = false,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onActionTap;
  final bool emphasizeAction;

  @override
  Widget build(BuildContext context) {
    final actionStyle = TextStyle(
      color: AppColors.accent,
      fontWeight: emphasizeAction ? FontWeight.w700 : FontWeight.w400,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(actionLabel, style: actionStyle),
          ),
        ),
      ],
    );
  }
}
