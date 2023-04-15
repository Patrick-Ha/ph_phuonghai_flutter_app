import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

class DeviceManagePage extends GetWidget<HomeController> {
  const DeviceManagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 56,
            color: Colors.green,
            padding: const EdgeInsets.all(8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Image.asset('assets/images/avatar.png'),
                  ),
                  label: Obx(() => Text(controller.user.value.email)),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add_circle),
                  label: Text('createDevice'.tr),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Dialog(child: CreateDeviceModal());
                      },
                    );
                  },
                ),
                const SizedBox(width: 8),
                Container(
                  width: 300,
                  margin: const EdgeInsets.all(3),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      isCollapsed: true,
                      hintText: 'search'.tr,
                      contentPadding: const EdgeInsets.only(top: 7),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.apiClient.devicesDisplay.clear();
                      for (var element in controller.apiClient.devices) {
                        if (element.friendlyName
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            element.key
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          controller.apiClient.devicesDisplay.add(element);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Indicator(
                  color: Colors.amber,
                  text: "Totals",
                  number: controller.apiClient.devices.length,
                ),
                const SizedBox(width: 30),
                Indicator(
                  color: Colors.green,
                  text: "Greenlab Hood",
                  number: controller.apiClient.greenlabCnt,
                ),
                const SizedBox(width: 30),
                Indicator(
                  color: Colors.blue,
                  text: "SmartpH",
                  number: controller.apiClient.smartphCnt,
                ),
                const SizedBox(width: 30),
                Indicator(
                  color: Colors.blueGrey,
                  text: "Others",
                  number: controller.apiClient.othersCnt,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 500,
                  showBottomBorder: true,
                  border: TableBorder.all(color: Colors.black26),
                  dividerThickness: 0,
                  headingRowColor: MaterialStateProperty.all(Colors.amber),
                  columns: [
                    const DataColumn2(
                      label: Text(
                        'ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(
                        'friendlyName'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn2(
                      label: Text(
                        'type'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      size: ColumnSize.S,
                    ),
                    const DataColumn2(
                      label: Text(
                        'Model',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(
                        'serialNumber'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(
                        'dateCreate'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      size: ColumnSize.S,
                    ),
                    DataColumn(
                      label: Text(
                        'description'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'more'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    controller.apiClient.devicesDisplay.length,
                    (index) => deviceRow(
                      context,
                      controller.apiClient.devicesDisplay[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow deviceRow(BuildContext context, DeviceModel device) {
    return DataRow(
      cells: [
        DataCell(Text(device.id.toString())),
        DataCell(Text(device.friendlyName)),
        DataCell(Text(device.type)),
        DataCell(Text(device.model)),
        DataCell(Text(device.key)),
        DataCell(
            Text(DateFormat('dd-MM-yyyy').format(device.dateSyncObs.value))),
        DataCell(Text(device.description)),
        DataCell(
          ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                          child: EditDeviceModal(
                        device: device,
                        admin: true,
                      ));
                    },
                  );
                },
                icon: const Icon(Icons.edit),
                label: Text("editInfo".tr),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () async {
                  // await controller.apiClient.deleteDevice(device.id);
                },
                splashRadius: 24,
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CreateDeviceModal extends StatefulWidget {
  const CreateDeviceModal({Key? key}) : super(key: key);

  @override
  State<CreateDeviceModal> createState() => _CreateDeviceModalState();
}

class _CreateDeviceModalState extends State<CreateDeviceModal> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _modelController = TextEditingController();
  final _seriController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    ),
  );
  final _despController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _modelController.dispose();
    _seriController.dispose();
    _dateController.dispose();
    _despController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        runSpacing: 15,
        children: [
          HeaderModal(title: "createDevice".tr),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "friendlyName".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _typeController,
            decoration: InputDecoration(
              labelText: "type".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _modelController,
            decoration: InputDecoration(
              labelText: "model".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _seriController,
            decoration: InputDecoration(
              labelText: "serialNumber".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            readOnly: true,
            controller: _dateController,
            decoration: InputDecoration(
              labelText: "dateCreate".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _despController,
            decoration: InputDecoration(
              labelText: "description".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          const SizedBox(width: 12),
          DefaultButton(
            text: 'confirm'.tr,
            press: () async {
              if (_nameController.text.isEmpty ||
                  _typeController.text.isEmpty ||
                  _modelController.text.isEmpty ||
                  _seriController.text.isEmpty ||
                  _dateController.text.isEmpty ||
                  _despController.text.isEmpty) {
                Helper.showError('emptyTextField'.tr);
              } else {
                Helper.showLoading('loading'.tr);
                final c = Get.find<HomeController>();
                final ret = await c.apiClient.createDevice(
                  _nameController.text,
                  _typeController.text,
                  _modelController.text,
                  _seriController.text,
                  DateTime.now().toUtc().toIso8601String(),
                  _despController.text,
                );
                if (ret) {
                  Helper.showSuccess('done'.tr);
                } else {
                  Helper.showError('createDeviceErr'.tr);
                }
                Helper.dismiss();
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class EditDeviceModal extends StatefulWidget {
  final dynamic device;
  final bool admin;
  const EditDeviceModal({Key? key, required this.device, required this.admin})
      : super(key: key);

  @override
  State<EditDeviceModal> createState() => _EditDeviceModalState();
}

class _EditDeviceModalState extends State<EditDeviceModal> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _modelController = TextEditingController();
  final _seriController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  final _despController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.device.friendlyName;
      _typeController.text = widget.device.type;
      _modelController.text = widget.device.model;
      _seriController.text = widget.device.key;
      _despController.text = widget.device.description;
      _dateController.text = DateFormat('dd-MM-yyyy').format(
        widget.device.dateSyncObs.value,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _modelController.dispose();
    _seriController.dispose();
    _dateController.dispose();
    _despController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        runSpacing: 15,
        children: [
          HeaderModal(title: "editInfo".tr),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "friendlyName".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _typeController,
            readOnly: !widget.admin,
            decoration: InputDecoration(
              labelText: "type".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _modelController,
            readOnly: !widget.admin,
            decoration: InputDecoration(
              labelText: "model".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _seriController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "serialNumber".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            readOnly: true,
            controller: _dateController,
            decoration: InputDecoration(
              labelText: "dateCreate".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _despController,
            decoration: InputDecoration(
              labelText: "description".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          const SizedBox(width: 12),
          DefaultButton(
            text: 'confirm'.tr,
            press: () async {
              if (_nameController.text.isEmpty ||
                  _typeController.text.isEmpty ||
                  _modelController.text.isEmpty ||
                  _seriController.text.isEmpty ||
                  _dateController.text.isEmpty ||
                  _despController.text.isEmpty) {
                Helper.showError('emptyTextField'.tr);
              } else {
                Helper.showLoading('loading'.tr);
                final c = Get.find<HomeController>();
                final ret = await c.apiClient.editDevice(
                  widget.device.id,
                  _nameController.text,
                  _modelController.text,
                  _typeController.text,
                  _despController.text,
                );
                if (ret) {
                  Helper.showSuccess('reloadForUpdate'.tr);
                } else {
                  Helper.showError('error'.tr);
                }
                Helper.dismiss();
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final int number;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.white,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
