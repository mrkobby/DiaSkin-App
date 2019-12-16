import 'package:diaskin/widgets/mainApp.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    systemNavigationBarColor: Color(0xFF1C0942),
//    statusBarColor: Colors.transparent,
//  ));
  runApp(new MaterialApp(
    title: 'DiaSkin',
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: new MainApp(),
        // title: new Text(
        //   'Welcome to DiaSkin',
        //   style: new TextStyle(fontSize: 20.0, color: Color(0xFF1C0942)),
        // ),
        loadingText: new Text(
          'If simply looking at the skin does not provide \nthe doctor with a diagnosis, try a pixaled \nskin disease diagnosis.',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0,), textAlign: TextAlign.center,
        ),
        image: new Image.asset('assets/images/splashLogo.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Color(0xFF1C0942));
  }
}
