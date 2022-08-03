import 'package:flutter/material.dart';
import 'package:phuonghai/models/device_model.dart';
import 'package:phuonghai/ui/home/widgets/iaq_widget.dart';
import 'package:phuonghai/ui/smartph/smartph_page.dart';
import 'package:phuonghai/ui/smartph/widgets/sensor_item.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:responsive_grid/responsive_grid.dart';

class SmartpHCard extends StatelessWidget {
  const SmartpHCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final DeviceModel model;

  @override
  Widget build(BuildContext context) {
    return model.type == "Air Node"
        ? IaqCard(device: model)
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
                  _header(context),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 0),
                    child: ResponsiveGridList(
                      desiredItemWidth: 76,
                      minSpacing: 8,
                      scroll: false,
                      children: [
                        for (var i in model.sensors)
                          SensorItem(
                            sensor: i,
                            enableSet: false,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _header(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return InkWell(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SmartpHPage(model: model)),
        );
      },
      child: Container(
        height: 55,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10),
        // decoration: BoxDecoration(
        //   color: Colors.red.withOpacity(0.5),
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(4),
        //     topRight: Radius.circular(4),
        //   ),
        // ),
        child: Column(
          children: [
            Text(
              model.friendlyName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                //fontSize: 15,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              "${locale.translate("lastUpdated")}: ${model.getSyncDate}",
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
            Row(
              children: const [
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Divider(
                    height: 10,
                    thickness: 1.5,
                    color: Colors.blueGrey,
                  ),
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
    );
  }
}
