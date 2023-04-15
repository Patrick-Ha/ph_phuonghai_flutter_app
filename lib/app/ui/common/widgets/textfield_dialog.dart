import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String> textFieldDialog(
    BuildContext context, String title, bool isNumber) async {
  final _textFieldController = TextEditingController();
  String _typedValue = "";

  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: _textFieldController,
          autofocus: true,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: (v) => _typedValue = v,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "cancel".tr,
              style: const TextStyle(color: Colors.black),
            ),
            onPressed: () {
              _typedValue = "";
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("confirm".tr),
            onPressed: () {
              _typedValue = _textFieldController.text;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return _typedValue;
}
