import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/ui/smartph/widgets/chart.dart';
import 'package:fast_csv/fast_csv.dart' as _fast_csv;
import 'package:phuonghai/utils/locale/app_localization.dart';

class HistoricalDataWidget extends StatefulWidget {
  const HistoricalDataWidget({Key? key, required this.sensors})
      : super(key: key);

  final List<dynamic> sensors;

  @override
  State<HistoricalDataWidget> createState() => _HistoricalDataWidgetState();
}

class _HistoricalDataWidgetState extends State<HistoricalDataWidget> {
  GroupButtonController groupButtonController = GroupButtonController();
  String setDate = DateTime.now().toString().substring(0, 10);
  bool isBusy = true;
  String avg = "n/a", min = "n/a", max = "n/a";
  final List<String> dateList = [];
  final List<double> valueList = [];

  getDataByDate() async {
    final Dio dio = Dio();

    try {
      final response = await dio.get(
        'https://thegreenlab.xyz/Datums/DataByDate?DeviceSerialNumber=${widget.sensors[0].key}&StartDate=$setDate&EndDate=$setDate',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e", // set content-length
          },
        ),
      );

      final result = _fast_csv.parse(response.data);
      result.removeAt(0);
      dateList.clear();
      valueList.clear();
      if (result.length > 1) {
        for (var item in result) {
          if (item[2] ==
              widget.sensors[groupButtonController.selectedIndex!].name) {
            dateList.add(item[0]);
            valueList.add(double.parse(item[3]));
          }
        }
      }

      final resp = await dio.get(
        'https://thegreenlab.xyz/Datums/StatisticDataBySensor?DeviceSerialNumber=${widget.sensors[0].key}&StartDate=$setDate&EndDate=$setDate',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e", // set content-length
          },
        ),
      );

      if (resp.data.isEmpty) {
        avg = min = max = 'n/a';
      } else {
        resp.data.forEach((key, value) {
          if (key ==
              widget.sensors[groupButtonController.selectedIndex!].name) {
            avg = value['Avg'].toStringAsFixed(2);
            min = value['Min'].toString();
            max = value['Max'].toString();
          }
        });
      }
    } on DioError catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        isBusy = false;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupButtonController.selectIndex(0);
      getDataByDate();
    });

    super.initState();
  }

  @override
  void dispose() {
    groupButtonController.dispose();
    super.dispose();
  }

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setDate = picked.toString().substring(0, 10);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () async {
                  final isLoad = await _selectDate();
                  if (isLoad) {
                    setState(() {
                      isBusy = true;
                      avg = min = max = 'n/a';
                    });
                    getDataByDate();
                  }
                },
                icon: const Icon(Icons.today_outlined),
                label: Text(setDate),
              ),
            ],
          ),
        ),
        isBusy
            ? SizedBox(
                height: 250,
                child: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.green,
                    size: 50,
                    secondRingColor: Colors.purple,
                  ),
                ),
              )
            : SizedBox(
                height: 250,
                child: valueList.length < 10
                    ? const Center(child: Text("N/A"))
                    : LineChartWidget(
                        dateList: dateList,
                        valueList: valueList,
                      )),
        const SizedBox(height: 10),
        ListTile(
          title: Text(locale.translate("txtAvgOfDay")),
          leading: const Icon(Icons.trending_flat),
          trailing: Text(avg,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
        const Divider(height: 2),
        ListTile(
          title: Text(locale.translate("txtLowestOfDay")),
          leading: const Icon(Icons.trending_down),
          trailing: Text(min,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
        const Divider(height: 2),
        ListTile(
          title: Text(locale.translate("txtHighestOfDay")),
          leading: const Icon(Icons.trending_up),
          trailing: Text(max,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GroupButton(
            controller: groupButtonController,
            isRadio: true,
            onSelected: (str, index, isSelected) {
              setState(() {
                isBusy = true;
                avg = min = max = 'n/a';
              });
              getDataByDate();
            },
            buttons: widget.sensors.map((s) => s.name).toList(),
            options: GroupButtonOptions(
              buttonWidth: 80,
              textPadding: const EdgeInsets.all(8),
              unselectedBorderColor: Colors.grey,
              unselectedColor: Colors.transparent,
              selectedBorderColor: Colors.transparent,
              unselectedShadow: [],
              selectedShadow: [],
              selectedTextStyle: const TextStyle(fontWeight: FontWeight.normal),
              unselectedTextStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

// Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 5),
//             child: Row(
//               children: [
//                 const Spacer(),
//                 OutlinedButton.icon(
//                   onPressed: () async {
//                     await _selectDate();
//                   },
//                   icon: const Icon(Icons.today_outlined),
//                   label: Text(setDate),
//                 ),
//               ],
//             ),
//           ),
//           const LineChartWidget(),
//           const SizedBox(height: 10),
//           SensorStatis(avg: '54', min: '40', max: '60'),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(color: Colors.grey[200]),
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//             child: GroupButton(
//               controller: groupButtonController,
//               isRadio: true,
//               onSelected: (str, index, isSelected) =>
//                   print('$index: $str button is selected'),
//               buttons: widget.sensors.map((s) => s.name).toList(),
//               options: GroupButtonOptions(
//                 buttonWidth: 80,
//                 unselectedBorderColor: Colors.grey,
//                 unselectedColor: Colors.transparent,
//                 selectedBorderColor: Colors.transparent,
//                 unselectedShadow: [],
//                 selectedShadow: [],
//                 selectedTextStyle:
//                     const TextStyle(fontWeight: FontWeight.normal),
//                 unselectedTextStyle: const TextStyle(
//                   fontWeight: FontWeight.normal,
//                   color: Colors.black,
//                 ),
//                 runSpacing: 0,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
