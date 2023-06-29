import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

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

  getDataByDate() async {
    if (widget.sensors.isEmpty) return;
    try {
      final response = await dio.get(
        'http://thegreenlab.xyz:3000/Datums/DataByDateJson?DeviceSerialNumber=${widget.sensors[0].key}&StartDate=$setDate&EndDate=$setDate',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );

      dateList.clear();
      valueList.clear();
      if (response.data.length > 1) {
        for (var item in response.data) {
          if (item['SensorType'] ==
              widget.sensors[groupButtonController.selectedIndex!].name) {
            dateList.add(item['Date']);
            valueList.add(item['Value'].toDouble());
          }
        }
      }

      final resp = await dio.get(
        'http://thegreenlab.xyz:3000/Datums/StatisticDataBySensor?DeviceSerialNumber=${widget.sensors[0].key}&StartDate=$setDate&EndDate=$setDate',
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
    } on DioException catch (e) {
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupButtonController.selectIndex(0);
      getDataByDate();
    });
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
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: Get.locale,
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
        if (GetPlatform.isWeb)
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Text("selectDateToDown".tr),
                const Spacer(),
                OutlinedButton.icon(
                  icon: const Icon(Icons.download),
                  label: Text('download'.tr),
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      constraints: const BoxConstraints(maxWidth: 420),
                      builder: (context) {
                        return DownloadModal(
                          sn: widget.sensors[0].key,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Row(
                  children: [
                    Text("chartByDate".tr),
                    const Spacer(),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.date_range),
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
                        child: LoadingAnimationWidget.hexagonDots(
                          color: Colors.green,
                          size: 50,
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
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 2),
              ListTile(
                title: Text("lowestOfDay".tr),
                leading: const Icon(Icons.trending_down),
                trailing: Text(
                  min,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 2),
              ListTile(
                title: Text("highestOfDay".tr),
                leading: const Icon(Icons.trending_up),
                trailing: Text(
                  max,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  buttons:
                      widget.sensors.map((s) => s.name.toString().tr).toList(),
                  options: GroupButtonOptions(
                    runSpacing: 5,
                    textPadding: const EdgeInsets.all(8),
                    unselectedBorderColor: Colors.grey,
                    unselectedColor: Colors.transparent,
                    selectedBorderColor: Colors.transparent,
                    unselectedShadow: [],
                    selectedShadow: [],
                    selectedTextStyle:
                        const TextStyle(fontWeight: FontWeight.normal),
                    unselectedTextStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DownloadModal extends StatefulWidget {
  final String sn;
  const DownloadModal({Key? key, required this.sn}) : super(key: key);

  @override
  State<DownloadModal> createState() => _DownloadModalState();
}

class _DownloadModalState extends State<DownloadModal> {
  DateTime? start, end;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          HeaderModal(title: 'download'.tr),
          Expanded(
            child: ScrollableCleanCalendar(
              calendarController: CleanCalendarController(
                maxDate: DateTime.now(),
                minDate: DateTime(2020),
                onRangeSelected: (firstDate, secondDate) {
                  start = firstDate;
                  end = secondDate;
                },
                initialFocusDate: DateTime.now(),
              ),
              layout: Layout.BEAUTY,
              calendarCrossAxisSpacing: 0,
              locale: Get.locale!.languageCode,
            ),
          ),
          DefaultButton(
            text: 'down'.tr.toUpperCase(),
            press: () async {
              if (start == null && end == null) {
                Helper.showError('downloadWrongDate'.tr);
              } else if (end == null) {
                Helper.showLoading('loading'.tr);
                final c = Get.find<HomeController>();
                final r = await c.apiClient.downloadData(
                  widget.sn,
                  DateFormat('yyyy-MM-dd').format(start!),
                  DateFormat('yyyy-MM-dd').format(start!),
                );
                Helper.dismiss();
                if (context.mounted) Navigator.of(context).pop();
                if (!r) Helper.showError('error'.tr);
              } else {
                Helper.showLoading('loading'.tr);
                final c = Get.find<HomeController>();
                final r = await c.apiClient.downloadData(
                  widget.sn,
                  DateFormat('yyyy-MM-dd').format(start!),
                  DateFormat('yyyy-MM-dd').format(end!),
                );
                Helper.dismiss();
                if (context.mounted) Navigator.of(context).pop();
                if (!r) Helper.showError('error'.tr);
              }
            },
          ),
        ],
      ),
    );
  }
}
