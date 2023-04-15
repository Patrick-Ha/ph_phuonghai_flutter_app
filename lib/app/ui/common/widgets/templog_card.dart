import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/ui/common/widgets/header_card.dart';

import 'device_card.dart';

class TempLogCard extends StatelessWidget {
  const TempLogCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final DeviceModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderCard(model: model),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Obx(
            () => model.isActived.value
                ? model.sensors.isNotEmpty
                    ? TempLogSensor(sensor: model.sensors[0])
                    : const SizedBox.shrink()
                : SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.report,
                          size: 50,
                          color: Colors.amber,
                        ),
                        Text(
                          "lostConnection".tr + ": " + model.getSyncDateObs,
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class TempLogSensor extends StatefulWidget {
  final SensorModel sensor;

  const TempLogSensor({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  @override
  State<TempLogSensor> createState() => _TempLogSensorState();
}

class _TempLogSensorState extends State<TempLogSensor> {
  Timer? timer;
  final Dio dio = Dio();
  final baseUrl = "http://thegreenlab.xyz:3000/Datums";
  final valueList = <double>[].obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateSensorData();
    });

    timer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => updateSensorData(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateSensorData() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final response = await dio.get(
        '$baseUrl/DataByDateJson?DeviceSerialNumber=${widget.sensor.key}&StartDate=$today&EndDate=$today',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );

      valueList.clear();
      for (var item in response.data) {
        valueList.add(item['Value'].toDouble());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SmartpHSensor(sensor: widget.sensor),
        ),
        Obx(
          () => valueList.isEmpty
              ? const SizedBox(height: 8)
              : SizedBox(
                  height: 140,
                  child: TempChart(valueList: valueList),
                ),
        ),
      ],
    );
  }
}

class TempChart extends StatelessWidget {
  const TempChart({
    Key? key,
    required this.valueList,
  }) : super(key: key);

  final List<double> valueList;

  final List<Color> gradientColors = const [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        clipData: FlClipData.none(),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        minY: valueList.reduce(min) - 5,
        maxY: valueList.reduce(max) + 2,
        lineBarsData: [
          LineChartBarData(
            spots: valueList.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withOpacity(0.25))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
