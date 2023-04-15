import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

Future<String> pinputDialog(
  BuildContext context,
  String title,
  bool isNumber,
) async {
  String password = "";

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Pinput(
              //length: 6,
              autofocus: true,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(234, 239, 243, 1),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(234, 239, 243, 1),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              onCompleted: (pin) {
                password = pin;
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
  return password;
}
