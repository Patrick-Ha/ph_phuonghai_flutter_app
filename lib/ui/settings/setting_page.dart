import 'package:flutter/material.dart';

import 'package:phuonghai/providers/auth_provider.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/providers/language_provider.dart';
import 'package:phuonghai/routes.dart';
import 'package:phuonghai/ui/widgets/confirm_bottom_modal.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:circle_flags/circle_flags.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final device = Provider.of<DeviceHttp>(context, listen: false);
    final state = Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: SizedBox(
                  height: 120,
                  child: Image.asset("assets/images/greenlab.png"),
                ),
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(device.email ?? "N/A"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.key_outlined),
                title: Text(locale.translate('changePassword')),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                onTap: () async {
                  int _index = 0;
                  if (state.appLocale.languageCode == 'vi') {
                    _index = 1;
                  }
                  String code = await _dialogWithRadio(context, _index);

                  if (code != "NA") {
                    state.updateLanguage(code);
                  }
                },
                title: Text(locale.translate('language')),
                trailing: CircleFlag(
                  state.appLocale.countryCode ?? "VN",
                  size: 22,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone_android_outlined),
                title: Text(locale.translate('txtVersion')),
                trailing: Text(device.version ?? "N/A"),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: Text(
                  locale.translate('logOut'),
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  bool confirm = await confirmBottomModal(context,
                      locale.translate('logOut'), locale.translate('areUSure'));
                  if (confirm) {
                    final auth =
                        Provider.of<AuthProvider>(context, listen: false);
                    device.disposeTimer();
                    await auth.signOut();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.splash, (Route<dynamic> route) => false);
                  }
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _dialogWithRadio(BuildContext context, int index) async {
    final List<String> _items = ["English", "Tiếng Việt"];
    int selectedRadio = index;
    String code = "NA";

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).translate("language"),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(_items.length, (int index) {
                  return RadioListTile<int>(
                    title: Text(_items[index]),
                    value: index,
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() => selectedRadio = value!);
                    },
                  );
                }),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context).translate("cancel"),
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                code = 'NA';
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).translate("ok")),
              onPressed: () {
                if (selectedRadio == 0) {
                  code = 'en';
                } else {
                  code = 'vi';
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return code;
  }
}
