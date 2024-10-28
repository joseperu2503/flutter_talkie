import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkie/app/core/constants/app_colors.dart';
import 'package:talkie/app/shared/plugins/formx/formx.dart';
import 'package:get/get.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.value,
    required this.onChanged,
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
  });

  final FormxInput<String> value;
  final String? hintText;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(FormxInput<String> value) onChanged;
  final TextInputAction? textInputAction;
  final void Function(String value)? onFieldSubmitted;
  final bool autofocus;
  final bool readOnly;
  final bool isPassword;
  final String? prefixIcon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    setValue();

    _effectiveFocusNode.addListener(() {
      setState(() {});

      if (!_effectiveFocusNode.hasFocus) {
        widget.onChanged(widget.value.touch());
      }
    });
  }

  @override
  void dispose() {
    _effectiveFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    //actualiza el controller cada vez que el valor se actualiza desde afuera
    setValue();
    super.didUpdateWidget(oldWidget);
  }

  setValue() {
    if (widget.value.value != _controller.value.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.value.value,
      );
    }
  }

  bool get elevateLabel {
    return _effectiveFocusNode.hasFocus || widget.value.value != '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.isDarkMode
                ? AppColors.neutralDark
                : AppColors.neutralOffWhite,
            borderRadius: BorderRadius.circular(4),
          ),
          height: 44,
          child: TextFormField(
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
              contentPadding: const EdgeInsets.only(
                top: 10,
                left: 8,
                right: 8,
                bottom: 10,
              ),
              isCollapsed: true,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 14,
                height: 24 / 14,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralDisabled,
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
                        width: 22,
                        height: 22,
                      ),
                    )
                  : null,
            ),
            controller: _controller,
            onChanged: (value) {
              widget.onChanged(
                widget.value.updateValue(value),
              );
            },
            focusNode: _effectiveFocusNode,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            obscureText: widget.isPassword && !showPassword,
          ),
        ),
        if (widget.value.errorMessage != null && widget.value.touched)
          Container(
            padding: const EdgeInsets.only(left: 6, top: 1),
            child: Text(
              '${widget.value.errorMessage}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.error,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          )
      ],
    );
  }
}
