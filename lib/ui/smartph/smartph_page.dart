import 'package:flutter/material.dart';
import 'package:phuonghai/constants/colors.dart';
import 'package:phuonghai/models/device_model.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/ui/home/widgets/iaq_widget.dart';
import 'package:phuonghai/ui/smartph/widgets/dowload_modal.dart';
import 'package:phuonghai/ui/smartph/widgets/historical_data_widget.dart';
import 'package:phuonghai/ui/smartph/widgets/sensor_item.dart';
import 'package:phuonghai/ui/widgets/divider_with_text.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class SmartpHPage extends StatefulWidget {
  const SmartpHPage({Key? key, required this.model}) : super(key: key);

  final DeviceModel model;

  @override
  State<SmartpHPage> createState() => _SmartpHPageState();
}

class _SmartpHPageState extends State<SmartpHPage> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.model.friendlyName),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.kGradient),
        ),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              constraints: const BoxConstraints(maxWidth: 600),
              builder: (context) {
                return const ColorIndicatorModal();
              },
            ),
            icon: const Icon(Icons.palette_outlined),
          ),
          IconButton(
            onPressed: () => showModalBottomSheet(
                context: context,
                constraints: const BoxConstraints(maxWidth: 600),
                builder: (context) {
                  return DownloadModal(sn: widget.model.key);
                }),
            icon: const Icon(Icons.cloud_download_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              //physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20),
                Consumer<DeviceHttp>(
                  builder: (_, state, __) {
                    return Column(
                      children: [
                        if (widget.model.type != "Air Node") ...[
                          DividerWithText(
                            text:
                                "${locale.translate('lastUpdated')}: ${widget.model.getSyncDate}",
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (widget.model.type == "Air Node")
                          IaqCard(device: widget.model)
                        else
                          ResponsiveGridList(
                            scroll: false,
                            desiredItemWidth: 80,
                            minSpacing: 10,
                            children: [
                              for (var i in widget.model.sensors)
                                SensorItem(sensor: i, enableSet: true),
                            ],
                          )
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                DividerWithText(text: locale.translate('txDataHistory')),
                HistoricalDataWidget(sensors: widget.model.sensors),
                const SizedBox(height: 20),
                _deviceInfo(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deviceInfo(BuildContext context) {
    return Column(
      children: [
        DividerWithText(
          text: AppLocalizations.of(context).translate("txtDeviceInfo"),
        ),
        ListTile(
          title: Text(
            widget.model.friendlyName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 6),
        ListTile(
          title: Text(AppLocalizations.of(context).translate("txtModelDevice")),
          trailing: Text(widget.model.model,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const Divider(height: 6),
        ListTile(
          title:
              Text(AppLocalizations.of(context).translate("txtSerialNumber")),
          trailing: Text(widget.model.key,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const Divider(height: 6),
        ListTile(
          title: Text(AppLocalizations.of(context).translate("txtDescription")),
          subtitle: Text(widget.model.description),
          isThreeLine: true,
        ),
        const Divider(height: 6),
      ],
    );
  }
}

class ColorIndicatorModal extends StatefulWidget {
  const ColorIndicatorModal({Key? key}) : super(key: key);

  @override
  State<ColorIndicatorModal> createState() => _ColorIndicatorModalState();
}

class _ColorIndicatorModalState extends State<ColorIndicatorModal> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      height: 450,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: Column(
        children: [
          Text(
            locale.translate('txtColorIndicator'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            locale.translate('txtTapAndHold'),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: Text(locale.translate('txtError')),
            leading: const Icon(
              Icons.rectangle_rounded,
              color: Colors.grey,
            ),
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(locale.translate('txtTurnOffAlarm')),
            subtitle: Text(locale.translate('txtNormalDevice')),
            leading: const Icon(
              Icons.rectangle_rounded,
              color: Colors.blueGrey,
            ),
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(locale.translate('txtTurnOnAlarm')),
            subtitle: Text(locale.translate('txtValuesInThres')),
            leading: const Icon(
              Icons.rectangle_rounded,
              color: Colors.green,
            ),
          ),
          const Divider(height: 10),
          ListTile(
            title: Text(locale.translate('txtTurnOnAlarm')),
            subtitle: Text(locale.translate('txtValuesOutThres')),
            leading: const Icon(
              Icons.rectangle_rounded,
              color: Colors.red,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
