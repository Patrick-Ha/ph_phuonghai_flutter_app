import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String> textFieldDialog(
    BuildContext context, String title, bool isNumber) async {
  final textFieldController = TextEditingController();
  String typedValue = "";

  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: textFieldController,
          autofocus: true,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: (v) => typedValue = v,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "cancel".tr,
              style: const TextStyle(color: Colors.black),
            ),
            onPressed: () {
              typedValue = "";
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("confirm".tr),
            onPressed: () {
              typedValue = textFieldController.text;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return typedValue;
}
