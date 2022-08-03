import 'package:flutter/material.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';

// false -> Cancel
// true -> Xac nhan
Future<bool> confirmAlert(
    BuildContext context, String title, String content) async {
  bool confirm = false;
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context).translate('cancel'),
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  confirm = false;
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('ok')),
              onPressed: () {
                confirm = true;
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      });

  return confirm;
}
