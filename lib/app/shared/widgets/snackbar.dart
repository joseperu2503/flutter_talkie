import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_talkie/app/core/constants/breakpoints.dart';
import 'package:flutter_talkie/app/core/core.dart';

enum SnackbarType {
  info,
  success,
  error,
}

final GlobalKey<_SnackbarContentState> _snackbarKey =
    GlobalKey<_SnackbarContentState>();

class SnackbarService {
  static SnackbarModel? show(
    String message, {
    SnackbarType type = SnackbarType.info,
  }) {
    if (_snackbarKey.currentState != null) {
      final newSnackbar = _snackbarKey.currentState!.addSnackbar(message, type);
      return newSnackbar;
    }

    return null;
  }

  static remove(SnackbarModel? snackbar) {
    if (_snackbarKey.currentState != null) {
      _snackbarKey.currentState!.removeSnackbar(snackbar);
    }
  }
}

class SnackbarProvider extends StatelessWidget {
  const SnackbarProvider({
    super.key,
    this.child,
  });
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _SnackbarContent(
      key: _snackbarKey,
      child: child,
    );
  }
}

class _SnackbarContent extends StatefulWidget {
  const _SnackbarContent({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<_SnackbarContent> createState() => _SnackbarContentState();
}

class _SnackbarContentState extends State<_SnackbarContent> {
  List<SnackbarModel> snackbars = [];

  SnackbarModel addSnackbar(String message, SnackbarType type) {
    final SnackbarModel newSnackbar = SnackbarModel(
      id: _generateRandomString(10),
      message: message,
      type: type,
    );

    setState(() {
      snackbars.add(newSnackbar);
    });

    Future.delayed(const Duration(seconds: 4), () {
      removeSnackbar(newSnackbar);
    });

    return newSnackbar;
  }

  removeSnackbar(SnackbarModel? snackbar) {
    if (snackbar == null) return;
    setState(() {
      snackbars.remove(snackbar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          if (widget.child != null) widget.child!,
          Positioned(
            top: Breakpoints.isMdUp(context) ? 73 : null,
            bottom: Breakpoints.isMdUp(context)
                ? null
                : max(screen.padding.bottom, 20),
            right: (Breakpoints.isMdUp(context)) ? 62 : 20,
            left: (Breakpoints.isMdUp(context)) ? null : 20,
            child: Wrap(
              direction: Axis.vertical,
              runAlignment: Breakpoints.isMdUp(context)
                  ? WrapAlignment.end
                  : WrapAlignment.center,
              crossAxisAlignment: Breakpoints.isMdUp(context)
                  ? WrapCrossAlignment.end
                  : WrapCrossAlignment.center,
              spacing: 16,
              children: snackbars.reversed.toList().map((snackbar) {
                return _CustomSnackbar(
                  message: snackbar.message,
                  onClose: () {
                    removeSnackbar(snackbar);
                  },
                  type: snackbar.type,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

String _generateRandomString(int length) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

class _CustomSnackbar extends StatelessWidget {
  const _CustomSnackbar({
    required this.message,
    required this.onClose,
    required this.type,
  });

  final String message;
  final void Function() onClose;
  final SnackbarType type;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.cta50;
    Color color = AppColors.brandColorDefault;
    String icon = 'assets/icons/success.svg';

    if (type == SnackbarType.error) {
      backgroundColor = AppColors.backgroundError;
      color = AppColors.error;
      icon = 'assets/icons/error.svg';
    }

    if (type == SnackbarType.success) {
      backgroundColor = AppColors.backgroundSuccess;
      color = AppColors.accentSuccess;
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Container(
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: MediaQuery.of(context).size.width - 40,
              minHeight: 64,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: color,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 64,
                  color: color,
                ),
                const SizedBox(
                  width: 11,
                ),
                SvgPicture.asset(
                  icon,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: 9,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: color,
                      height: 20 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 3,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onClose,
              child: SvgPicture.asset(
                'assets/icons/close.svg',
                height: 34,
                width: 34,
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SnackbarModel {
  final String id;
  final String message;
  final SnackbarType type;

  SnackbarModel({
    required this.id,
    required this.message,
    required this.type,
  });
}
