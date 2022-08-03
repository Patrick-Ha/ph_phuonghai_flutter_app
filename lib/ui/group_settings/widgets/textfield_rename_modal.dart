import 'package:flutter/material.dart';
import 'package:phuonghai/models/group_model.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/ui/widgets/status_widget.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

class TextFieldRenameModal extends StatefulWidget {
  const TextFieldRenameModal({
    Key? key,
    required this.group,
  }) : super(key: key);

  final GroupModel group;

  @override
  State<TextFieldRenameModal> createState() => _TextFieldModalRenameState();
}

class _TextFieldModalRenameState extends State<TextFieldRenameModal> {
  final _controller = TextEditingController();
  bool _error = false;
  String _textError = "";

  @override
  void initState() {
    _controller.text = widget.group.name;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return SafeArea(
      child: Container(
        height: 380,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              locale.translate('renameGroup'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              autofocus: true,
              autocorrect: false,
              enableSuggestions: false,
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Tên nhóm thiết bị",
                helperText: locale.translate('hintCreateGroup'),
              ),
            ),
            const SizedBox(height: 20),
            StatusWidget(error: _error, text: _textError),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultButton(
                  width: 150,
                  text: locale.translate('cancel'),
                  press: () => Navigator.of(context).pop(),
                  bgColor: Colors.black26,
                ),
                const SizedBox(width: 30),
                DefaultButton(
                  width: 150,
                  text: locale.translate('ok'),
                  press: () {
                    final deviceHttp =
                        Provider.of<DeviceHttp>(context, listen: false);
                    final index = deviceHttp.groups
                        .indexWhere((i) => i.name == _controller.text);
                    if (index == -1) {
                      final listDevice =
                          deviceHttp.userConfig['groups'][widget.group.name];
                      deviceHttp.userConfig['groups'].remove(widget.group.name);
                      deviceHttp.userConfig['groups'][_controller.text] =
                          listDevice;
                      widget.group.name = _controller.text;
                      deviceHttp.updateGroupsToFirebase();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      setState(() {
                        _error = true;
                        _textError = locale.translate('errorGroup');
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
