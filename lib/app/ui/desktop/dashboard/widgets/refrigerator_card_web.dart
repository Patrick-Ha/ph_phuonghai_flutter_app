import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/refrigerator.dart';

import '../../../common/widgets/header_card.dart';
import '../../../common/widgets/refri_item_widget.dart';

class RefrigeratorCardWeb extends StatelessWidget {
  const RefrigeratorCardWeb({
    Key? key,
    required this.model,
  }) : super(key: key);
  final Refrigerator model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderCard(model: model),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Obx(
            () => model.isActived.value
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: RefriItemWidget(sensor: model.sensor),
                      ),
                      MapCardWeb(model: model),
                    ],
                  )
                : SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.report,
                          size: 50,
                          color: Colors.amber,
                        ),
                        Text(
                          "${"lostConnection".tr}: ${model.getSyncDateObs}",
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class MapCardWeb extends StatefulWidget {
  final Refrigerator model;

  const MapCardWeb({Key? key, required this.model}) : super(key: key);

  @override
  State<MapCardWeb> createState() => _MapCardWebState();
}

class _MapCardWebState extends State<MapCardWeb> {
  final mapController = MapController();
  // final popupLayerController = PopupController();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return Container(
    //   height: 470,
    //   padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
    //   child: FlutterMap(
    //     mapController: mapController,
    //     options: MapOptions(
    //       center: LatLng(widget.model.sensor.lat, widget.model.sensor.long),
    //       zoom: 16,
    //       maxZoom: 22,
    //       interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
    //       enableScrollWheel: false,
    //       onTap: (_, __) => popupLayerController.hideAllPopups(),
    //     ),
    //     children: [
    //       TileLayer(
    //         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    //         retinaMode: true,
    //         maxZoom: 22,
    //         userAgentPackageName: 'com.phuonghai',
    //       ),
    //       Obx(() {
    //         // Future.delayed(const Duration(milliseconds: 50), () {
    //         //   if (widget.model.updateCamera == 1) {
    //         //     mapController.move(widget.model.markers.first.point, 16);
    //         //   } else if (widget.model.updateCamera == 2) {
    //         //     mapController.move(widget.model.markers.last.point, 16);
    //         //     widget.model.updateCamera = 0;
    //         //   }
    //         // });

    //         return PopupMarkerLayerWidget(
    //           options: PopupMarkerLayerOptions(
    //             popupController: popupLayerController,
    //             //markers: widget.model.markers.value,
    //             markerRotateAlignment:
    //                 PopupMarkerLayerOptions.rotationAlignmentFor(
    //                     AnchorAlign.top),
    //             popupBuilder: (BuildContext context, Marker marker) =>
    //                 MarkerPopup(marker: marker),
    //           ),
    //         );
    //       }),
    //     ],
    //     nonRotatedChildren: [
    //       Obx(
    //         () => Positioned(
    //           top: 4,
    //           left: 4,
    //           child: widget.model.sensor.gpsState.value == 'Error'
    //               ? Container(
    //                   height: 30,
    //                   decoration: BoxDecoration(
    //                     color: Colors.red,
    //                     borderRadius: BorderRadius.circular(4),
    //                   ),
    //                   alignment: Alignment.center,
    //                   padding: const EdgeInsets.symmetric(horizontal: 8),
    //                   child: Text(
    //                     "lostGPS".tr,
    //                     style: const TextStyle(color: Colors.white),
    //                   ),
    //                 )
    //               : const SizedBox.shrink(),
    //         ),
    //       ),
    //       Positioned(
    //         right: 8,
    //         bottom: 8,
    //         child: Material(
    //           elevation: 1,
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(4),
    //           child: Container(
    //             width: 30,
    //             height: 65,
    //             padding: const EdgeInsets.symmetric(vertical: 4),
    //             child: Column(
    //               children: [
    //                 Expanded(
    //                   child: InkWell(
    //                     borderRadius: BorderRadius.circular(4),
    //                     onTap: () => mapController.move(
    //                         mapController.center, mapController.zoom + 0.5),
    //                     child: const Icon(Icons.add),
    //                   ),
    //                 ),
    //                 const Divider(
    //                   color: Colors.black54,
    //                   height: 1,
    //                   indent: 4,
    //                   endIndent: 4,
    //                 ),
    //                 Expanded(
    //                   child: InkWell(
    //                     borderRadius: BorderRadius.circular(4),
    //                     onTap: () => mapController.move(
    //                         mapController.center, mapController.zoom - 0.5),
    //                     child: const Icon(Icons.remove),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         right: 8,
    //         bottom: 80,
    //         child: Material(
    //           elevation: 1,
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(4),
    //           child: Container(
    //             width: 30,
    //             height: 32,
    //             padding: const EdgeInsets.all(4),
    //             child: InkWell(
    //               borderRadius: BorderRadius.circular(4),
    //               onTap: () {
    //                 mapController.move(
    //                   LatLng(widget.model.sensor.lat, widget.model.sensor.long),
    //                   16,
    //                 );
    //               },
    //               child: const Icon(
    //                 Icons.gps_fixed,
    //                 size: 20,
    //                 color: Colors.blueAccent,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class MarkerPopup extends StatelessWidget {
  final Marker marker;
  const MarkerPopup({Key? key, required this.marker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              marker.key.toString().substring(3, 20),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              marker.point.latitude == 0
                  ? "lostGPS".tr
                  : '${marker.point.latitude}, ${marker.point.longitude}',
              style: const TextStyle(fontSize: 13.0),
            ),
          ],
        ),
      ),
    );
  }
}
