import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class InternalLayout extends StatelessWidget {
  const InternalLayout({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavigationBar(
        navigationShell: navigationShell,
      ),
    );
  }
}
