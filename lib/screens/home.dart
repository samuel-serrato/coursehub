import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Color(0xFF13161c),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CourseHub',
                  style: TextStyle(
                    color: Color(0xFF7ff9cb),
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
        VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                filaBienvenida(),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                  color: Colors.white
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
                color: Colors.white
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
        color: Color(0xFF7ff9cb),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseName,
            style: TextStyle(
              color: Color(0xFF13161c),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            tutorName,
            style: TextStyle(
              color: Color(0xFF13161c),
            ),
          ),
          SizedBox(height: 8),
          Text(
            schedule,
            style: TextStyle(
              color: Color(0xFF13161c),
            ),
          ),
        ],
      ),
    );
  }
}
