import 'package:flutter/material.dart';
import 'package:flutter_profile_mix/components/drawer.dart';

class ProfileSet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About To Do'),
        centerTitle: true,
        leading : IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DrawerMenu()));
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 20),
                _buildHeaderAvatar(),
                SizedBox(width: 10),
                _buildHeaderProfile(),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children : [
                Container(
                  height:120,
                  child:Text(
                    '계정 보기',
                    style: TextStyle(
                      height: 4.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height:120,
                  child:Text(
                    '공지 사항',
                    style: TextStyle(
                      height: 4.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height:120,
                  child:Text(
                    '문의 하기',
                    style: TextStyle(
                      height: 4.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],

        ),
      ),
    );
  }
}

Widget _buildHeaderAvatar() {
  return const SizedBox(
    width: 150,
    height: 150,
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
        "Whfhfhr@hywoman.ac.kr",
        style: TextStyle(
          fontSize: 18,
          decoration: TextDecoration.underline,
        ),
      ),
    ],
  );
}