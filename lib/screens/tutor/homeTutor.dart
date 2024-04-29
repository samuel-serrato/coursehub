import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String nombre;
  final String tipoUsuario; // Nuevo

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  HomeScreen({required this.nombre, required this.tipoUsuario});
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> asignaturas = [];

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener las tutorías del servidor
    fetchTutorias();
  }

  Future<void> fetchTutorias() async {
    final response =
        await http.get(Uri.parse('https://localhost:44339/api/tutorias'));
    if (response.statusCode == 200) {
      setState(() {
        asignaturas = json.decode(response.body).cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load tutorias');
    }
  }

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
                solicitudDeTutorias(),
                SizedBox(height: 20),
                misTutorias(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget solicitudDeTutorias() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Solicitud de Tutorías',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: CourseItem(
                    courseName: index == 0
                        ? 'Matemáticas Avanzadas'
                        : 'Programación en Python',
                    tutorName:
                        index == 0 ? 'Tutor: Juan Pérez' : 'Tutor: Juan Pérez',
                    schedule: index == 0
                        ? 'Martes 10:00 - 12:00'
                        : 'Miércoles 14:00 - 16:00',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget misTutorias() {
    List<Map<String, dynamic>> misAsignaturas =
        asignaturas.where((asignatura) => asignatura['ID_TUTOR'] == 2).toList();
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis Asignaturas',
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
                  itemCount: misAsignaturas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: CourseItem(
                            courseName: misAsignaturas[index]['MATERIA'],
                            tutorName:
                                'Tutor: Juan Pérez', // O puedes obtener el nombre del tutor de la lista si está disponible
                            schedule:
                                'Creada el ${misAsignaturas[index]['FECHA_CREACION']}',
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
                          widget.nombre,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        Text(
                          widget.tipoUsuario,
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
