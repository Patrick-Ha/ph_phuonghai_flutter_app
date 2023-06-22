import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_vlc_player/src/vlc_player_controller.dart';


class Camera extends StatefulWidget {
  Camera({Key? key, required this.title}) : super(key: key);


  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _CameraState extends State<Camera> {
  VlcPlayerController _vlcViewController = new VlcPlayerController.network(
    "rtsp://admin:1234abcd@14.241.170.107:554/Streaming/Channels/101",
    autoPlay: true,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new VlcPlayer(
              controller: _vlcViewController,
              aspectRatio: 16 / 9,
              placeholder: Text("Hello World"),
            ),
          ],
        ),
      ),
    );
  }
}
