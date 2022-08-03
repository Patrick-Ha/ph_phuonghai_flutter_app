import 'package:flutter/material.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

class GroupBottomModal extends StatefulWidget {
  const GroupBottomModal({Key? key}) : super(key: key);

  @override
  State<GroupBottomModal> createState() => _GroupBottomModalState();
}

class _GroupBottomModalState extends State<GroupBottomModal> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final device = Provider.of<DeviceHttp>(context, listen: false);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: device.groups.length,
            itemBuilder: ((context, index) {
              if (index == device.groupSelected) {
                return GroupTitle(
                  text: locale.translate(device.groups[index].name),
                  select: true,
                  onTap: () {
                    device.groupSelected = index;
                    Navigator.of(context).pop();
                  },
                );
              } else {
                return GroupTitle(
                  text: locale.translate(device.groups[index].name),
                  onTap: () {
                    device.groupSelected = index;
                    Navigator.of(context).pop();
                  },
                );
              }
            })),
      ),
    );
  }
}

class GroupTitle extends StatelessWidget {
  const GroupTitle({
    Key? key,
    this.select = false,
    this.onTap,
    required this.text,
  }) : super(key: key);

  final bool select;
  final String text;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: select ? Colors.green[50] : null,
          border: Border(
            bottom:
                select ? BorderSide.none : BorderSide(color: Colors.grey[300]!),
            left: BorderSide(
              color: select ? Colors.green : Colors.transparent,
              width: 5,
            ),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
