import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:get/get.dart';

class CustomTextButton extends StatefulWidget {
  const CustomTextButton({
    super.key,
    this.onPressed,
    this.text,
    this.width = double.infinity,
    this.iconLeft,
  });

  final void Function()? onPressed;
  final String? text;
  final double width;
  final Widget? iconLeft;

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: widget.width,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: context.isDarkMode
              ? AppColors.brandColorDarkMode
              : AppColors.brandColorDefault,
        ),
        onPressed: widget.onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.iconLeft != null) widget.iconLeft!,
            if (widget.text != null && widget.iconLeft != null)
              const SizedBox(
                width: 10,
              ),
            if (widget.text != null)
              Text(
                widget.text!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.onPressed == null
                      ? AppColors.neutralActive
                      : AppColors.white,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              )
          ],
        ),
      ),
    );
  }
}
