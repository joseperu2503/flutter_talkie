import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
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
                  horizontal: 16,
                ),
                child: const Row(
                  children: [
                    Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textArsenic,
                        height: 1.2,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 90,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://randomuser.me/api/portraits/women/23.jpg',
                          width: 60,
                          height: 60,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'James Heatfield',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textYankeesBlue,
                              height: 1.2,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Don’t miss to attend the meeting.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textYankeesBlue,
                              height: 1.2,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: 4,
            ),
          )
        ],
      ),
    );
  }
}
