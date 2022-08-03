import 'package:badges/badges.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/models/device_model.dart';
import 'package:phuonghai/models/group_model.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/ui/widgets/confirm_bottom_modal.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/ui/widgets/status_widget.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

import 'widgets/textfield_rename_modal.dart';

class GroupSettingsPage extends StatefulWidget {
  const GroupSettingsPage({Key? key}) : super(key: key);

  @override
  State<GroupSettingsPage> createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceHttp>(
      builder: (_, deviceHttp, __) {
        return Scaffold(
          appBar: AppBar(
            title: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(160, 38),
                primary: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  constraints: const BoxConstraints(maxWidth: 600),
                  builder: (context) {
                    return const TextFieldCreateModal();
                  },
                );
              },
              icon: const Icon(
                Icons.add_box,
                color: Colors.yellowAccent,
              ),
              label: Text(
                AppLocalizations.of(context).translate('createGroup'),
              ),
            ),
          ),
          body: deviceHttp.isBusy == 1
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.green,
                    size: 40,
                    secondRingColor: Colors.purple,
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: deviceHttp.groups.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GroupSettingsWidget(
                        enable: false,
                        group: deviceHttp.groups[0],
                      );
                    } else {
                      return GroupSettingsWidget(
                        enable: true,
                        group: deviceHttp.groups[index],
                      );
                    }
                  },
                ),
        );
      },
    );
  }
}

class GroupSettingsWidget extends StatelessWidget {
  const GroupSettingsWidget({
    Key? key,
    required this.group,
    required this.enable,
  }) : super(key: key);

  final GroupModel group;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final device = Provider.of<DeviceHttp>(context, listen: false);
    return Column(
      children: [
        ExpansionTile(
          childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: Badge(
              elevation: 0,
              badgeColor: Colors.green,
              badgeContent: Text(
                '${group.devices.length}',
                style: const TextStyle(color: Colors.white),
              ),
              child: const Icon(Icons.widgets_outlined)),
          title: Text(locale.translate(group.name)),
          children: [
            for (var i in group.devices)
              ListTile(
                title: Text(i.friendlyName),
                subtitle: Text("#${i.key}"),
              ),
            if (enable)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///////// Add device
                  IconButton(
                    splashRadius: 24,
                    onPressed: () async {
                      await FilterListDelegate.show<DeviceModel>(
                        context: context,
                        list: device.groups[0].devices,
                        selectedListData: group.devices,
                        theme: FilterListDelegateThemeData(
                          listTileTheme: ListTileThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            selectedTileColor: Colors.green.withOpacity(.2),
                          ),
                        ),
                        onItemSearch: (user, query) {
                          return user.key
                                  .toLowerCase()
                                  .contains(query.toLowerCase()) ||
                              user.friendlyName
                                  .toLowerCase()
                                  .contains(query.toLowerCase());
                        },
                        tileLabel: (user) =>
                            "${user?.friendlyName}\n#${user?.key}",
                        emptySearchChild:
                            const Center(child: Text('No device found')),
                        searchFieldHint: 'Nhập số tên hoặc số seri',
                        searchFieldStyle: const TextStyle(fontSize: 16),
                        applyButtonText: "Xong",
                        onApplyButtonClick: (list) {
                          device.userConfig['groups'][group.name].clear();
                          for (var element in group.devices) {
                            device.userConfig['groups'][group.name]
                                .add(element.key);
                          }
                          device.updateGroupsToFirebase();
                        },
                      );
                    },
                    icon: const Icon(Icons.exposure, color: Colors.black54),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    splashRadius: 24,
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: false,
                        context: context,
                        constraints: const BoxConstraints(maxWidth: 600),
                        builder: (context) {
                          return TextFieldRenameModal(group: group);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.black54),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    splashRadius: 24,
                    onPressed: () async {
                      final confirm = await confirmBottomModal(
                          context,
                          locale.translate('deleteGroup'),
                          locale.translate('areUSure'));
                      if (confirm) {
                        device.userConfig['groups'].remove(group.name);
                        device.groups.removeWhere(
                            (element) => element.name == group.name);
                        device.groupSelected = 0;
                        device.updateGroupsToFirebase();
                      }
                    },
                    icon: const Icon(Icons.delete, color: Colors.black54),
                  ),
                  // const SizedBox(width: 10),
                  // IconButton(
                  //   splashRadius: 24,
                  //   onPressed: () async {
                  //     final confirm = await confirmBottomModal(
                  //         context,
                  //         "Ghim mặc định",
                  //         "Nhóm này sẽ hiển thị đầu tiên khi bạn vào ứng dụng");
                  //     if (confirm) {
                  //       // device.userConfig['groups'].remove(group.name);
                  //       // device.groups.removeWhere(
                  //       //     (element) => element.name == group.name);
                  //       // device.groupSelected = 0;
                  //       // device.updateGroupsToFirebase();
                  //     }
                  //   },
                  //   icon: const Icon(Icons.push_pin, color: Colors.green),
                  // )
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class TextFieldCreateModal extends StatefulWidget {
  const TextFieldCreateModal({Key? key}) : super(key: key);

  @override
  State<TextFieldCreateModal> createState() => _TextFieldCreateModalState();
}

class _TextFieldCreateModalState extends State<TextFieldCreateModal> {
  final _controller = TextEditingController();
  bool _error = false;
  String _textError = "";

  // @override
  // void initState() {
  //   _controller.text = widget.group.name;
  //   super.initState();
  // }

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
              locale.translate('createGroup'),
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
                    if (_controller.text.isNotEmpty) {
                      final deviceHttp =
                          Provider.of<DeviceHttp>(context, listen: false);
                      final index = deviceHttp.groups
                          .indexWhere((i) => i.name == _controller.text);

                      if (index == -1) {
                        // Chua co nhom
                        final newGroup = GroupModel(name: _controller.text);
                        deviceHttp.groups.add(newGroup);
                        deviceHttp.userConfig['groups'][_controller.text] = [];
                        deviceHttp.updateGroupsToFirebase();
                        Future.delayed(
                          const Duration(milliseconds: 250),
                          () => Navigator.of(context).pop(),
                        );
                      } else {
                        setState(() {
                          _error = true;
                          _textError = locale.translate('errorGroup');
                        });
                      }
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
