import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/refrigerator.dart';

class HistoryRefriItemMobile extends StatefulWidget {
  const HistoryRefriItemMobile(
      {Key? key, required this.item, required this.model})
      : super(key: key);
  final Refrigerator model;
  final RefriItem item;

  @override
  State<HistoryRefriItemMobile> createState() => _HistoryRefriItemMobileState();
}

class _HistoryRefriItemMobileState extends State<HistoryRefriItemMobile> {
  void processMarker() {
    if (widget.item.isSelected.isFalse) {
      // final index = widget.model.markers.lastIndexWhere(
      //   (item) => item.markerId.value == widget.item.timeUpdated,
      // );
      // widget.model.markers.removeAt(index);
      if (widget.model.markers.length == 1) {
        widget.model.updateCamera = 1;
      } else {
        widget.model.updateCamera = 0; // not update
      }
    } else {
      widget.model.updateCamera = 2; //  update last
      // widget.model.markers.add(
      //   Marker(
      //     markerId: MarkerId(widget.item.timeUpdated),
      //     position: LatLng(widget.item.lat, widget.item.long),
      //     infoWindow: InfoWindow(title: widget.item.timeUpdated),
      //     icon: iconMarker,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Checkbox(
              activeColor: Colors.deepPurple,
              value: widget.item.isSelected.value,
              onChanged: (bool? value) {
                widget.item.isSelected.value = value!;
                processMarker();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: Text(widget.item.timeUpdated.substring(11)),
          ),
          const Icon(
            Icons.thermostat,
            color: Colors.blueGrey,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '${widget.item.temp.val.value} °C',
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const VerticalDivider(
            color: Colors.black38,
            width: 26,
            indent: 5,
            endIndent: 5,
          ),
          widget.item.pin.status.value == 'Charging'
              ? const Icon(
                  Icons.bolt,
                  size: 18,
                  color: Colors.orangeAccent,
                )
              : const SizedBox(width: 5),
          BatteryIndicator(
            batteryFromPhone: false,
            batteryLevel: widget.item.pin.val.value.toInt(),
            style: BatteryIndicatorStyle.skeumorphism,
          ),
          const VerticalDivider(
            color: Colors.black38,
            width: 26,
            indent: 5,
            endIndent: 5,
          ),
          Tooltip(
            message: 'Khóa nắp',
            child: Icon(
              widget.item.lock.icon,
              color: widget.item.lock.color.value,
            ),
          ),
        ],
      ),
    );
  }
}
