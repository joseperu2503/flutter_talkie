import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';
import 'package:flutter_talkie/app/features/contacts/controllers/contacts_controller.dart';
import 'package:flutter_talkie/app/features/contacts/widgets/add_contact_dialog.dart';
import 'package:flutter_talkie/app/features/contacts/widgets/contact_item.dart';
import 'package:get/get.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactsController contactsController = Get.put(ContactsController());

  @override
  void initState() {
    contactsController.getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                    const Text(
                      'Contacts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralActive,
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AddContactDialog();
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icons/plus.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.neutralActive,
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
              child: Container(
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
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.neutralDisabled,
                            BlendMode.srcIn,
                          ),
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    isCollapsed: true,
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      height: 24 / 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutralDisabled,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => SliverList.builder(
              itemBuilder: (context, index) {
                final contact = contactsController.contacts[index];
                return ContactItem(contact: contact);
              },
              itemCount: contactsController.contacts.length,
            ),
          )
        ],
      ),
    );
  }
}
