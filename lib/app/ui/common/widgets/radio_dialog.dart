import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String> dialogWithRadio(BuildContext context, int index) async {
  final List<String> _items = ["English", "Tiếng Việt"];
  int selectedRadio = index;
  String code = "NA";

  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("language".tr),
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
              "cancel".tr,
              style: const TextStyle(color: Colors.black),
            ),
            onPressed: () {
              code = 'NA';
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("confirm".tr),
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
