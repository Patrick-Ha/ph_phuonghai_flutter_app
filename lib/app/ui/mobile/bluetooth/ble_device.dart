import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/ble.dart';
import 'package:phuonghai/app/helper/helper.dart';

class BleDevicePage extends StatelessWidget {
  const BleDevicePage({Key? key, required this.d}) : super(key: key);
  final BleDevice d;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(d.device.name),
        actions: [
          IconButton(
            onPressed: () async {
              await d.device.disconnect();
            },
            splashRadius: 24,
            icon: const Icon(Icons.bluetooth_disabled),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        children: [
          for (var ser in d.services!) InfoServiceWidget(service: ser),
        ],
      ),
    );
  }
}

class InfoServiceWidget extends StatelessWidget {
  const InfoServiceWidget({Key? key, required this.service}) : super(key: key);
  final BluetoothService service;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      title: Text(
        service.uuid.toString().toUpperCase(),
        // service.uuid.toString().toUpperCase().substring(4, 8).tr,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "UUID: " + service.uuid.toString().toUpperCase(),
        // "UUID: 0x" + service.uuid.toString().toUpperCase().substring(4, 8),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 5),
      childrenPadding: const EdgeInsets.only(left: 20),
      children: [
        for (var ch in service.characteristics) TitleChatacter(ch: ch)
      ],
    );
  }
}

class TitleChatacter extends StatefulWidget {
  const TitleChatacter({Key? key, required this.ch}) : super(key: key);
  final BluetoothCharacteristic ch;

  @override
  State<TitleChatacter> createState() => _TitleChatacterState();
}

class _TitleChatacterState extends State<TitleChatacter> {
  String _value = "Not available";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 1.2,
              children: [
                Text(
                  widget.ch.uuid.toString().toUpperCase().substring(4, 8).tr,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "UUID: " + widget.ch.uuid.toString().toUpperCase(),
                  // "UUID: 0x" +
                  //     widget.ch.uuid.toString().toUpperCase().substring(4, 8),
                ),
                RichText(
                  text: TextSpan(
                    text: "Value: ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: _value,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            splashRadius: 24,
            icon: const Icon(
              EvaIcons.download,
              color: Colors.black54,
            ),
            onPressed: () async {
              try {
                final value = await widget.ch.read();

                if (value.length > 1) {
                  if (RegExp(r"^[a-zA-Z0-9]")
                      .hasMatch(String.fromCharCodes(value))) {
                    setState(() {
                      _value = String.fromCharCodes(value);
                    });
                  } else {
                    setState(() {
                      _value = "";
                      for (var i in value) {
                        _value +=
                            "0x" + i.toRadixString(16).padLeft(2, '0') + ", ";
                      }
                    });
                  }
                } else {
                  _value = value[0].toString();
                }
              } catch (e) {
                Helper.showError("error".tr);
              }
            },
          ),
        ],
      ),
    );
  }
}
