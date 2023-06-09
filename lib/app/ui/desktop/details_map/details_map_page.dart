import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/refrigerator.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/common/widgets/refri_item_widget.dart';
import 'package:latlong2/latlong.dart';

class DetailRefriPage extends StatefulWidget {
  const DetailRefriPage({Key? key, required this.model}) : super(key: key);

  final Refrigerator model;

  @override
  State<DetailRefriPage> createState() => _DetailRefriPageState();
}

class _DetailRefriPageState extends State<DetailRefriPage> {
  // final historyItems = [].obs;
  // final refresh = false.obs;
  // final _controller = ScrollController();
  // final Dio dio = Dio();
  // final c = Get.find<HomeController>();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final end = DateTime.now();
  //     final start = end.subtract(const Duration(hours: 3));
  //     getHistoryData(start, end);
  //   });
  // }

  // void getHistoryData(DateTime start, DateTime end) async {
  //   refresh.value = true;
  //   String _start = DateFormat('yyyy-M-d').format(start);
  //   String _end = DateFormat('yyyy-M-d').format(end);
  //   try {
  //     final response = await dio.get(
  //       'http://thegreenlab.xyz:3000/Datums/DataByDateJson?DeviceSerialNumber=${widget.model.key}&StartDate=$_start&EndDate=$_end',
  //       options: Options(
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization":
  //               "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
  //         },
  //       ),
  //     );
  //     response.data.removeWhere(
  //       (item) =>
  //           DateTime.parse(item["Date"]).isBefore(start) ||
  //           DateTime.parse(item["Date"]).isAfter(end),
  //     );
  //     final tempList =
  //         response.data.where((o) => o['SensorType'] == 'Temp').toList();
  //     final lockList =
  //         response.data.where((o) => o['SensorType'] == 'Lock').toList();
  //     final pinList =
  //         response.data.where((o) => o['SensorType'] == 'Pin').toList();
  //     final latList =
  //         response.data.where((o) => o['SensorType'] == 'Lat').toList();
  //     final longList =
  //         response.data.where((o) => o['SensorType'] == 'Long').toList();
  //     historyItems.clear();

  //     for (var i = 0; i < tempList.length; i++) {
  //       final ref = RefriItem(key: tempList[i]['DeviceSerialNumber']);
  //       ref.lat = latList[i]['Value'].toDouble();
  //       ref.long = longList[i]['Value'].toDouble();
  //       ref.lock.val.value = lockList[i]['Value'].toDouble();
  //       ref.pin.val.value = pinList[i]['Value'].toDouble();
  //       ref.processPinLock();
  //       ref.temp.val.value = tempList[i]['Value'].toDouble();
  //       ref.timeUpdated = DateFormat('d-M-yyyy, HH:mm').format(
  //         DateTime.parse(tempList[i]['Date']),
  //       );
  //       historyItems.insert(0, ref);
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  //   refresh.value = false;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => DividerWithText(
            text: "${"lastUpdated".tr}: ${widget.model.getSyncDateObs}",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: RefriItemWidget(
            sensor: widget.model.sensor,
            isSetting: true,
          ),
        ),
        DividerWithText(text: 'dataHistory'.tr),
        HistoryWidget(
          sensors: [widget.model.sensor.temp, widget.model.sensor.pin],
        ),
        // Obx(
        //   () => Container(
        //     height: 480,
        //     padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6),
        //     color: Colors.grey.shade100,
        //     child: refresh.value
        //         ? Center(
        //             child: LoadingAnimationWidget.hexagonDots(
        //               color: Colors.green,
        //               size: 50,
        //             ),
        //           )
        //         : historyItems.isEmpty
        //             ? Center(child: Text('noData'.tr))
        //             : Scrollbar(
        //                 thumbVisibility: true,
        //                 trackVisibility: true,
        //                 controller: _controller,
        //                 child: ListView.separated(
        //                   controller: _controller,
        //                   padding: const EdgeInsets.only(right: 12),
        //                   itemBuilder: (context, index) => HistoryRefriItem(
        //                     item: historyItems[index],
        //                   ),
        //                   itemCount: historyItems.length,
        //                   separatorBuilder: (context, index) =>
        //                       const Divider(height: 8),
        //                 ),
        //               ),
        //   ),
        // ),
      ],
    );
  }
}

class HistoryRefriItem extends StatefulWidget {
  const HistoryRefriItem({Key? key, required this.item}) : super(key: key);
  final RefriItem item;

  @override
  State<HistoryRefriItem> createState() => _HistoryRefriItemState();
}

class _HistoryRefriItemState extends State<HistoryRefriItem> {
  final c = Get.find<HomeController>();

  void processMarker() {
    if (widget.item.isSelected.isFalse) {
      c.detailDevice[0].markers.removeWhere(
        (item) => item.key == Key(widget.item.timeUpdated),
      );
      if (c.detailDevice[0].markers.length == 1) {
        c.detailDevice[0].updateCamera = 1;
      } else {
        c.detailDevice[0].updateCamera = 0; // not update
      }
    } else {
      c.detailDevice[0].updateCamera = 2; // add ->  update last
      final index = c.detailDevice[0].markers.indexWhere(
        (item) => item.key == Key(widget.item.timeUpdated),
      );
      if (index == -1) {
        c.detailDevice[0].markers.add(
          Marker(
            key: Key(widget.item.timeUpdated),
            point: LatLng(widget.item.lat, widget.item.long),
            builder: (_) => const Icon(
              Icons.location_on,
              size: 30,
              color: Colors.deepPurple,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
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
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: Text(widget.item.timeUpdated),
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
          // BatteryIndicator(
          //   batteryFromPhone: false,
          //   batteryLevel: widget.item.pin.val.value.toInt(),
          //   style: BatteryIndicatorStyle.skeumorphism,
          // ),
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
