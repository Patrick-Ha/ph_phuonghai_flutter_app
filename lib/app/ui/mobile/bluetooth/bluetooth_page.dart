import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/ble_controller.dart';
import 'package:phuonghai/app/data/models/ble.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/mobile/bluetooth/ble_device.dart';

class BluetoothPage extends GetWidget<BleController> {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth"),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            Obx(
              () {
                return controller.isBleOn.value
                    ? ListTile(
                        title: Text(
                          "bleEnabled".tr,
                          style: const TextStyle(color: Colors.green),
                        ),
                        trailing: OutlinedButton(
                          child: Text("scanBle".tr),
                          onPressed: () async {
                            await controller.scanBle();
                          },
                        ),
                      )
                    : ListTile(
                        title: Text(
                          "bleDisabled".tr,
                          style: const TextStyle(color: Colors.red),
                        ),
                        trailing: OutlinedButton(
                          child: Text("turnOnBle".tr),
                          onPressed: () async {
                            await controller.checkBleState();
                          },
                        ),
                      );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemBuilder: (_, index) =>
                      BleItem(ble: controller.bleDevices[index]),
                  itemCount: controller.bleDevices.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BleItem extends StatelessWidget {
  const BleItem({Key? key, required this.ble}) : super(key: key);

  final BleDevice ble;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  const Icon(
                    EvaIcons.bluetooth,
                    color: Colors.blue,
                  ),
                  Text(
                    "${ble.rssi} dBm",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ble.device.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(ble.device.id.toString()),
                      ],
                    ),
                    const Spacer(),
                    DefaultButton(
                      width: 100,
                      text: "connect".tr,
                      press: () async {
                        final c = Get.find<BleController>();
                        final state = await c.connect(ble);
                        if (state) {
                          Get.to(() => BleDevicePage(d: ble));
                        } else {
                          Helper.showError("error".tr);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black26),
        ],
      ),
    );
  }
}
