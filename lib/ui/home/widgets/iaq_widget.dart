import 'package:flutter/material.dart';
import 'package:phuonghai/models/device_model.dart';
import 'package:phuonghai/ui/smartph/smartph_page.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:websafe_svg/websafe_svg.dart';

class IaqCard extends StatelessWidget {
  const IaqCard({Key? key, required this.device}) : super(key: key);

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return device.sensors.isEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            constraints: const BoxConstraints(minHeight: 250),
            child: const Text("Chưa có dữ liệu"))
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            constraints: const BoxConstraints(minHeight: 250),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              child: Column(
                children: [
                  InkWell(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SmartpHPage(model: device)),
                      );
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: device
                            .sensors[device.sensors
                                .indexWhere((i) => i.name == 'IAQ')]
                            .color
                            .withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            device.friendlyName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            "${AppLocalizations.of(context).translate("lastUpdated")}: ${device.getSyncDate}",
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 2),
                    decoration: BoxDecoration(
                      color: device
                          .sensors[
                              device.sensors.indexWhere((i) => i.name == 'IAQ')]
                          .color
                          .withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IaqRating(
                          sensor: device.sensors[device.sensors
                              .indexWhere((i) => i.name == 'IAQ')],
                        ),
                        const SizedBox(width: 15),
                        Column(
                          children: [
                            for (var i in device.sensors)
                              if (i.name != 'IAQ') IaqSensorItem(sensor: i)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class IaqRating extends StatelessWidget {
  const IaqRating({Key? key, required this.sensor}) : super(key: key);
  final SensorIaq sensor;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: sensor.value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: sensor.color,
                ),
              ),
              const TextSpan(
                text: ' Greenlab IAQ',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        WebsafeSvg.asset(
          'assets/icons/${sensor.status}.svg',
          height: 100,
        ),
        const SizedBox(height: 5),
        Text(locale.translate('airQuality')),
        const SizedBox(height: 2),
        Text(
          locale.translate(sensor.status).toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class IaqSensorItem extends StatelessWidget {
  const IaqSensorItem({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  final SensorIaq sensor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 30,
      padding: const EdgeInsets.only(left: 8, right: 4),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            child: Text(sensor.name),
          ),
          VerticalDivider(
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: sensor.color,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              "${sensor.value}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 45,
            child: Text(
              sensor.unit,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
