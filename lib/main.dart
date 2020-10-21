import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Ref = FirebaseDatabase.instance.reference();
  String text = ' ';

  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<void> readAllData() async {
    await Ref.child('status_and_name/building_1/floor_1/sensor/1')
        .onValue
        .listen((b) {
      var snapshot = b.snapshot;
      var fullname = snapshot.value['name'].split('_');
      
      //List<DataSnapshot> b = snapshot;


      print(text);
      setState(() {
        text = fullname[3];
      });
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo,
      ),
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Parking Status'),
          ),
          bottomNavigationBar: manu(),
          body: TabBarView(
            children: <Widget>[
              persontab(),
              womentab(),
              accessibletab(),
              viptab(),
              all(),
            ],
          ),
        ),
      ),
    );
  }

  Widget persontab() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Text('$text'),
    );
  }

  Widget womentab() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Text('tab 2'),
    );
  }

  Widget accessibletab() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Text('tab 3'),
    );
  }

  Widget viptab() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Text('tab 4'),
    );
  }

  Widget all() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Text('tab 5'),
    );
  }

  Widget manu() {
    return Container(
      color: Colors.indigo,
      padding: EdgeInsets.all(5.0),
      child: TabBar(
        unselectedLabelColor: Colors.white54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.white,
        tabs: [
          Tab(icon: Icon(Icons.person)),
          Tab(icon: Icon(Icons.pregnant_woman)),
          Tab(icon: Icon(Icons.accessible)),
          Tab(icon: Icon(Icons.work)),
          Tab(icon: Icon(Icons.directions_car)),
        ],
      ),
    );
  }
}
