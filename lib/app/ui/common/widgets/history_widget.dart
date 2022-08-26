import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fast_csv/fast_csv.dart' as _fast_csv;
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

import 'chart.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({Key? key, required this.sensors}) : super(key: key);

  final List<dynamic> sensors;

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  GroupButtonController groupButtonController = GroupButtonController();
  String setDate = DateTime.now().toString().substring(0, 10);
  bool isBusy = true;
  String avg = "n/a", min = "n/a", max = "n/a";
  final List<String> dateList = [];
  final List<double> valueList = [];
  final Dio dio = Dio();
  final baseUrl = "https://thegreenlab.xyz/Datums";

  getDataByDate() async {
    try {
      final response = await dio.get(
        baseUrl +
            '/DataByDate?DeviceSerialNumber=${widget.sensors[0].key}&StartDate=$setDate&EndDate=$setDate',
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
        baseUrl +
            '/StatisticDataBySensor?DeviceSerialNumber=${widget.sensors[0].key}&StartDate=$setDate&EndDate=$setDate',
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
    dio.close(force: true);
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Row(
            children: [
              if (GetPlatform.isWeb)
                OutlinedButton.icon(
                  icon: const Icon(EvaIcons.download),
                  label: Text('download'.tr),
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      constraints: const BoxConstraints(maxWidth: 420),
                      builder: (context) {
                        return const DownloadModal();
                      },
                    );
                  },
                ),
              const Spacer(),
              OutlinedButton.icon(
                icon: const Icon(EvaIcons.calendar),
                label: Text(setDate),
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
                      ),
              ),
        const SizedBox(height: 10),
        ListTile(
          title: Text("avgOfDay".tr),
          leading: const Icon(Icons.trending_flat),
          trailing: Text(
            avg,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 2),
        ListTile(
          title: Text("lowestOfDay".tr),
          leading: const Icon(Icons.trending_down),
          trailing: Text(
            min,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 2),
        ListTile(
          title: Text("highestOfDay".tr),
          leading: const Icon(Icons.trending_up),
          trailing: Text(
            max,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
              runSpacing: 5,
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
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}

class DownloadModal extends StatefulWidget {
  const DownloadModal({Key? key}) : super(key: key);

  @override
  State<DownloadModal> createState() => _DownloadModalState();
}

class _DownloadModalState extends State<DownloadModal> {
  DateTime? start;
  DateTime? end;

  /// method to check wether a day is in the selected range
  /// used for highlighting those day
  bool isInRange(DateTime date) {
    // if start is null, no date has been selected yet
    if (start == null) return false;
    // if only end is null only the start should be highlighted
    if (end == null) return date == start;
    // if both start and end aren't null check if date false in the range
    return ((date == start || date.isAfter(start!)) &&
        (date == end || date.isBefore(end!)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        children: [
          HeaderModal(title: "download".tr),
          Expanded(
            child: PagedVerticalCalendar(
              addAutomaticKeepAlives: true,
              minDate: DateTime.now().subtract(const Duration(days: 365)),
              maxDate: DateTime.now(),
              startWeekWithSunday: true,
              dayBuilder: (context, date) {
                // update the days color based on if it's selected or not
                final color =
                    isInRange(date) ? Colors.greenAccent : Colors.transparent;
                return Container(
                  color: color,
                  child: Center(
                    child: Text(DateFormat('d').format(date)),
                  ),
                );
              },
              monthBuilder: (context, month, year) {
                return Column(
                  children: [
                    /// create a customized header displaying the month and year
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      margin: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Text(
                        DateFormat('MMMM yyyy').format(DateTime(year, month)),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    /// add a row showing the weekdays
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          weekText('Mo'),
                          weekText('Tu'),
                          weekText('We'),
                          weekText('Th'),
                          weekText('Fr'),
                          weekText('Sa'),
                          weekText('Su'),
                        ],
                      ),
                    ),
                  ],
                );
              },
              onDayPressed: (date) async {
                setState(() {
                  // if start is null, assign this date to start
                  if (start == null) {
                    start = date;
                  } else if (end == null) {
                    end = date;
                  } else {
                    start = null;
                    end = null;
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          DefaultButton(
            text: "down".tr,
            press: () async {
              if (start != null && end != null) {
                Helper.showLoading("loading".tr);
                final c = Get.find<HomeController>();
                final s = DateFormat('yyyy-MM-dd').format(start!);
                final e = DateFormat('yyyy-MM-dd').format(end!);
                await c.apiClient.downloadData(c.detailDevice[0].key, s, e);
                EasyLoading.dismiss();
              } else {
                Helper.showError("downloadWrongDate".tr);
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget weekText(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      ),
    );
  }
}
