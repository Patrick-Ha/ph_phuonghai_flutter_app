import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';

import 'dashboard/dashboard_page.dart';
import 'groups/groups_page.dart';
import 'search/search_page.dart';
import 'settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final c = Get.find<HomeController>();

  Widget _getPage(int index) {
    if (index == 0) {
      return Obx(() {
        if (c.allGroups.isEmpty) {
          return const Center(child: Text("Hello"));
        } else {
          return DashboardPage(group: c.allGroups[c.selectedGroup.value]);
        }
      });
    } else if (index == 1) {
      return const SearchPage();
    } else if (index == 2) {
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
        type: BottomNavigationBarType.fixed,
        onTap: (int value) => setState(() {
          _currentIndex = value;
        }),
        items: [
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: 'dashboard'.tr,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.search),
            icon: const Icon(Icons.search),
            label: 'search'.tr,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.widgets),
            icon: const Icon(Icons.widgets_outlined),
            label: 'groupSettings'.tr,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.settings),
            icon: const Icon(Icons.settings_outlined),
            label: 'settings'.tr,
          ),
        ],
      ),
    );
  }
}
