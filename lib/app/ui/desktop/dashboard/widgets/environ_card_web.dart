import 'package:flutter/material.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/data/models/refrigerator.dart';
import 'package:phuonghai/app/ui/common/widgets/header_card.dart';

class EnvironCardWeb extends StatelessWidget {
  const EnvironCardWeb({
    Key? key,
    required this.model,
  }) : super(key: key);

  final Refrigerator model;

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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      leading: SizedBox(
                          height: double.infinity,
                          child: Icon(Icons.pause_circle)),
                      title: Text('Đang hoạt động'),
                      subtitle: Text('Trạng thái thiết bị'),
                    ),
                  ),
                  SizedBox(height: 25, child: VerticalDivider()),
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.timelapse),
                      title: Text('00:12'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.waves),
                          SizedBox(height: 2),
                          Text('Gia nhiệt')
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.ac_unit),
                          SizedBox(height: 2),
                          Text('Làm lạnh')
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.invert_colors_off,
                            color: Colors.orange,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Tách ẩm',
                            style: TextStyle(color: Colors.orange),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.invert_colors),
                          SizedBox(height: 2),
                          Text('Tạo ẩm')
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        color: Colors.grey.shade100,
                        child: SizedBox(
                          width: 280,
                          height: 100,
                          child: Center(
                            child: ListTile(
                              leading: SizedBox(
                                height: double.infinity,
                                child: Icon(Icons.thermostat),
                              ),
                              title: Text('Nhiệt độ'),
                              subtitle: Text('Cài đặt: 50 °C'),
                              trailing: Text(
                                '50.7 °C',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        color: Colors.grey.shade100,
                        child: SizedBox(
                          width: 280,
                          height: 100,
                          child: Center(
                            child: ListTile(
                              leading: SizedBox(
                                height: double.infinity,
                                child: Icon(Icons.water_drop),
                              ),
                              title: Text('Độ ẩm'),
                              subtitle: Text('Cài đặt: 50 %'),
                              trailing: Text(
                                '57 %',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
