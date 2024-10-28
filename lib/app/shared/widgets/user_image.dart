import 'package:flutter/material.dart';
import 'package:talkie/app/core/core.dart';
import 'package:get/get.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
    required this.name,
    required this.surname,
    this.photo,
    this.size = 48,
    this.isConnected = false,
  });

  final String name;
  final String surname;
  final String? photo;
  final double size;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size / 3),
          child: photo != null
              ? Image.network(
                  photo!,
                  width: size,
                  height: size,
                )
              : Container(
                  width: size,
                  height: size,
                  color: context.isDarkMode
                      ? AppColors.brandColorDarkMode
                      : AppColors.brandColorDefault,
                  child: Center(
                    child: Text(
                      '${name[0]}${surname[0]}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        height: 24 / 14,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
                ),
        ),
        if (isConnected)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              width: 16,
              height: 16,
              alignment: Alignment.center,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentSuccess,
                ),
                width: 12,
                height: 12,
              ),
            ),
          )
      ],
    );
  }
}
