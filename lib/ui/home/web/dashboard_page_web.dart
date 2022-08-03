import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/models/device_model.dart';
import 'package:phuonghai/models/group_model.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/routes.dart';
import 'package:phuonghai/ui/dasboard/widgets/smartph_card.dart';
import 'package:phuonghai/ui/group_settings/group_settings_page.dart';
import 'package:phuonghai/ui/group_settings/widgets/textfield_rename_modal.dart';
import 'package:phuonghai/ui/smartph/smartph_page.dart';
import 'package:phuonghai/ui/widgets/confirm_bottom_modal.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

class DashboardPageWeb extends StatefulWidget {
  const DashboardPageWeb({Key? key}) : super(key: key);

  @override
  State<DashboardPageWeb> createState() => _DashboardPageWebState();
}

class _DashboardPageWebState extends State<DashboardPageWeb> {
  bool _visible = true;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceHttp = Provider.of<DeviceHttp>(context, listen: false);
      deviceHttp.initDeviceHttp();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceHttp>(
      builder: (_, state, __) {
        return state.isBusy == 1
            ? SizedBox(
                child: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.white,
                    size: 40,
                    secondRingColor: Colors.purple,
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.green,
                body: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        padding: const EdgeInsets.all(8),
                        decoration:
                            const BoxDecoration(color: Color(0xff087f23)),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            TextButton.icon(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(Routes.settings),
                              style:
                                  TextButton.styleFrom(primary: Colors.white),
                              icon: const Icon(Icons.settings),
                              label: Text(state.email ?? "N/A"),
                            ),
                            TextButton.icon(
                              onPressed: () => setState(() {
                                _visible = !_visible;
                              }),
                              style:
                                  TextButton.styleFrom(primary: Colors.white),
                              icon: _visible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              label: Text(
                                _visible
                                    ? AppLocalizations.of(context)
                                        .translate('txtHideAllDevices')
                                    : AppLocalizations.of(context)
                                        .translate('txtShowAllDevices'),
                              ),
                            ),
                            TextButton.icon(
                              style:
                                  TextButton.styleFrom(primary: Colors.white),
                              icon: const Icon(Icons.add_box),
                              label: Text(
                                AppLocalizations.of(context)
                                    .translate('createGroup'),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  constraints:
                                      const BoxConstraints(maxWidth: 600),
                                  builder: (_) => const TextFieldCreateModal(),
                                );
                              },
                            ),
                            TextButton.icon(
                              style:
                                  TextButton.styleFrom(primary: Colors.white),
                              icon: const Icon(Icons.search),
                              label: Text(
                                AppLocalizations.of(context)
                                    .translate('search'),
                              ),
                              onPressed: () async {
                                await FilterListDelegate.show<DeviceModel>(
                                  enableOnlySingleSelection: true,
                                  context: context,
                                  list: state.groups[0].devices,
                                  theme: FilterListDelegateThemeData(
                                    listTileTheme: ListTileThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      selectedTileColor:
                                          Colors.green.withOpacity(.2),
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
                                  emptySearchChild: const Center(
                                      child: Text('No device found')),
                                  searchFieldHint: AppLocalizations.of(context)
                                      .translate('searchHint'),
                                  searchFieldStyle:
                                      const TextStyle(fontSize: 16),
                                  onApplyButtonClick: (list) {
                                    if (list != null) {
                                      Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SmartpHPage(model: list[0]),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            if (state.isBusy == 2)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 5),
                                  LoadingAnimationWidget.discreteCircle(
                                    color: Colors.white,
                                    size: 15,
                                    secondRingColor: Colors.purple,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('txtRefresh'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                            controller: ScrollController(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                if (_visible) {
                                  return GroupWebWidget(
                                    group: state.groups[index],
                                    enable: false,
                                  );
                                }
                                return const SizedBox.shrink();
                              } else {
                                return GroupWebWidget(
                                  group: state.groups[index],
                                  enable: true,
                                );
                              }
                            },
                            separatorBuilder: (_, __) {
                              if (__ == 0 && _visible == false) {
                                return const SizedBox.shrink();
                              }
                              return const SizedBox(width: 15);
                            },
                            itemCount: state.groups.length),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

class GroupWebWidget extends StatelessWidget {
  const GroupWebWidget({
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
    return Container(
      width: 380,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          group.devices.length.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        locale.translate(group.name),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (enable) ...[
                  IconButton(
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
                    splashRadius: 18,
                    iconSize: 22,
                    tooltip: locale.translate('renameGroup'),
                    color: Colors.black54,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    splashRadius: 18,
                    iconSize: 22,
                    color: Colors.black54,
                    tooltip: locale.translate('addDevice'),
                    icon: const Icon(Icons.exposure_outlined),
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
                        searchFieldHint: locale.translate('searchHint'),
                        searchFieldStyle: const TextStyle(fontSize: 16),
                        applyButtonText: locale.translate('txtDone'),
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
                  ),
                  IconButton(
                    splashRadius: 18,
                    iconSize: 22,
                    tooltip: locale.translate('deleteGroup'),
                    color: Colors.black54,
                    icon: const Icon(Icons.clear),
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
                  ),
                ]
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              controller: ScrollController(),
              shrinkWrap: true,
              itemBuilder: ((context, index) =>
                  SmartpHCard(model: group.devices[index])),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: group.devices.length,
            ),
          ),
        ],
      ),
    );
  }
}
