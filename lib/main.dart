import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Force landscape device left orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    // Hide status bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController _video_controller;
  IO.Socket socket = IO.io('http://192.168.1.3:3000', <String, dynamic>{
    'transports': ['websocket'],
    //  'extraHeaders': {'foo': 'bar'} // optional
  });
  @override
  void initState() {
    super.initState();
    _video_controller = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        // setState(() {});
        _video_controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _video_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JoystickDirectionCallback onDirectionChangedMovement(
        double degrees, double distance) {
      String data =
          "Degree : ${degrees.toStringAsFixed(2)}, distance : ${distance.toStringAsFixed(2)}";
      print(data);
      socket.emit('direction', {'Degree': data});
    }

    JoystickDirectionCallback onDirectionChangedCamera(
        double degrees, double distance) {
      String data =
          "Degree : ${degrees.toStringAsFixed(2)}, distance : ${distance.toStringAsFixed(2)}";
      //print(data);
    }

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
            child:
                /* _video_controller.value.initialized
              ?  */
                VideoPlayer(_video_controller)
            /* : Container(
                  child: Text('Loading ..'),
                ), */
            ),
        Container(
          //alignment: ,
          margin: new EdgeInsets.symmetric(horizontal: 18.0),
          // color: ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              JoystickView(
                innerCircleColor: Colors.black12,
                backgroundColor: Colors.black26,
                opacity: 0.5,
                size: 110.0,
                onDirectionChanged: onDirectionChangedMovement,
              ),
              JoystickView(
                innerCircleColor: Colors.black12,
                backgroundColor: Colors.black26,
                opacity: 0.5,
                size: 110.0,
                onDirectionChanged: onDirectionChangedCamera,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
