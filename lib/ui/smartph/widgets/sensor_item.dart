import 'package:flutter/material.dart';
import 'package:phuonghai/models/device_model.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/ui/widgets/status_widget.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

class SensorItem extends StatefulWidget {
  const SensorItem({
    Key? key,
    required this.sensor,
    required this.enableSet,
  }) : super(key: key);

  final SensorSmartpH sensor;
  final bool enableSet;

  @override
  State<SensorItem> createState() => _SensorItemState();
}

class _SensorItemState extends State<SensorItem> {
  @override
  Widget build(BuildContext context) {
    // final locale = AppLocalizations.of(context);
    // String _text = '';
    // if (widget.sensor.color == Colors.grey) {
    //   _text = locale.translate('txtError');
    // } else if (widget.sensor.color == Colors.blueGrey) {
    //   _text = locale.translate('txtNormalDevice');
    // } else if (widget.sensor.color == Colors.green) {
    //   _text = locale.translate('txtValuesInThres');
    // } else if (widget.sensor.color == Colors.red) {
    //   _text = locale.translate('txtValuesOutThres');
    // }

    return InkWell(
      onTap: () async {
        if (widget.enableSet) {
          await showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: false,
            context: context,
            constraints: const BoxConstraints(maxWidth: 600),
            builder: (context) {
              return AlarmModal(sensor: widget.sensor);
            },
          );
          setState(() {});
        }
      },
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: widget.sensor.color.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            width: 1.2,
            color: widget.sensor.color,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.sensor.name,
              style: TextStyle(
                color: widget.sensor.status == "Error"
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
            Text(
              "${widget.sensor.value}",
              style: TextStyle(
                fontSize: 15,
                color: widget.sensor.status == "Error"
                    ? Colors.grey
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.sensor.unit,
              style: TextStyle(
                color: widget.sensor.status == "Error"
                    ? Colors.grey
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlarmModal extends StatefulWidget {
  const AlarmModal({Key? key, required this.sensor}) : super(key: key);

  final SensorSmartpH sensor;
  @override
  State<AlarmModal> createState() => _AlarmModalState();
}

class _AlarmModalState extends State<AlarmModal> {
  @override
  void initState() {
    _value = widget.sensor.activeAlarm;
    if (widget.sensor.activeAlarm) {
      _minController.text = widget.sensor.minAlarm.toString();
      _maxController.text = widget.sensor.maxAlarm.toString();
    }

    super.initState();
  }

  @override
  dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  late bool _value;
  bool error = false;
  String status = "";
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return SafeArea(
      child: Container(
        height: 450,
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
        child: Column(
          children: [
            ListTile(
              title:
                  Text("${locale.translate('txtNoti')} ${widget.sensor.name}"),
              leading: Checkbox(
                value: _value,
                onChanged: (newValue) {
                  setState(() {
                    _minController.text = '';
                    _maxController.text = '';
                    _value = newValue!;
                  });
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: _value,
                    controller: _minController,
                    decoration: InputDecoration(
                      labelText: locale.translate('txtMinThres'),
                      hintText: locale.translate('txtTapToEnter'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    enabled: _value,
                    controller: _maxController,
                    decoration: InputDecoration(
                      labelText: locale.translate('txtMaxThres'),
                      hintText: locale.translate('txtTapToEnter'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Spacer(),
            StatusWidget(error: error, text: status),
            const SizedBox(height: 20),
            DefaultButton(
              width: 300,
              text: locale.translate('txtSave'),
              press: () async {
                if (_value) {
                  try {
                    final minValue = double.parse(_minController.text);
                    final maxValue = double.parse(_maxController.text);
                    if (minValue >= maxValue) {
                      error = true;
                      status = locale.translate('txtThresError');
                    } else {
                      final device =
                          Provider.of<DeviceHttp>(context, listen: false);

                      widget.sensor.activeAlarm = true;
                      widget.sensor.minAlarm = minValue;
                      widget.sensor.maxAlarm = maxValue;
                      await device.syncAlarmConfig(widget.sensor);

                      Future.delayed(
                        const Duration(milliseconds: 250),
                        () => Navigator.of(context).pop(),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      error = true;
                      status = locale.translate('txtValueError');
                    });
                  }
                } else {
                  final device =
                      Provider.of<DeviceHttp>(context, listen: false);
                  widget.sensor.activeAlarm = false;
                  await device.syncAlarmConfig(widget.sensor);

                  Future.delayed(
                    const Duration(milliseconds: 250),
                    () => Navigator.of(context).pop(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
