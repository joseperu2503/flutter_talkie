import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:talkie/app/core/constants/app_colors.dart';
import 'package:get/get.dart';

class CustomTextField3 extends StatefulWidget {
  const CustomTextField3({
    super.key,
    this.formControlName,
    this.hintText,
    this.focusNode,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofocus = false,
    this.readOnly = false,
    this.isPassword = false,
    this.prefixIcon,
    this.autofillHints,
  });

  final String? hintText;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String value)? onFieldSubmitted;
  final bool autofocus;
  final bool readOnly;
  final bool isPassword;
  final String? prefixIcon;
  final Iterable<String>? autofillHints;
  final String? formControlName;

  @override
  State<CustomTextField3> createState() => _CustomTextField3State();
}

class _CustomTextField3State extends State<CustomTextField3> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _effectiveFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControlName: widget.formControlName,
      style: TextStyle(
        color: context.isDarkMode
            ? AppColors.neutralOffWhite
            : AppColors.neutralActive,
        fontSize: 14,
        height: 24 / 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null
            ? SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: SvgPicture.asset(
                    widget.prefixIcon!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.neutralDisabled,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                ),
              )
            : null,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.only(
          top: 9,
          left: 12,
          right: 12,
          bottom: 9,
        ),
        constraints: const BoxConstraints(
          minHeight: 42,
        ),
        isDense: true,
        filled: true,
        fillColor: context.isDarkMode
            ? AppColors.neutralDark
            : AppColors.neutralOffWhite,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          height: 24 / 14,
          fontWeight: FontWeight.w600,
          color: AppColors.neutralDisabled,
        ),
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 40,
          maxWidth: 40,
        ),
        suffixIcon: (widget.isPassword)
            ? IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: SvgPicture.asset(
                  showPassword
                      ? 'assets/icons/eye.svg'
                      : 'assets/icons/eye_closed.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.neutralDisabled,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
              )
            : null,
      ),
      focusNode: _effectiveFocusNode,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      obscureText: widget.isPassword && !showPassword,
    );
  }
}
