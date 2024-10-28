import 'dart:io';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:talkie/app/core/core.dart';

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
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              context.isDarkMode
                  ? AppColors.neutralOffWhite
                  : AppColors.neutralActive,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
