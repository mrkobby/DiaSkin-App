import 'package:diaskin/widgets/settings/settingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'capture/captureScreen.dart';
import 'home/homeScreen.dart';

class MainApp extends StatefulWidget {
  MainApp({Key key}) : super(key: key);

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  int selectedIndex = 0;
  final widgetOptions = [
    new Home(),
    new Capture(),
    // new CameraWidget(),
    Text('Discover'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C0942),
        title: Row(
          children: <Widget>[
            Image.asset('assets/images/diaskinLogoSm.png'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Skin',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
        elevation: 100.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
          )
        ],
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_weak), title: Text('Daignosis')),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), title: Text('Discover')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.red,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
