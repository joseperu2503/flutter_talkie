import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 4,
                  right: 24,
                  left: 24,
                  bottom: 8,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 250,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Connect easily with\nyour family and friends\nover countries',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 30 / 24,
                        color: AppColors.neutralActive,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    SizedBox(
                      height: 52,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Terms & Privacy Policy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutralActive,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomButton(
                      text: 'Start Messaging',
                      onPressed: () {
                        context.push('/login');
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
