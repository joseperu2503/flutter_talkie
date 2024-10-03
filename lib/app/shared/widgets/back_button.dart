import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: TextButton(
        onPressed: () {
          context.pop();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: SvgPicture.asset(
            kIsWeb || Platform.isAndroid
                ? 'assets/icons/arrow_back_material.svg'
                : 'assets/icons/arrow_back_ios.svg',
            width: 32,
            height: 32,
            colorFilter: const ColorFilter.mode(
              AppColors.neutralActive,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
