import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final c = Get.find<HomeController>();
  late List<dynamic> listDisplay;

  @override
  void initState() {
    super.initState();
    listDisplay = List.from(c.allDevicesOfUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 10),
          margin: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: "searchHint".tr,
              icon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.all(8),
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
        ),
      ),
      body: ListView.separated(
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
            Helper.hideKeyboard(context);
            c.addDetailDevice(listDisplay[index]);
            // Get.toNamed(Routes.DEVICE);
          },
        ),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: listDisplay.length,
      ),
    );
  }
}
