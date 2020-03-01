import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
//  VideoPlayerController _video_controller;
  String old_direction = "S";
  IO.Socket socket = IO.io('http://64.225.99.23:80', <String, dynamic>{
    'transports': ['websocket'],
    //  'extraHeaders': {'foo': 'bar'} // optional
  });
  @override
  void initState() {
    super.initState();
    // web view
  }
  String getDirection(double degrees, double distance) {
    if (distance != 0.00) {
      if ((degrees >= 0 && degrees < 30) || (degrees >= 330 && degrees <= 360))
        return "F"; // goAhead
      if (degrees <= 210 && degrees >= 150) return "B"; // goBack
      if (degrees <= 120 && degrees >= 60) return "L"; // goLeft
      if (degrees <= 300 && degrees >= 240) return "R"; // goRight
      if (degrees < 330 && degrees > 300) return "I"; // goAheadRight
      if (degrees < 60 && degrees > 30) return "G"; // goAheadLeft
      if (degrees < 210 && degrees > 240) return "J"; // goBackRight
      if (degrees < 250 && degrees > 120) return "H"; // goBackLeft
      // if (degrees < 0 && degrees > 0) return "S"; // stopRobot
    } else
      return "S"; // stopRobot
  }

  @override
  Widget build(BuildContext context) {
    JoystickDirectionCallback onDirectionChangedMovement(
        double degrees, double distance) {
      String direction = getDirection(degrees, distance);
      print(direction);
      if (old_direction != direction) {
        old_direction = direction;
        socket.emit('direction', direction);
      }
    }

    /*    JoystickDirectionCallback onDirectionChangedCamera(
        double degrees, double distance) {
      String data =
          "Degree : ${degrees.toStringAsFixed(2)}, distance : ${distance.toStringAsFixed(2)}";
      //print(data);
    } */

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
            child:
                /* _video_controller.value.initialized
              ?  */
                WebView(
          initialUrl: "http://192.168.1.6/",
          javascriptMode: JavascriptMode.unrestricted,
        )
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
                opacity: 0.8,
                size: 250.0,
                onDirectionChanged: onDirectionChangedMovement,
              ),
              /*  JoystickView(
                innerCircleColor: Colors.black12,
                backgroundColor: Colors.black26,
                opacity: 0.5,
                size: 110.0,
                onDirectionChanged: onDirectionChangedCamera,
              ), */
            ],
          ),
        )
      ],
    ));
  }
}
