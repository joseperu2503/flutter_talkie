import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:get/get.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.isSelected,
    required this.onPress,
    required this.label,
  });

  final bool isSelected;
  final void Function() onPress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? context.isDarkMode
                        ? AppColors.brandColorDarkMode
                        : AppColors.brandColorDefault
                    : AppColors.brandColorDarkMode,
                width: 1,
              ),
            ),
            child: Visibility(
              visible: isSelected,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode
                        ? AppColors.brandColorDarkMode
                        : AppColors.brandColorDefault,
                  ),
                ),
              ),
            ),
          ),
          const Width(12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.isDarkMode
                  ? AppColors.neutralOffWhite
                  : AppColors.neutralActive,
              height: 24 / 16,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        ],
      ),
    );
  }
}
