import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/ui/widgets/status_widget.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;

class DownloadModal extends StatefulWidget {
  const DownloadModal({Key? key, required this.sn}) : super(key: key);

  final String sn;
  @override
  State<DownloadModal> createState() => _DownloadModalState();
}

class _DownloadModalState extends State<DownloadModal> {
  DateTime selectedDate = DateTime.now();
  String startDate = "", endDate = "", status = "";
  bool error = false;

  _selectDate(bool start) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (start) {
          startDate = picked.toString().substring(0, 10);
        } else {
          endDate = picked.toString().substring(0, 10);
        }
      });
    }
  }

  Future<bool> downloadData() async {
    final Dio dio = Dio();

    try {
      final response = await dio.get(
        'https://thegreenlab.xyz/Datums/DataByDate?DeviceSerialNumber=${widget.sn}&StartDate=$startDate&EndDate=$endDate',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );

      if (kIsWeb) {
        // final _base64 = base64Encode(response.data.toString().codeUnits);
        // // Create the link with the file
        // final anchor = html.AnchorElement(
        //     href: 'data:application/octet-stream;base64,$_base64')
        //   ..target = 'blank';
        // // add the name
        // anchor.download = '${widget.sn}_${startDate}_$endDate.csv';

        // // trigger download
        // html.document.body!.append(anchor);
        // anchor.click();
        // anchor.remove();
        return true;
      } else {
        if (await Permission.storage.request().isGranted) {
          if (Platform.isAndroid) {
            final directory = await getExternalStorageDirectory();
            String newPath = "";
            if (directory != null) {
              List<String> paths = directory.path.split("/");
              for (int x = 1; x < paths.length; x++) {
                String folder = paths[x];
                if (folder != "Android") {
                  newPath += "/" + folder;
                } else {
                  break;
                }
              }
              newPath = directory.path + "/PhuongHaiApp";
              final newDir = Directory(newPath);
              // Create file
              if (!await newDir.exists()) {
                await newDir.create(recursive: true);
              }
              File saveFile =
                  File('${newDir.path}/${widget.sn}_${startDate}_$endDate.csv');
              saveFile.writeAsString(response.data.toString());
            }
          } else {
            final directory = await getApplicationDocumentsDirectory();

            final newDir = Directory(directory.path + "/PhuongHaiApp");
            if (!await newDir.exists()) {
              await newDir.create(recursive: true);
            }
            File saveFile =
                File('${newDir.path}/${widget.sn}_${startDate}_$endDate.csv');
            saveFile.writeAsString(response.data.toString());
          }

          return true;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return SafeArea(
      child: Container(
        height: 350,
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                locale.translate('txtDownload'),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                OutlinedButton(
                  child: Text(locale.translate('fromDate')),
                  onPressed: () {
                    status = "";
                    _selectDate(true);
                  },
                ),
                const SizedBox(width: 50),
                Text(startDate),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton(
                  child: Text(locale.translate('toDate')),
                  onPressed: () {
                    status = "";
                    _selectDate(false);
                  },
                ),
                const SizedBox(width: 50),
                Text(endDate),
              ],
            ),
            const Spacer(),
            StatusWidget(error: error, text: status),
            const SizedBox(height: 20),
            Center(
              child: DefaultButton(
                width: 300,
                text: locale.translate('txtDownloadBtn'),
                press: () async {
                  if (startDate.isNotEmpty &&
                      endDate.isNotEmpty &&
                      DateTime.parse(startDate)
                              .compareTo(DateTime.parse(endDate)) <=
                          0) {
                    final state = await downloadData();
                    if (state) {
                      if (kIsWeb) {
                        Future.delayed(const Duration(milliseconds: 250),
                            (() => Navigator.of(context).pop()));
                      } else {
                        setState(() {
                          error = false;
                          status =
                              "${locale.translate('downloadDone')}: [Download/PhuongHaiApp]";
                        });
                      }
                    } else {
                      setState(() {
                        error = true;
                        status = locale.translate('downloadError');
                      });
                    }
                  } else {
                    setState(() {
                      error = true;
                      status = locale.translate('downloadWrongDate');
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
