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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CourseHub',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.black),
                      SizedBox(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre del usuario Completo',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          Text(
                            'Tipo de usuario',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: content(context),
          ),
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: 0,
          onDestinationSelected: (int index) {},
          labelType: NavigationRailLabelType.selected,
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.book),
              label: Text('Cursos'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.chat),
              label: Text('Chats'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings),
              label: Text('Ajustes'),
            ),
          ],
        ),
        VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                filaBienvenida(),
                SizedBox(height: 20),
                bienvenida(),
                SizedBox(height: 20),
                cursosActivos(),
                SizedBox(height: 20),
                cursosCompletados(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget filaBienvenida() {
    return Container(
      //color: Color(0xFFEFF5FD),
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '¡Bienvenido al sistema!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('Fecha: ${DateTime.now().toString()}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget bienvenida() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Aquí puedes encontrar tus cursos activos y programar sesiones de tutoría.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cursosActivos() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Cursos Activos:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CourseItem(
                      courseName: 'Matemáticas Avanzadas',
                      tutorName: 'Tutor: Juan Pérez',
                      schedule: 'Martes 10:00 - 12:00',
                    ),
                    CourseItem(
                      courseName: 'Programación en Python',
                      tutorName: 'Tutor: María Gómez',
                      schedule: 'Miércoles 14:00 - 16:00',
                    ), // Agrega más cursos según sea necesario ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cursosCompletados() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Cursos Completados:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CourseItem(
              courseName: 'Introducción a la Física',
              tutorName: 'Tutor: Ana Martínez',
              schedule: 'Completado el 20/03/2024',
            ),
            SizedBox(height: 10),
            CourseItem(
              courseName: 'Historia del Arte',
              tutorName: 'Tutor: Carlos Sánchez',
              schedule: 'Completado el 15/03/2024',
            ),
            // Agrega más cursos completados según sea necesario
          ],
        ),
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final String courseName;
  final String tutorName;
  final String schedule;

  const CourseItem({
    required this.courseName,
    required this.tutorName,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            tutorName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            schedule,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
