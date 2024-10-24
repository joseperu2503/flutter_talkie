import 'package:flutter/material.dart';
import 'package:talkie/app/core/core.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
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
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: widget.width,
      child: ElevatedButton(
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
                      ? AppColors.neutralDisabled
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
