import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkie/app/core/constants/app_colors.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/contacts/controllers/contacts_controller.dart';
import 'package:talkie/app/features/contacts/widgets/add_contact_dialog.dart';
import 'package:talkie/app/features/contacts/widgets/contact_item.dart';
import 'package:talkie/app/shared/widgets/custom_text_field.dart';
import 'package:get/get.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ChatController chatController = Get.find<ChatController>();
  final ContactsController contactsController =
      Get.put<ContactsController>(ContactsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: SafeArea(
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    Text(
                      'Contacts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.isDarkMode
                            ? AppColors.neutralOffWhite
                            : AppColors.neutralActive,
                        height: 30 / 18,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        onPressed: () {
                          contactsController.resetUsername();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AddContactDialog();
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icons/plus.svg',
                          colorFilter: ColorFilter.mode(
                            context.isDarkMode
                                ? AppColors.neutralOffWhite
                                : AppColors.neutralActive,
                            BlendMode.srcIn,
                          ),
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 24,
              right: 24,
              bottom: 16,
            ),
            sliver: SliverToBoxAdapter(
              child: Obx(
                () => CustomTextField(
                  hintText: 'Search',
                  prefixIcon: 'assets/icons/search.svg',
                  value: contactsController.search.value,
                  onChanged: (value) {
                    contactsController.changeSearch(value);
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => SliverList.builder(
              itemBuilder: (context, index) {
                final chat = chatController.chats[index];
                return ContactItem(chat: chat);
              },
              itemCount: chatController.chats.length,
            ),
          )
        ],
      ),
    );
  }
}
