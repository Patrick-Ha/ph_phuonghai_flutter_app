import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> confirmDialog(
    BuildContext context, String title, String content) async {
  bool ret = false;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(content),
        actions: [
          TextButton(
            child: Text(
              "cancel".tr,
              style: const TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("confirm".tr),
            onPressed: () {
              ret = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  return ret;
}
