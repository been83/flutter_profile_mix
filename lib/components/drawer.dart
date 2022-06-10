
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_mix/components/profile.dart';
import 'package:flutter_profile_mix/components/today.dart';
import 'package:flutter_profile_mix/components/inbox.dart';
import 'package:flutter_profile_mix/components/settings.dart';
import '../memoPage.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About To Do'),
        ),
      body : ListView(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 40),
              _buildHeaderAvatar(),
              SizedBox(width: 40),
              _buildHeaderProfile(),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            width:40,
            height:450,
            child: FutureBuilder(
              future: Firebase.initializeApp(), // 선언해야 할 함수
              builder: (context, snapshot) {
                if (snapshot.hasError) { // 만약 선언 시 에러가 나면 출력될 위젯
                  return Center(
                    child: Text('Error'),
                  );
                }
// 선언 완료 후 표시할 위젯
                if (snapshot.connectionState == ConnectionState.done) {
                  _getToken();
                  _initFirebaseMessaging(context);
                  return MemoPage();
                }
// 선언되는 동안 표시할 위젯
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.all(0.0), children: <Widget>[
          UserAccountsDrawerHeader(
                accountName: Text('쪼로록 님'),
                accountEmail: Text('Whfhfhr@hywoman.ac.kr'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: ExactAssetImage('assets/avatar.png'),
                ),

                decoration: BoxDecoration(
                  color: Color(0xff192a70),
                ),

              ),
              ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.face),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSet()));
                },
              ),

              ListTile(
                title: Text('Inbox'),
                leading: Icon(Icons.move_to_inbox),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ToDoListApp()));
                },
              ),


              ListTile(
                title: Text('Today'),
                leading: Icon(Icons.calendar_today),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TodoListPage()));
                },
              ),

              ListTile(
                title: Text('Projects'),
                leading: Icon(Icons.folder_open),
                onLongPress: (){},
              ),


              ListTile(
                title: Text('Labels'),
                leading: Icon(Icons.label),
                onLongPress: (){},
              ),


              ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
              ),


              ListTile(
                  title: Text('Close'),
                  leading: Icon(Icons.close),
                  onTap: (){
                    Navigator.of(context).pop();}
              ),
            ]
        ),
      ),

    );

  }

}

  Widget _buildHeaderAvatar() {
    return const SizedBox(
      width: 100,
      height: 100,
      child: CircleAvatar(
        backgroundImage: AssetImage("assets/avatar.png"),
      ),
    );
  }

  Widget _buildHeaderProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "쪼로록 님",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "Be Brave, Be Humble",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }


_getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  print("messaging.getToken() , ${await messaging.getToken()}");
}

_initFirebaseMessaging(BuildContext context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print(event.notification!.title);
    print(event.notification!.body);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("알림"),
            content: Text(event.notification!.body!),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
}