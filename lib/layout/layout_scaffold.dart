import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/models/destination.dart';
import 'package:travell_app/theme/app_colors.dart';

class LayoutScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        indicatorColor: AppColors.primary,
        destinations: destinations.map(
          (destination) => NavigationDestination(
            icon: Image.asset(destination.icon, width: 20), 
            label: destination.label,
            selectedIcon: Image.asset(destination.icon, width: 20, color: AppColors.quaternary),
          )
        )
        .toList()
      ),
    );
  }
}
