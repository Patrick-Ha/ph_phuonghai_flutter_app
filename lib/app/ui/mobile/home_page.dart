import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/ui/mobile/groups/groups_page.dart';

import 'dashboard/dashboard_page.dart';
import 'settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Widget _getPage(int index) {
    if (index == 0) {
      return const DashboardPage();
    } else if (index == 1) {
      return const GroupsPage();
    } else {
      return const SettingsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int value) => setState(() {
          _currentIndex = value;
        }),
        items: [
          BottomNavigationBarItem(
            activeIcon: const Icon(EvaIcons.home),
            icon: const Icon(EvaIcons.homeOutline),
            label: 'dashboard'.tr,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(EvaIcons.grid),
            icon: const Icon(EvaIcons.gridOutline),
            label: 'groupSettings'.tr,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(EvaIcons.settings),
            icon: const Icon(EvaIcons.settingsOutline),
            label: 'settings'.tr,
          ),
        ],
      ),
    );
  }
}
