import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_mix/components/drawer.dart';
import 'package:firebase_core/firebase_core.dart';


class MyApp extends StatelessWidget {
  const MyApp({key});

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About To Do',
      theme: ThemeData(
          appBarTheme : const AppBarTheme(
            color : Color(0xff192a70),
            centerTitle: true,
          )
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: DrawerMenu(),
    );
  }

}