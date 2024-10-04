import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_talkie/app/core/core.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final void Function() onPressed;
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          shape: const LinearBorder(),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.neutralActive,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralActive,
                height: 24 / 14,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/icons/arrow_forward.svg',
              width: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.neutralActive,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
