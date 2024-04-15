import 'package:coursehub/navigation_railEstudiante.dart';
import 'package:coursehub/screens/login.dart';
import 'package:flutter/material.dart';

import 'navigation_railTutor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CourseHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
