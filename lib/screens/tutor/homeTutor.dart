import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      body: Container(
        child: Column(
          children: [
            header(context),
            Expanded(
              child: content(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Row(
      children: [
        //VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
         /*        filaBienvenida(),
                SizedBox(height: 20), */
                solicitudDeTutorias(),
                SizedBox(height: 20),
                tutoriasPasadas(),
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
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget solicitudDeTutorias() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Solicitudes de Tutorías',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 200, // Establece una altura para limitar la altura del ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2, // Ajusta esto al número total de cursos activos
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CourseItem(
                  courseName: index == 0 ? 'Matemáticas Avanzadas' : 'Programación en Python',
                  tutorName: index == 0 ? 'Tutor: Juan Pérez' : 'Tutor: Juan Pérez',
                  schedule: index == 0 ? 'Martes 10:00 - 12:00' : 'Miércoles 14:00 - 16:00',
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}


  Widget tutoriasPasadas() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tutorías Pasadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                child: ListView.builder(
                  itemCount:
                      5, // Aquí coloca el número total de cursos completados
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: CourseItem(
                            courseName: 'Introducción a la Física',
                            tutorName: 'Tutor: Juan Pérez',
                            schedule: 'Completado el 20/03/2024',
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    double topMargin = MediaQuery.of(context).size.width > 600 ? 12 : 60;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16.0, topMargin, 16.0, 8.0),
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
                          'Nombre de usuario',
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
        Divider(color: Colors.white),
      ],
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
