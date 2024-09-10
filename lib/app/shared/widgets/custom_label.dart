import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';

class CustomLabel extends ConsumerWidget {
  const CustomLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textArsenic,
          height: 22 / 14,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      ),
    );
  }
}
