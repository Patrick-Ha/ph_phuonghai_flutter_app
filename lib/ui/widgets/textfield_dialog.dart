import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';

String _typedValue = '';
TextEditingController _textFieldController = TextEditingController();

Future<String> textFieldDialog(
    BuildContext context, String initValue, String titleValue,
    {String helperText = ""}) async {
  _typedValue = initValue;
  _textFieldController.text = initValue;

  Platform.isIOS
      ? await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(titleValue),
              content: CupertinoTextField(
                autofocus: true,
                controller: _textFieldController,
                onChanged: (v) => _typedValue = v,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(AppLocalizations.of(context).translate('ok')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                    child:
                        Text(AppLocalizations.of(context).translate('cancel')),
                    onPressed: () {
                      _typedValue = "";
                      Navigator.of(context).pop();
                    }),
              ],
            );
          },
        )
      : await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(titleValue),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: _textFieldController,
                  maxLength: 35,
                  autofocus: true,
                  onChanged: (v) => _typedValue = v,
                  decoration: InputDecoration(helperText: helperText),
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    AppLocalizations.of(context).translate('cancel'),
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _typedValue = "";
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context).translate('ok'),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
  return _typedValue;
}
