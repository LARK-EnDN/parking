import 'dart:ffi';

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
  String text = '';
  int b;
  List<int> f = [];
  var s5 = new Map();
  var scount5 = new Map();
  var sall5 = new Map();
  var resall5 = new Map();

  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<void> readAllData() async {
    await Ref.child('status_and_name').once().then((snap) {
      if (snap.value != null) {
        Map<dynamic, dynamic> snapshot = snap.value;
        b = snapshot.length;
        snapshot.forEach((b, value) {
          Ref.child('status_and_name/' + b).once().then((snap) {
            if (snap.value != null) {
              Map<dynamic, dynamic> snapshot = snap.value;
              f.add(snapshot.length);
              snapshot.forEach((f, value) {
                var bb = b.split('_');
                var ff = f.split('_');
                var x = bb[1] + ff[1];
                Ref.child('status_and_name/' + b + '/' + f + '/sensor')
                    .onValue
                    .listen((Event snap) {
                  if (snap.snapshot.value != null) {
                    List<dynamic> snapshot = snap.snapshot.value;
                    text = '';
                    var all = snapshot.length - 1;
                    setState(() {
                      sall5[x] = all;
                    });
                    for (var k in snapshot) {
                      if (k != null) {
                        var name = k['name'].split('_');
                        if (k['status'] == 0) {
                          text += name[3];
                          text += '  ';
                        }
                      }
                    }
                    var sptext = text.split('  ');
                    var count = sptext.length - 1;

                    setState(() {
                      scount5[x] = count;
                      resall5[x] = sall5[x] - scount5[x];
                      s5[x] = text;
                    });
                  }
                });
              });
            }
          });
        });
      }
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
      color: Colors.indigo[50],
      child: ListView.builder(
        itemCount: b,
        itemBuilder: (BuildContext buildContext, int index) {
          return billtab5(index);
        },
      ),
    );
  }

  Widget womentab() {
    return Container(
      color: Colors.indigo[50],
      child: ListView.builder(
        itemCount: b,
        itemBuilder: (BuildContext buildContext, int index) {
          return billtab5(index);
        },
      ),
    );
  }

  Widget accessibletab() {
    return Container(
      color: Colors.indigo[50],
      child: ListView.builder(
        itemCount: b,
        itemBuilder: (BuildContext buildContext, int index) {
          return billtab5(index);
        },
      ),
    );
  }

  Widget viptab() {
    return Container(
      color: Colors.indigo[50],
      child: ListView.builder(
        itemCount: b,
        itemBuilder: (BuildContext buildContext, int index) {
          return billtab5(index);
        },
      ),
    );
  }

  Widget all() {
    return Container(
      color: Colors.indigo[50],
      child: ListView.builder(
        itemCount: b,
        itemBuilder: (BuildContext buildContext, int index) {
          return billtab5(index);
        },
      ),
    );
  }

  Widget billtab5(int index) {
    var bill = index + 1;
    return Padding(
      padding: const EdgeInsets.only(
          left: 50.0, top: 10.0, right: 50.0, bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'อาคารจอดรถ $bill',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            height: 220.0,
            child: ListView.builder(
              itemCount: f[index],
              itemBuilder: (BuildContext buildContext, int index) {
                return floortab5(bill, index);
              },
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[50],
                boxShadow: [
                  BoxShadow(
                      color: Colors.indigo[100],
                      blurRadius: 10.0,
                      spreadRadius: 1.0)
                ]),
          ),
        ],
      ),
    );
  }

  Widget floortab5(int b, int index) {
    var floor = index + 1;
    String x = '$b$floor';
    var xout, a = sall5[x], bb = resall5[x];
    if (s5[x] == null || s5[x] == '') {
      s5[x] = 'ไม่ว่าง';
    }
    if (sall5[x] != null) {
      a = int.parse('$a');
      b = int.parse('$bb');
      xout = a - bb;
      xout = '$xout/$a';
    }
    if (xout == null || xout == '0/$a') {
      xout = '';
    }
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'ชั้น $floor',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[800],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 200,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    s5[x],
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              Container(
                width: 90,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    '$xout',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
