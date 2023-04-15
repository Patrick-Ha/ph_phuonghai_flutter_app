import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/refrigerator.dart';
import 'package:latlong2/latlong.dart';
import 'package:phuonghai/app/ui/desktop/dashboard/widgets/refrigerator_card_web.dart';

import '../../../common/widgets/header_card.dart';
import '../../../common/widgets/refri_item_widget.dart';

class RefrigeratorCardMobile extends StatelessWidget {
  const RefrigeratorCardMobile({
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
                      MapCardMobile(model: model),
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
                          "lostConnection".tr + ": " + model.getSyncDateObs,
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

class MapCardMobile extends StatefulWidget {
  final Refrigerator model;

  const MapCardMobile({Key? key, required this.model}) : super(key: key);

  @override
  State<MapCardMobile> createState() => _MapCardMobileState();
}

class _MapCardMobileState extends State<MapCardMobile> {
  final mapController = MapController();
  final popupLayerController = PopupController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(widget.model.sensor.lat, widget.model.sensor.long),
          zoom: 16,
          maxZoom: 22,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          enableScrollWheel: false,
          onTap: (_, __) => popupLayerController.hideAllPopups(),
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://tile.thunderforest.com/atlas/{z}/{x}/{y}{r}.png?apikey={apiKey}",
            additionalOptions: const {
              "apiKey": "b0b5b66b87394a549252b29febaaa77c"
            },
            maxZoom: 22,
            userAgentPackageName: 'com.phuonghai',
          ),
          Obx(() {
            Future.delayed(const Duration(milliseconds: 10), () {
              if (widget.model.updateCamera == 1) {
                mapController.move(widget.model.markers.first.point, 16);
              } else if (widget.model.updateCamera == 2) {
                mapController.move(widget.model.markers.last.point, 16);
                widget.model.updateCamera = 0;
              }
            });

            return PopupMarkerLayerWidget(
              options: PopupMarkerLayerOptions(
                popupController: popupLayerController,
                markers: widget.model.markers.value,
                markerRotateAlignment:
                    PopupMarkerLayerOptions.rotationAlignmentFor(
                        AnchorAlign.top),
                popupBuilder: (BuildContext context, Marker marker) =>
                    MarkerPopup(marker: marker),
              ),
            );
          }),
        ],
        nonRotatedChildren: [
          Positioned(
            right: 8,
            bottom: 8,
            child: Material(
              elevation: 1,
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: 40,
                height: 40,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    mapController.move(
                      LatLng(widget.model.sensor.lat, widget.model.sensor.long),
                      16,
                    );
                  },
                  child: const Icon(
                    Icons.gps_fixed,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
