import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_profile_mix/components/widgets/add_new_task.dart';
import 'package:flutter_profile_mix/components/widgets/list.dart';
import 'package:flutter_profile_mix/components/providers/task.dart';
import 'package:flutter_profile_mix/components/drawer.dart';

class ToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: colorCustom,
          accentColor: colorCustom,
          fontFamily: 'Lato',
          textTheme: ThemeData.light().textTheme.copyWith(
            subtitle1: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            subtitle2: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: 'To Do List',
        home: Homepage(),
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
        centerTitle: true,
        automaticallyImplyLeading : true,
        leading : IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DrawerMenu()));
          },
        ),

      ),
      body: List(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => AddNewTask(isEditMode: false, id: '',),
          );
        },
        tooltip: 'Add a new item!',
      ),
    );
  }
}


Map<int, Color> color = {
  50:Color.fromRGBO(136,14,79, .1),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),
};


MaterialColor colorCustom = MaterialColor(0xff192a70, color);