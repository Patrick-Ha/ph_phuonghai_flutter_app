import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/refrigerator.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/common/widgets/refri_item_widget.dart';
import 'package:phuonghai/app/ui/mobile/device/device_info.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class RefiDevicePage extends StatefulWidget {
  const RefiDevicePage({Key? key, required this.model}) : super(key: key);
  final Refrigerator model;

  @override
  _RefiDevicePageState createState() => _RefiDevicePageState();
}

class _RefiDevicePageState extends State<RefiDevicePage> {
  final _fabHeight = 120.0.obs;
  final double _panelHeightOpen = Get.height * 0.8;
  final double _panelHeightClosed = 95.0;
  late final ScrollController scrollController;
  late final PanelController panelController;

  @override
  void initState() {
    scrollController = ScrollController();
    panelController = PanelController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
            snapPoint: 0.75,
            disableDraggableOnScrolling: true,
            header: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ForceDraggableWidget(
                    child: Container(
                      width: 100,
                      height: 40,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        width: 30,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            controller: panelController,
            scrollController: scrollController,
            panelBuilder: () => _panel(),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => (_fabHeight.value =
                pos * (_panelHeightOpen - _panelHeightClosed) + 120),
          ),

          // the fab
          Obx(
            () => Positioned(
              right: 20.0,
              bottom: _fabHeight.value,
              child: FloatingActionButton(
                heroTag: 'gps_button',
                onPressed: () {},
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.gps_fixed,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
          Obx(
            () => Positioned(
              left: 20.0,
              bottom: _fabHeight.value,
              child: FloatingActionButton(
                heroTag: 'back_button',
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          Positioned(
              top: 0,
              child: ClipRRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).padding.top,
                        color: Colors.transparent,
                      )))),
        ],
      ),
    );
  }

