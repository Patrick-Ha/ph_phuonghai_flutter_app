import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phuonghai/providers/device_http.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/ui/widgets/status_widget.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

class ScanQrcodePage extends StatefulWidget {
  const ScanQrcodePage({Key? key}) : super(key: key);

  @override
  State<ScanQrcodePage> createState() => _ScanQrcodePageState();
}

class _ScanQrcodePageState extends State<ScanQrcodePage> {
  final MobileScannerController cameraController = MobileScannerController();

  bool _error = false;
  String _errorText = '';

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR code')),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: MobileScanner(
              allowDuplicates: false,
              controller: cameraController,
              onDetect: (barcode, args) {
                if (barcode.rawValue == null) {
                  setState(() {
                    _error = true;
                    _errorText = "Mã QR không đúng. Hãy thử lại!";
                  });
                  debugPrint('Failed to scan Barcode');
                } else {
                  final String code = barcode.rawValue!;
                  if (code.contains('PhuongHai')) {
                    _error = false;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddDevicePage(
                                listInfo: code.split(';'),
                              )),
                    );
                  } else {
                    setState(() {
                      _error = true;
                      _errorText = "Mã QR không đúng. Hãy thử lại!";
                    });
                  }

                  debugPrint('Barcode found! $code');
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: ValueListenableBuilder(
                  valueListenable: cameraController.cameraFacingState,
                  builder: (context, state, child) {
                    switch (state as CameraFacing) {
                      case CameraFacing.front:
                        return const Icon(Icons.camera_front);
                      case CameraFacing.back:
                        return const Icon(Icons.camera_rear);
                    }
                  },
                ),
                label: const Text('Camera'),
                onPressed: () => cameraController.switchCamera(),
              ),
              ElevatedButton.icon(
                icon: ValueListenableBuilder(
                  valueListenable: cameraController.torchState,
                  builder: (context, state, child) {
                    switch (state as TorchState) {
                      case TorchState.off:
                        return const Icon(Icons.flash_off);
                      case TorchState.on:
                        return const Icon(Icons.flash_on);
                    }
                  },
                ),
                label: const Text('Flash'),
                onPressed: () => cameraController.toggleTorch(),
              ),
            ],
          ),
          StatusWidget(error: _error, text: _errorText),
        ],
      ),
    );
  }
}

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key, required this.listInfo}) : super(key: key);
  final List<String> listInfo;

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final nameController = TextEditingController();
  final desController = TextEditingController();
  bool _error = false;
  String _errorText = '';

  @override
  void dispose() {
    nameController.dispose();
    desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(locale.translate('addDevice'))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            ListTile(
              title: Text(locale.translate('txtModelDevice')),
              trailing: Text(
                widget.listInfo[1],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(locale.translate('txtSerialNumber')),
              trailing: Text(
                widget.listInfo[2],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: locale.translate('txtFriendlyName'),
                hintText: locale.translate('txtTapToEnter'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: desController,
              decoration: InputDecoration(
                labelText: locale.translate('txtDescription'),
                hintText: locale.translate('txtTapToEnter'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const Spacer(),
            StatusWidget(error: _error, text: _errorText),
            const SizedBox(height: 30),
            DefaultButton(
              text: locale.translate('addDevice'),
              press: () async {
                if (nameController.text.isEmpty || desController.text.isEmpty) {
                  _error = true;
                  _errorText = locale.translate('txtNotFullAddDevice');
                } else {
                  final device =
                      Provider.of<DeviceHttp>(context, listen: false);
                  final state = await device.addDevice(
                    model: widget.listInfo[1],
                    seri: widget.listInfo[2],
                    name: nameController.text,
                    des: desController.text,
                  );
                  if (state) {
                    _error = false;
                    _errorText = locale.translate('txtAddDeviceDone');
                  } else {
                    _error = true;
                    _errorText = locale.translate('txtErrAddDevice');
                  }
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
