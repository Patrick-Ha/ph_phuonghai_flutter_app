import 'package:flutter/material.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/ui/dasboard/dashboard_page.dart';
import 'package:phuonghai/ui/group_settings/group_settings_page.dart';
import 'package:phuonghai/ui/settings/setting_page.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

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
      return const GroupSettingsPage();
    } else {
      return const SettingsPage();
    }
  }

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceHttp = Provider.of<DeviceHttp>(context, listen: false);
      deviceHttp.initDeviceHttp();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int value) => setState(() {
          _currentIndex = value;
        }),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: locale.translate('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.widgets_outlined),
            activeIcon: const Icon(Icons.widgets),
            label: locale.translate('txtGroup'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: locale.translate('settings'),
          ),
        ],
      ),
    );
  }
}
