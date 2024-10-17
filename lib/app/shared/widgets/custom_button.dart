import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
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
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
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
          backgroundColor: AppColors.brandColorDefault,
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
                      ? AppColors.gray
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
