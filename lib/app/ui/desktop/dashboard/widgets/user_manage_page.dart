import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/user.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

class UserManagePage extends GetWidget<HomeController> {
  const UserManagePage({Key? key}) : super(key: key);

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
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text('createUser'.tr),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Dialog(child: CreateUserModal());
                      },
                    );
                  },
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
                    const DataColumn2(
                      label: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn2(
                      label: Text(
                        'status'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(
                        'more'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      size: ColumnSize.L,
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    controller.apiClient.users.length,
                    (index) =>
                        newMethod(context, controller.apiClient.users[index]),
                  ),
                ),
              ),
              // child: DataTable2(
              //   columnSpacing: 12,
              //   horizontalMargin: 12,
              //   minWidth: 500,
              //   showBottomBorder: true,
              //   border: TableBorder.all(color: Colors.black26),
              //   dividerThickness: 0,
              //   headingRowColor: MaterialStateProperty.all(Colors.amber),
              //   columns: [
              //     const DataColumn2(
              //       label: Text(
              //         'ID',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       size: ColumnSize.S,
              //     ),
              //     const DataColumn2(
              //       label: Text(
              //         'Email',
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //     DataColumn2(
              //       label: Text(
              //         'status'.tr,
              //         style: const TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       size: ColumnSize.S,
              //     ),
              //     DataColumn2(
              //       label: Text(
              //         'more'.tr,
              //         style: const TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       size: ColumnSize.L,
              //     ),
              //   ],
              //   rows: List<DataRow>.generate(
              //     controller.apiClient.users.length,
              //     (index) =>
              //         newMethod(context, controller.apiClient.users[index]),
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow newMethod(BuildContext context, UserModel user) {
    return DataRow(
      cells: [
        DataCell(Text(user.id.toString())),
        DataCell(Text(user.email)),
        DataCell(Text(
          user.isDeleted == 0 ? 'active'.tr : 'deleted'.tr,
          style: TextStyle(
            color: user.isDeleted == 0 ? Colors.green : Colors.red,
          ),
        )),
        DataCell(
          user.isDeleted == 0 &&
                  user.email != "dragonmountain.project@gmail.com"
              ? ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(child: AssignDevice(user: user));
                          },
                        );
                      },
                      icon: const Icon(Icons.assignment),
                      label: Text("assignment".tr),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final ret = await confirmDialog(
                          context,
                          'deleteAccount'.tr,
                          "${'areUSure'.tr}\n${"hintDeleteAccount".tr}",
                        );
                        if (ret) {
                          final r = await controller.apiClient
                              .deleteAccountByAdmin(user.id);
                          if (r) {
                            user.isDeleted = 1;
                            controller.apiClient.users.refresh();
                            Helper.showSuccess('done'.tr);
                          } else {
                            Helper.showError('error'.tr);
                          }
                        }
                      },
                      icon: const Icon(Icons.delete),
                      label: Text("deleteAccount".tr),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class CreateUserModal extends StatefulWidget {
  const CreateUserModal({Key? key}) : super(key: key);

  @override
  State<CreateUserModal> createState() => _CreateUserModalState();
}

class _CreateUserModalState extends State<CreateUserModal> {
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _rePassController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    _rePassController.dispose();
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
          HeaderModal(title: "createUser".tr),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              labelText: "email".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _passController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              labelText: "password".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          TextField(
            controller: _rePassController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              labelText: "repeatPassword".tr,
              border: const OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
          const SizedBox(width: 12),
          DefaultButton(
            text: 'confirm'.tr,
            press: () async {
              Helper.showLoading('loading'.tr);
              if (GetUtils.isEmail(_nameController.text)) {
                if (_passController.text.length >= 6) {
                  if (_passController.text == _rePassController.text) {
                    Helper.showLoading('loading'.tr);
                    final c = Get.find<HomeController>();
                    final r = await c.apiClient.createAccount(
                        _nameController.text, _passController.text);
                    if (r) {
                      Helper.showSuccess("signUpDone".tr);
                    } else {
                      Helper.showError("error".tr);
                    }
                  } else {
                    Helper.showError("pwdTooShort".tr);
                  }
                } else {
                  Helper.showError("pwdTooShort".tr);
                }
              } else {
                Helper.showError("isValidEmail".tr);
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class AssignDevice extends StatefulWidget {
  final UserModel user;
  const AssignDevice({Key? key, required this.user}) : super(key: key);

  @override
  State<AssignDevice> createState() => _AssignDeviceState();
}

class _AssignDeviceState extends State<AssignDevice> {
  final c = Get.find<HomeController>();
  final scroll = ScrollController();
  final List listDisplay = [];

  @override
  void initState() {
    listDisplay.assignAll(c.apiClient.devices);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      readDevicesByUser();
    });
  }

  void readDevicesByUser() async {
    await c.apiClient.getDeviceByIdUser(widget.user.id);
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.9,
      constraints: const BoxConstraints(maxWidth: 1000),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          HeaderModal(title: "assignment".tr),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Text(
                      //   "allDevices".tr,
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "searchHint".tr,
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            listDisplay.clear();
                            setState(() {
                              for (var element in c.apiClient.devices) {
                                if (element.friendlyName
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    element.key
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                  listDisplay.add(element);
                                }
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.black26),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: Scrollbar(
                              controller: scroll,
                              child: ListView.separated(
                                controller: scroll,
                                itemCount: listDisplay.length,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(listDisplay[index].friendlyName),
                                  subtitle: Text(listDisplay[index].key),
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.amber,
                                  ),
                                  onTap: () {
                                    if (c.apiClient.devicesByUser.indexWhere(
                                            (p0) =>
                                                p0.key ==
                                                listDisplay[index].key) ==
                                        -1) {
                                      c.apiClient.devicesByUser
                                          .add(listDisplay[index]);
                                    }
                                  },
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Thiết bị sở hữu: ${widget.user.email}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.black26),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: Obx(
                              () => ListView.separated(
                                itemCount: c.apiClient.devicesByUser.length,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                    c.apiClient.devicesByUser[index]
                                        .friendlyName,
                                  ),
                                  subtitle: Text(
                                    c.apiClient.devicesByUser[index].key,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      c.apiClient.devicesByUser.removeAt(index);
                                    },
                                    splashRadius: 24,
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DefaultButton(
            width: 200,
            text: 'confirm'.tr,
            press: () async {
              Helper.showLoading('loading'.tr);
              final r = await c.apiClient.assignDeviceToUser(widget.user.id);
              Helper.dismiss();
              if (r) {
                Helper.showSuccess('done'.tr);
              } else {
                Helper.showError('error'.tr);
              }
            },
          ),
        ],
      ),
    );
  }
}
