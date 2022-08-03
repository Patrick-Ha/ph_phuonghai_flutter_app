import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/models/device_model.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/ui/smartph/smartph_page.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'widgets/group_modal.dart';
import 'widgets/smartph_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Consumer<DeviceHttp>(
      builder: (_, state, __) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: state.isBusy == 1
                ? LoadingAnimationWidget.discreteCircle(
                    color: Colors.white,
                    size: 18,
                    secondRingColor: Colors.purple,
                  )
                : OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size(160, 38),
                      primary: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.expand_more,
                      color: Colors.yellowAccent,
                    ),
                    label: Text(
                      locale.translate(state.groups[state.groupSelected].name),
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        constraints: const BoxConstraints(maxWidth: 600),
                        builder: (context) {
                          return const GroupBottomModal();
                        },
                      );
                      setState(() {});
                    },
                  ),
            actions: [
              if (state.isBusy == 2)
                Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.white,
                    size: 18,
                    secondRingColor: Colors.purple,
                  ),
                ),
              IconButton(
                splashRadius: 22,
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
                    tileLabel: (user) => "${user?.friendlyName}\n#${user?.key}",
                    emptySearchChild:
                        const Center(child: Text('No device found')),
                    searchFieldHint:
                        AppLocalizations.of(context).translate('searchHint'),
                    searchFieldStyle: const TextStyle(fontSize: 16),
                    onApplyButtonClick: (list) {
                      if (list != null) {
                        Future.delayed(
                          const Duration(milliseconds: 350),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SmartpHPage(model: list[0]),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
                icon: const Icon(Icons.search),
              ),
              // IconButton(
              //   splashRadius: 22,
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const ScanQrcodePage()),
              //     );
              //   },
              //   icon: const Icon(
              //     Icons.qr_code_2,
              //     size: 24,
              //   ),
              // ),
            ],
          ),
          body: state.isBusy == 1
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.green,
                    size: 40,
                    secondRingColor: Colors.purple,
                  ),
                )
              : state.groups[state.groupSelected].devices.isEmpty
                  ? Center(
                      child:
                          SizedBox(child: Text(locale.translate("txtNothing"))),
                    )
                  : ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      children: [
                        ResponsiveGridList(
                          scroll: false,
                          desiredItemWidth:
                              MediaQuery.of(context).size.width < 350.0
                                  ? (MediaQuery.of(context).size.width - 20)
                                  : 350,
                          minSpacing: 10,
                          children: [
                            for (var i
                                in state.groups[state.groupSelected].devices)
                              SmartpHCard(model: i),
                          ],
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
