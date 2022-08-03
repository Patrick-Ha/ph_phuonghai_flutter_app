import 'package:flutter/material.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';

Future<bool> confirmBottomModal(
    BuildContext context, String title, String content) async {
  bool confirm = false;

  await showModalBottomSheet(
    context: context,
    constraints: const BoxConstraints(maxWidth: 600),
    builder: (context) {
      return SafeArea(
        child: Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(content),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultButton(
                    width: 150,
                    text: AppLocalizations.of(context).translate('cancel'),
                    press: () => Navigator.of(context).pop(),
                    bgColor: Colors.black26,
                  ),
                  const SizedBox(width: 30),
                  DefaultButton(
                    width: 150,
                    text: AppLocalizations.of(context).translate('ok'),
                    press: () {
                      confirm = true;
                      Future.delayed(
                        const Duration(milliseconds: 250),
                        () => Navigator.of(context).pop(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return confirm;
}
