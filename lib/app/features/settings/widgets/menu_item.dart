import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkie/app/core/core.dart';
import 'package:get/get.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.withArrow = true,
  });

  final void Function() onPressed;
  final String icon;
  final String label;
  final bool withArrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
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
              colorFilter: ColorFilter.mode(
                context.isDarkMode
                    ? AppColors.neutralOffWhite
                    : AppColors.neutralActive,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.isDarkMode
                    ? AppColors.neutralOffWhite
                    : AppColors.neutralActive,
                height: 24 / 14,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const Spacer(),
            if (withArrow)
              SvgPicture.asset(
                'assets/icons/arrow_forward.svg',
                width: 20,
                colorFilter: ColorFilter.mode(
                  context.isDarkMode
                      ? AppColors.neutralOffWhite
                      : AppColors.neutralActive,
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
