import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'default_button.dart';

Future<bool> confirmBottomModal(
    BuildContext context, String title, String content) async {
  bool confirm = false;

  await showModalBottomSheet(
    context: context,
    constraints: const BoxConstraints(maxWidth: 420),
    builder: (context) {
      return SafeArea(
        child: Container(
          height: 200,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                    text: 'cancel'.tr,
                    press: () => Navigator.of(context).pop(),
                    bgColor: Colors.black38,
                  ),
                  const SizedBox(width: 30),
                  DefaultButton(
                    width: 150,
                    text: 'confirm'.tr,
                    press: () {
                      confirm = true;
                      Navigator.of(context).pop();
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
