import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';

class MemoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {

  AndroidNotificationChannel? channel;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://my-todo-list-d3338-default-rtdb.firebaseio.com/';
  List<Memo> memos = List.empty(growable: true);

  // final FirebaseMessaging _firebaseMessaging = FirebaseMexssaging();


  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child('memo');
    reference!.onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(Memo.fromSnapshot(event.snapshot));
      });
    });

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }


  _initFirebaseMessaging(BuildContext context) async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // showDialog(context: context, builder: (context){
        //   return AlertDialog(title: Text("${notification.title}"), content: Text("${notification.body}"),);
        // });

        flutterLocalNotificationsPlugin?.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channel!.description,
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    print("messaging.getToken() , ${await messaging.getToken()}");
  }

  @override
  Widget build(BuildContext context) {
    _initFirebaseMessaging(context);

    return Scaffold(
      body:
      Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            child: Center(
              child: memos.length == 0
                  ? CircularProgressIndicator()
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Card(
                    child: GridTile(
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: SizedBox(
                            child: GestureDetector(
                              onTap: () async {
                                Memo? memo = await Navigator.of(context).push(
                                    MaterialPageRoute<Memo>(
                                        builder: (BuildContext context) =>
                                            MemoDetailPage(
                                                reference!, memos[index])));
                                if (memo != null) {
                                  setState(() {
                                    memos[index].title = memo.title;
                                    memos[index].content = memo.content;
                                  });
                                }
                              },
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(memos[index].title),
                                        content: Text('삭제하시겠습니까?'),
                                        actions: <Widget>[
                                          OutlinedButton(
                                              onPressed: () {
                                                reference!
                                                    .child(memos[index].key!)
                                                    .remove()
                                                    .then((_) {
                                                  setState(() {
                                                    memos.removeAt(index);
                                                    Navigator.of(context).pop();
                                                  });
                                                });
                                              },
                                              child: Text('예')),
                                          OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('아니요')),
                                        ],
                                      );
                                    });
                              },
                              child: Text(memos[index].content),
                            ),
                          ),
                        ),
                        header: Text(memos[index].title)
                    ),
                  );
                },
                itemCount: memos.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MemoAddApp(reference!)));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xff192a70),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}




