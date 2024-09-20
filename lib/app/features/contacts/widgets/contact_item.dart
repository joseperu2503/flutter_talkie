import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';
import 'package:flutter_talkie/app/features/contacts/models/contact.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          shape: const ContinuousRectangleBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
        ),
        child: Container(
          height: double.maxFinite,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.neutralLine,
              ),
            ),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: contact.photo != null
                        ? Image.network(
                            contact.photo!,
                            width: 48,
                            height: 48,
                          )
                        : Container(
                            width: 48,
                            height: 48,
                            color: AppColors.primary,
                            child: Center(
                              child: Text(
                                '${contact.name[0]}${contact.surname[0]}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  height: 24 / 14,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                            ),
                          ),
                  ),
                  if (contact.isOnline)
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
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutralActive,
                      height: 24 / 14,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  Text(
                    'Last seen ${timeago.format(contact.lastConnection)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutralDisabled,
                      height: 20 / 12,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