  Widget _panel() {
    return ListView(
      physics: PanelScrollPhysics(controller: panelController),
      controller: scrollController,
      padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
      children: [
        Text(
          widget.model.friendlyName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
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
        //HistoryRefriWidget(model: widget.model),
        HistoryWidget(
          sensors: [widget.model.sensor.temp, widget.model.sensor.pin],
        ),
        DeviceInfo(model: widget.model),
      ],
    );
  }

  Widget _body() {
    return FlutterMap(
      options: MapOptions(
        // center: LatLng(widget.model.sensor.lat, widget.model.sensor.long),
        zoom: 15.5,
        maxZoom: 22,
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey={apiKey}",
          additionalOptions: const {
            "apiKey": "b0b5b66b87394a549252b29febaaa77c",
          },
          maxZoom: 22,
          userAgentPackageName: 'com.phuonghai',
          // retinaMode: true,
        ),
        const MarkerLayer(
          markers: [
            // Marker(
            //   point: LatLng(widget.model.sensor.lat, widget.model.sensor.long),
            //   width: 26,
            //   height: 26,
            //   builder: (context) => const AvatarGlow(
            //     child: Icon(
            //       Icons.radio_button_checked,
            //       size: 20,
            //       color: Colors.blue,
            //     ),
            //     endRadius: 22,
            //     glowColor: Colors.blueAccent,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}

// class HistoryRefriWidget extends StatefulWidget {
//   const HistoryRefriWidget({Key? key, required this.model}) : super(key: key);
//   final Refrigerator model;

//   @override
//   State<HistoryRefriWidget> createState() => _HistoryRefriWidgetState();
// }

// class _HistoryRefriWidgetState extends State<HistoryRefriWidget> {
//   List<String> list = <String>[
//     '3h',
//     '24h',
//     'selectDate',
//   ];

//   final dropdownValue = '3h'.tr.obs;
//   final enableDateRange = false.obs;
//   final historyItems = [].obs;
//   final refresh = false.obs;
//   final _controller = ScrollController();
//   final _controller1 = TextEditingController();
//   final _controller2 = TextEditingController();
//   final Dio dio = Dio();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final end = DateTime.now();
//       final start = end.subtract(const Duration(hours: 3));
//       getHistoryData(start, end);
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _controller1.dispose();
//     _controller2.dispose();
//     super.dispose();
//   }

//   void getHistoryData(DateTime start, DateTime end) async {
//     refresh.value = true;
//     String _start = DateFormat('yyyy-M-d').format(start);
//     String _end = DateFormat('yyyy-M-d').format(end);
//     try {
//       final response = await dio.get(
//         'http://thegreenlab.xyz:3000/Datums/DataByDateJson?DeviceSerialNumber=${widget.model.key}&StartDate=$_start&EndDate=$_end',
//         options: Options(
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization":
//                 "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
//           },
//         ),
//       );
//       response.data.removeWhere(
//         (item) =>
//             DateTime.parse(item["Date"]).isBefore(start) ||
//             DateTime.parse(item["Date"]).isAfter(end),
//       );
//       final tempList =
//           response.data.where((o) => o['SensorType'] == 'Temp').toList();
//       final lockList =
//           response.data.where((o) => o['SensorType'] == 'Lock').toList();
//       final pinList =
//           response.data.where((o) => o['SensorType'] == 'Pin').toList();
//       final latList =
//           response.data.where((o) => o['SensorType'] == 'Lat').toList();
//       final longList =
//           response.data.where((o) => o['SensorType'] == 'Long').toList();
//       historyItems.clear();
//       for (var i = 0; i < tempList.length; i++) {
//         final ref = RefriItem(key: tempList[i]['DeviceSerialNumber']);
//         ref.lat = latList[i]['Value'].toDouble();
//         ref.long = longList[i]['Value'].toDouble();
//         ref.lock.val.value = lockList[i]['Value'].toDouble();
//         ref.pin.val.value = pinList[i]['Value'].toDouble();
//         ref.processPinLock();
//         ref.temp.val.value = tempList[i]['Value'].toDouble();
//         ref.timeUpdated = DateFormat('d-M-yyyy, HH:mm').format(
//           DateTime.parse(tempList[i]['Date']),
//         );
//         historyItems.insert(0, ref);
//       }
//     } catch (e) {
//       debugPrint("[getHistoryData] ${e.toString()}");
//     }
//     refresh.value = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Obx(
//                 () => DropdownButton<String>(
//                   value: dropdownValue.value,
//                   style: const TextStyle(color: Colors.deepPurple),
//                   underline: Container(
//                     height: 2,
//                     color: Colors.deepPurple,
//                   ),
//                   onChanged: (String? value) {
//                     dropdownValue.value = value!;
//                     if (value == 'selectDate'.tr) {
//                       enableDateRange.value = true;
//                     } else {
//                       _controller1.text = _controller2.text = '';
//                       enableDateRange.value = false;
//                     }
//                   },
//                   items: list.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value.tr,
//                       child: Text(value.tr),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const Spacer(),
//               Material(
//                 color: Colors.white,
//                 child: IconButton(
//                   splashRadius: 24,
//                   color: Colors.deepPurple,
//                   tooltip: 'search'.tr,
//                   icon: const Icon(Icons.search),
//                   onPressed: () async {
//                     late DateTime end, start;
//                     if (dropdownValue.value == '3h'.tr) {
//                       end = DateTime.now();
//                       start = end.subtract(const Duration(hours: 3));
//                       getHistoryData(start, end);
//                     } else if (dropdownValue.value == '24h'.tr) {
//                       end = DateTime.now();
//                       start = end.subtract(const Duration(hours: 24));
//                       getHistoryData(start, end);
//                     } else {
//                       if (_controller1.text.isNotEmpty &&
//                           _controller2.text.isNotEmpty) {
//                         start = DateTime.parse(_controller1.text);
//                         end = DateTime.parse(_controller2.text);
//                         if (start.isAfter(end)) {
//                           Helper.showError('downloadWrongDate'.tr);
//                         } else {
//                           getHistoryData(start, end);
//                         }
//                       } else {
//                         Helper.showError('downloadWrongDate'.tr);
//                       }
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Obx(
//           () => Row(
//             children: [
//               Expanded(
//                 child: DateTimePicker(
//                   type: DateTimePickerType.dateTime,
//                   dateMask: 'd/M/yyyy - HH:mm',
//                   use24HourFormat: true,
//                   enabled: enableDateRange.value,
//                   controller: _controller1,
//                   decoration: InputDecoration(
//                     labelText: 'fromDate'.tr,
//                     filled: true,
//                     isDense: true,
//                     fillColor: Colors.grey.shade200,
//                   ),
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2022),
//                   lastDate: DateTime.now(),
//                   locale: Get.locale,
//                 ),
//               ),
//               const SizedBox(width: 5),
//               Expanded(
//                 child: DateTimePicker(
//                   type: DateTimePickerType.dateTime,
//                   dateMask: 'd/M/yyyy - HH:mm',
//                   use24HourFormat: true,
//                   controller: _controller2,
//                   enabled: enableDateRange.value,
//                   decoration: InputDecoration(
//                     labelText: 'toDate'.tr,
//                     filled: true,
//                     isDense: true,
//                     fillColor: Colors.grey.shade200,
//                   ),
//                   firstDate: DateTime(2022),
//                   lastDate: DateTime.now(),
//                   initialDate: DateTime.now(),
//                   locale: Get.locale,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Obx(
//           () => Container(
//             height: 440,
//             padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(2),
//             ),
//             child: refresh.value
//                 ? Center(
//                     child: LoadingAnimationWidget.hexagonDots(
//                       color: Colors.green,
//                       size: 50,
//                     ),
//                   )
//                 : historyItems.isEmpty
//                     ? Center(child: Text('noData'.tr))
//                     : Scrollbar(
//                         thumbVisibility: true,
//                         trackVisibility: true,
//                         controller: _controller,
//                         child: ListView.separated(
//                           controller: _controller,
//                           padding: const EdgeInsets.only(right: 12),
//                           itemBuilder: (context, index) =>
//                               HistoryRefriItemMobile(
//                             model: widget.model,
//                             item: historyItems[index],
//                           ),
//                           itemCount: historyItems.length,
//                           separatorBuilder: (context, index) =>
//                               const SizedBox(height: 8),
//                         ),
//                       ),
//           ),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }
// }
