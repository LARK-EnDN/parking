import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.pregnant_woman)),
                Tab(icon: Icon(Icons.accessible)),
                Tab(icon: Icon(Icons.work)),
                Tab(icon: Icon(Icons.directions_car)),
              ],
            ),
            title: Text('Parking Status'),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20.0),
                child: Text('ว่าง'),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: RaisedButton (
                  child: Text('read'),
                  onPressed: () {
                    //readdata();
                  }),
              ),
              Text('พิการ'),
              Text('VIP'),
              Text('ทั้งหมด'),
            ],
          ),
        ),
      ),
    );
  }
}
/*
  void readdata() {
    REF.child('status_and_name/building_1/floor_1/sensor').once().then((DataSnapshot dataSnapShot){
      print(dataSnapShot.value);
      /*Map<dynamic, dynamic> values = dataSnapShot.value;
      values.forEach((key, value) {
        print(value['1']);
      });*/
    });
  }*/

