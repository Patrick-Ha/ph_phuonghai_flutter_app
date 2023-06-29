import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/common/widgets/textfield_dialog.dart';

import '../../../helper/helper.dart';
import 'device_info.dart';

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
              const DividerWithText(text: 'Camera'),
              CameraWidget(
                model: widget.model,
                idCam: 1,
              ),
              CameraWidget(
                model: widget.model,
                idCam: 2,
              ),
              CameraWidget(
                model: widget.model,
                idCam: 3,
              ),
              const SizedBox(height: 10),
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

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    Key? key,
    required this.model,
    required this.idCam,
  }) : super(key: key);

  final DeviceModel model;
  final int idCam;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  VlcPlayerController? vlcController;
  bool isError = false;
  String url = "";

  void initVlcController() {
    if (url.startsWith('rtsp')) {
      Helper.showLoading("loading".tr);
      Future.delayed(const Duration(seconds: 4), () {
        Helper.dismiss();
      });
      vlcController = VlcPlayerController.network(url);

      vlcController?.addListener(() {
        if (vlcController!.value.hasError) {
          setState(() {
            isError = true;
          });
        }
      });
    }
  }

  @override
  void initState() {
    if (widget.idCam == 1) {
      url = widget.model.camUrl1;
    } else if (widget.idCam == 2) {
      url = widget.model.camUrl2;
    } else {
      url = widget.model.camUrl3;
    }
    initVlcController();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await vlcController?.dispose();
  }

  void addCamera() async {
    if (url.isNotEmpty) {
      Get.snackbar(
        "error".tr,
        "createDeviceErr".tr,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      final urlEdit = await textFieldDialog(context, "RTSP Url", false);
      if (urlEdit.startsWith('rtsp')) {
        Helper.showLoading('loading'.tr);
        final c = Get.find<HomeController>();
        final ret = await c.apiClient
            .editCamUrl(widget.model.id, widget.idCam, urlEdit);
        Helper.dismiss();
        if (ret) {
          url = urlEdit;

          if (widget.idCam == 1) {
            widget.model.camUrl1 = url;
          } else if (widget.idCam == 2) {
            widget.model.camUrl2 = url;
          } else {
            widget.model.camUrl3 = url;
          }
          initVlcController();
          setState(() {});
          Helper.showSuccess('done'.tr);
        } else {
          Helper.showError('error'.tr);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        url.isEmpty
            ? const SizedBox.shrink()
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      final delete = await confirmDialog(
                          context, "deleteCamera".tr, "areUSure".tr);
                      if (delete) {
                        Helper.showLoading('loading'.tr);
                        final c = Get.find<HomeController>();
                        final ret = await c.apiClient
                            .editCamUrl(widget.model.id, widget.idCam, "");
                        Helper.dismiss();
                        if (ret) {
                          setState(() {
                            url = "";
                            isError = false;
                            if (widget.idCam == 1) {
                              widget.model.camUrl1 = url;
                            } else if (widget.idCam == 2) {
                              widget.model.camUrl2 = url;
                            } else {
                              widget.model.camUrl3 = url;
                            }
                          });
                          Helper.showSuccess('done'.tr);
                          await vlcController?.dispose();
                        } else {
                          Helper.showError('error'.tr);
                        }
                      }
                    },
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.orange,
                    ),
                  ),
                  isError
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                "cantConnect".tr,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : VlcPlayer(
                          controller: vlcController!,
                          aspectRatio: 16 / 9,
                          placeholder:
                              const Center(child: CircularProgressIndicator()),
                        ),
                ],
              ),
        TextButton.icon(
          onPressed: addCamera,
          icon: const Icon(Icons.add_circle),
          label: Text("RTSP Camera ${widget.idCam}"),
        ),
        const Divider(
          indent: 40,
          endIndent: 40,
          color: Colors.black26,
        ),
      ],
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
