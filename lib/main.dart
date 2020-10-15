import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabBarDemo(),
    );
  }
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon:  Icon(Icons.person)),
                Tab(icon:  Icon(Icons.pregnant_woman)),
                Tab(icon:  Icon(Icons.accessible)),
                Tab(icon:  Icon(Icons.work)),
                Tab(icon:  Icon(Icons.directions_car)),
              ],
            ),
            title: Text('Parking status'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.person),
              Icon(Icons.pregnant_woman),
              Icon(Icons.accessible),
              Icon(Icons.work),
              Icon(Icons.directions_car),
          ],),
        ),
      ),
    );
  }
}
