import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({Key? key}) : super(key: key);

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final c = Get.find<HomeController>();
  late List<dynamic> listDisplay;

  @override
  void initState() {
    listDisplay = List.from(c.allDevicesOfUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        children: [
          HeaderModal(title: "search".tr),
          const SizedBox(height: 10),
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              helperText: "searchHint".tr,
            ),
            onChanged: (value) {
              listDisplay.clear();
              setState(() {
                for (var element in c.allDevicesOfUser) {
                  if (element.friendlyName
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                      element.key.toLowerCase().contains(value.toLowerCase())) {
                    listDisplay.add(element);
                  }
                }
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, index) => ListTile(
                leading: SizedBox(
                  height: double.infinity,
                  child: Icon(
                    Icons.blur_circular_outlined,
                    color: listDisplay[index].type == 'Air Node'
                        ? Colors.green
                        : Colors.blue,
                  ),
                ),
                title: Text(listDisplay[index].friendlyName),
                subtitle: Text("#${listDisplay[index].key}"),
                onTap: () {
                  Navigator.of(context).pop();
                  c.addDetailDevice(listDisplay[index]);
                  // if (!GetPlatform.isWeb) {
                  //   Get.toNamed(Routes.DEVICE);
                  // }
                },
              ),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: listDisplay.length,
            ),
          )
        ],
      ),
    );
  }
}
