// import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
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
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  var show;
  String text = '', textoff = '', boff = '';
  int b = 0;
  List<int> f = [];
  var bsta = new Map();
  var s = new Map();
  var scount = new Map();
  var sall = new Map();
  var resall = new Map();
  var soff = new Map();

  @override
  void initState() {
    super.initState();
    readAllData();
    gettoken();
  }
  Future<void> gettoken()async{
    String token = await firebaseMessaging.getToken();
    var valset = {'$token': 'token'};
    await Ref.child('token').update(valset);
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
                var xx = bb[1] + ff[1], x, all;
                Ref.child('status_and_name/' + b + '/' + f + '/board/1/status')
                    .onValue
                    .listen((Event snap) {
                  setState(() {
                    bsta[xx] = snap.snapshot.value;
                  });

                  Ref.child('status_and_name/' + b + '/' + f + '/sensor')
                      .onValue
                      .listen((Event snap) {
                    if (snap.snapshot.value != null) {
                      List<dynamic> snapshot = snap.snapshot.value;
                      for (var i = 0; i < 5; i++) {
                        text = '';
                        textoff = '';
                        x = '$i' + xx;
                        all = 0;
                        for (var k in snapshot) {
                          if (k != null) {
                            var name = k['name'].split('_');
                            if (i == 4) {
                              if (k['status'] == 0) {
                                all = snapshot.length - 1;
                                text += name[3];
                                text += '  ';
                              }
                              if (k['status'] == 2 && bsta[xx] != 2) {
                                textoff += name[3];
                                textoff += '  ';
                              }
                              if (bsta[xx] == 2) {
                                textoff += name[3];
                                textoff += '  ';
                              }
                            } else if (k['type'] == '$i') {
                              all++;
                              if (k['status'] == 0) {
                                text += name[3];
                                text += '  ';
                              }
                              if (k['status'] == 2 && bsta[xx] != 2) {
                                textoff += name[3];
                                textoff += '  ';
                              }
                              if (bsta[xx] == 2) {
                                textoff += name[3];
                                textoff += '  ';
                              }
                            }
                          }
                        }
                        var sptext = text.split('  ');
                        var count = sptext.length - 1;
                        setState(() {
                          sall[x] = all;
                          scount[x] = count;
                          resall[x] = sall[x] - scount[x];
                          s[x] = text;
                          soff[x] = textoff;
                        });
                      }
                    }
                  });
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
        primaryColor: Colors.grey[850],
      ),
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Parking Status',
              style: TextStyle(color: Colors.grey[100]),
            ),
          ),
          bottomNavigationBar: manu(),
          body: TabBarView(
            children: <Widget>[
              all(4),
              persontab(0),
              womentab(1),
              accessibletab(2),
              viptab(3),
            ],
          ),
        ),
      ),
    );
  }

  Widget all(int i) {
    return Container(
      color: Colors.indigo[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Text(
                'ช่องจอดรถทั้งหมด',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.indigo[100],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: ListView.builder(
                itemCount: b,
                itemBuilder: (BuildContext buildContext, int index) {
                  return billtab(i, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget persontab(int i) {
    return Container(
      color: Colors.teal[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Text(
                'แนะนำช่องจอดรถสำหรับลูกค้าทั่วไป',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.teal[100],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: ListView.builder(
                itemCount: b,
                itemBuilder: (BuildContext buildContext, int index) {
                  return billtab(i, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget womentab(int i) {
    return Container(
      color: Colors.purple[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Text(
                'แนะนำช่องจอดรถสำหรับสตรี',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.purple[100],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: ListView.builder(
                itemCount: b,
                itemBuilder: (BuildContext buildContext, int index) {
                  return billtab(i, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget accessibletab(int i) {
    return Container(
      color: Colors.blue[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Text(
                'แนะนำช่องจอดรถสำหรับผู้นั่งรถเข็น',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blue[100],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: ListView.builder(
                itemCount: b,
                itemBuilder: (BuildContext buildContext, int index) {
                  return billtab(i, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget viptab(int i) {
    return Container(
      color: Colors.brown[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Text(
                'แนะนำช่องจอดรถสำหรับลูกค้าพิเศษ',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.brown[100],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: ListView.builder(
                itemCount: b,
                itemBuilder: (BuildContext buildContext, int index) {
                  return billtab(i, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget billtab(int i, int index) {
    var bill = index + 1;
    var shcol, billcol, borcol;
    switch (i) {
      case 4:
        shcol = Colors.indigo[900];
        billcol = Colors.indigo[200];
        borcol = Colors.indigo;
        break;
      case 0:
        shcol = Colors.teal[900];
        billcol = Colors.teal[200];
        borcol = Colors.teal;
        break;
      case 1:
        shcol = Colors.purple[900];
        billcol = Colors.purple[200];
        borcol = Colors.purple;
        break;
      case 2:
        shcol = Colors.blue[900];
        billcol = Colors.blue[200];
        borcol = Colors.blue;
        break;
      case 3:
        shcol = Colors.brown[900];
        billcol = Colors.brown[200];
        borcol = Colors.brown;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(
          left: 50.0, top: 5.0, right: 50.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'อาคารจอดรถ $bill',
            style: TextStyle(
              fontSize: 18.0,
              color: billcol,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            height: 200.0,
            child: ListView.builder(
              itemCount: f[index],
              itemBuilder: (BuildContext buildContext, int index) {
                return floortab(i, bill, index);
              },
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: borcol,
                boxShadow: [
                  BoxShadow(
                    color: shcol,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  )
                ]),
          ),
        ],
      ),
    );
  }

  Widget floortab(int i, int b, int index) {
    var texcol, off, flex;
    off = offline(i, b, index + 1);
    switch (i) {
      case 4:
        texcol = Colors.indigo[100];
        break;
      case 0:
        texcol = Colors.teal[100];
        break;
      case 1:
        texcol = Colors.purple[100];
        break;
      case 2:
        texcol = Colors.blue[100];
        break;
      case 3:
        texcol = Colors.brown[100];
        break;
    }
    var floor = index + 1;
    String x = '$i$b$floor', xx = '$b$floor';
    var xout, a = sall[x], bb = resall[x];
    if (s[x] == null || s[x] == '') {
      s[x] = 'ไม่ว่าง';
      if (bsta[xx] != 2 && soff[x]=='') {
          off = SizedBox(width: 0);
      }
    } else if (sall[x] != null) {
      a = int.parse('$a');
      b = int.parse('$bb');
      xout = a - bb;
      xout = '$xout/$a';
    }
    if (xout == null || xout == '0/$a') {
      xout = '';
    }
    if (bsta[xx] == 2) {
      flex = 0;
      show = SizedBox(width: 0);
      xout = '';
      if ((soff[x] == null || soff[x] == '')) {
        show = Text(
          s[x],
          style: TextStyle(
            fontSize: 20.0,
            color: texcol,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }
    if (bsta[xx] == 1 || bsta[xx] == null) {
      flex = 1;
      show = Text(
        s[x],
        style: TextStyle(
          fontSize: 20.0,
          color: texcol,
          fontWeight: FontWeight.bold,
        ),
      );
      if(s[x] == 'ไม่ว่าง' && soff[x] !='' && i!=4){
        flex = 0;
        show = SizedBox(width: 0);
        off = offline(i, b, index + 1);

        // off = SizedBox(width: 0);
      }else if(s[x] == 'ไม่ว่าง' && soff[x] !='' && i==4){
        flex = 0;
        show = SizedBox(width: 0);
      }

    }
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 0, top: 10.0),
            child: Text(
              'ชั้น $floor',
              style: TextStyle(
                fontSize: 18.0,
                color: texcol,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    // width: 200,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: flex,
                          child: show,
                        ),
                        off,
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    child: Text(
                      '$xout',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: texcol,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget offline(int i, int b, int index) {
    var x = '$i$b$index', texcol;
    if (soff[x] == null || soff[x] == '') soff[x] = '';
    switch (i) {
      case 4:
        texcol = Colors.indigo[400];
        break;
      case 0:
        texcol = Colors.teal[400];
        break;
      case 1:
        texcol = Colors.purple[400];
        break;
      case 2:
        texcol = Colors.blue[400];
        break;
      case 3:
        texcol = Colors.brown[400];
        break;
    }
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
        child: Text(
          soff[x],
          style: TextStyle(
            fontSize: 20.0,
            color: texcol,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget manu() {
    return Container(
      color: Colors.grey[850],
      padding: EdgeInsets.all(5.0),
      child: TabBar(
        unselectedLabelColor: Colors.white54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.white,
        tabs: [
          Tab(icon: Icon(Icons.directions_car)),
          Tab(icon: Icon(Icons.person)),
          Tab(icon: Icon(Icons.pregnant_woman)),
          Tab(icon: Icon(Icons.accessible)),
          Tab(icon: Icon(Icons.work)),
        ],
      ),
    );
  }
}
