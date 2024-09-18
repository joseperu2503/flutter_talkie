import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_button.dart';

class AddContactDialog extends StatelessWidget {
  const AddContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(
          top: 52,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add by username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralActive,
                height: 30 / 24,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            const Text(
              'Who do you want to add as a contact?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.neutralBody,
                height: 20 / 12,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.neutralOffWhite,
                borderRadius: BorderRadius.circular(4),
              ),
              height: 44,
              child: TextFormField(
                style: const TextStyle(
                  color: AppColors.blue2,
                  fontSize: 14,
                  height: 24 / 14,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  isCollapsed: true,
                  hintText: 'Enter a username',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    height: 24 / 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutralDisabled,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            CustomButton(
              text: 'Send Friend Request',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
