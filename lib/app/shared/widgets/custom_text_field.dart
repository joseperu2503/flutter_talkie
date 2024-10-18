import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';
import 'package:flutter_talkie/app/shared/plugins/formx/formx.dart';

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
    this.label = '',
    this.isPassword = false,
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
  final String label;
  final bool isPassword;

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
            borderRadius: BorderRadius.circular(12),
          ),
          height: 58,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                top: elevateLabel ? 5 : 29 - 12,
                left: 16,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceInOut,
                  style: TextStyle(
                    fontSize: elevateLabel ? 12 : 16,
                    fontWeight: FontWeight.w400,
                    color: elevateLabel ? AppColors.primary : AppColors.gray,
                    height: elevateLabel ? 20 / 12 : 24 / 16,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  child: Text(widget.label),
                ),
              ),
              TextFormField(
                style: const TextStyle(
                  color: AppColors.blue2,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 16 / 14,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.gray.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 40,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  hintText: elevateLabel ? widget.hintText : '',
                  hintStyle: const TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 10 / 14,
                  ),
                  isCollapsed: true,
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
                            colorFilter: ColorFilter.mode(
                              AppColors.gray.withOpacity(0.5),
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
            ],
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
