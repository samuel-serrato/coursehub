import 'package:coursehub/navigation_rail.dart';
import 'package:coursehub/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CourseHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationRailScreen(),
    );
  }
}
