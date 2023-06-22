import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';

import 'device_info.dart';


import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_vlc_player/src/vlc_player_controller.dart';


class SmartpHDevicePage extends StatefulWidget {
  const SmartpHDevicePage({Key? key, required this.model}) : super(key: key);
  final DeviceModel model;

  @override
  State<SmartpHDevicePage> createState() => _SmartpHDevicePageState();
}

class _SmartpHDevicePageState extends State<SmartpHDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.friendlyName)),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Obx(
                () => DividerWithText(
                  text: "${"lastUpdated".tr}: ${widget.model.getSyncDateObs}",
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 20,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    if (widget.model.sensors[i].name == ' FTP') {
                      return FTPConnection(sensor: widget.model.sensors[i]);
                    }
                    return SmartpHSensor(
                      sensor: widget.model.sensors[i],
                      isSetting: true,
                    );
                  },
                  itemCount: widget.model.sensors.length,
                ),
              ),
              DividerWithText(text: "Camera"),
              //DividerWithText(text: widget.model.camUrl1),

              //ExampleVideo(camUrl1: "rtsp://admin:1234abcd@14.241.170.107:554/Streaming/Channels/101"),
              ExampleVideo(camUrl1: widget.model.camUrl1),

              DividerWithText(text: 'dataHistory'.tr),
              NewWidget(widget: widget),
              const SizedBox(height: 10),
              DeviceInfo(model: widget.model),
            ],
          ),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final SmartpHDevicePage widget;

  @override
  Widget build(BuildContext context) {
    final l = widget.model.sensors.skipWhile((value) => value.name == ' FTP');
    return HistoryWidget(sensors: l.toList());
  }
}


class ExampleVideo extends StatefulWidget {
  const ExampleVideo({Key? key, required this.camUrl1}) : super(key: key);
  final String camUrl1;

  @override
  _ExampleVideoState createState() => _ExampleVideoState(camUrl1);
}

class _ExampleVideoState extends State<ExampleVideo> {

   String _camUrl1 = "";

  _ExampleVideoState(String camUrl1) {
    this._camUrl1 = camUrl1;
  }

  //  VlcPlayerController _vlcViewController = new VlcPlayerController.network(
  //  "",
  //   autoPlay: true,
  // );

  @override
  Widget build(BuildContext context) {
   
    return Column(
     
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new VlcPlayer(
              controller: new VlcPlayerController.network(
                this._camUrl1,
                autoPlay: true,
              ),
              aspectRatio: 16 / 9,
              placeholder: Text("Somehow, the camera source does not work"),
            ),
          ],
      );
  }
}


// //cameraa 
// String url =  'rtsp://admin:1234abcd@14.241.170.107:554/Streaming/Channels/101';

// class ExampleVideo extends StatefulWidget {
//   @override
//   _ExampleVideoState createState() => _ExampleVideoState();

// }

// class _ExampleVideoState extends State<ExampleVideo> {
//    VlcPlayerController _vlcViewController = new VlcPlayerController.network(
//     "rtsp://admin:1234abcd@14.241.170.107:554/Streaming/Channels/101",
//     autoPlay: true,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Column(
     
//            mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             new VlcPlayer(
//               controller: _vlcViewController,
//               aspectRatio: 16 / 9,
//               placeholder: Text("Hello World"),
//             ),
//           ],
//       );
//   }
// }