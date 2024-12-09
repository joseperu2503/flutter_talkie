import 'package:flutter/material.dart';
import 'package:talkie/app/core/core.dart';
import 'package:get/get.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.onPressed,
    this.text,
    this.width = double.infinity,
    this.iconLeft,
    this.textStyle,
  });

  final void Function()? onPressed;
  final String? text;
  final double width;
  final Widget? iconLeft;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconLeft != null) iconLeft!,
            if (text != null && iconLeft != null) const Width(10),
            if (text != null)
              Text(
                text!,
                style: textStyle ??
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: onPressed == null
                          ? AppColors.neutralActive
                          : context.isDarkMode
                              ? AppColors.neutralOffWhite
                              : AppColors.neutralActive,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
              )
          ],
        ),
      ),
    );
  }
}
