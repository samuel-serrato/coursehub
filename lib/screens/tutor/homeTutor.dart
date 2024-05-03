import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String nombre;
  final String tipoUsuario;
  final int idUsuario;

  const HomeScreen({
    Key? key,
    required this.nombre,
    required this.tipoUsuario,
    required this.idUsuario,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tutorias = [];
  Map<int, Map<String, dynamic>> usuarios =
      {}; // Almacena el nombre y apellido del usuario por ID

  @override
  void initState() {
    super.initState();
    fetchTutorias(
        widget.idUsuario); // No es necesario pasar el ID del usuario aquí
    fetchDatosUsuario();
  }

  Future<void> fetchTutorias(int idUsuario) async {
    // Modificado: Agregar parámetro idUsuario
    final response =
        await http.get(Uri.parse('https://localhost:44339/api/tutorias'));
    if (response.statusCode == 200) {
      setState(() {
        tutorias = json.decode(response.body).cast<Map<String, dynamic>>();
        tutorias = tutorias
            .where((tutoria) => tutoria['ID_TUTOR'] == idUsuario)
            .toList(); // Filtrar asignaturas por ID_USUARIO
      });
    } else {
      throw Exception('Failed to load tutorias');
    }
  }

  Future<void> fetchDatosUsuario() async {
    final response =
        await http.get(Uri.parse('https://localhost:44339/api/datosusuario'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        usuarios = Map.fromIterable(data,
            key: (e) => e['ID_USUARIO'],
            value: (e) => {
                  'NOMBRE': e['NOMBRE'],
                  'APELLIDOS': e['APELLIDOS'],
                });
      });
    } else {
      throw Exception('Failed to load datosusuario');
    }
  }

  String buscarNombreDeUsuario(int id) {
    return usuarios[id] != null
        ? '${usuarios[id]!['NOMBRE']} ${usuarios[id]!['APELLIDOS']}' // Concatenar nombre y apellido
        : 'Desconocido';
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
          // Lista de solicitudes de tutorías aquí
        ],
      ),
    );
  }

  Widget misTutorias() {
    return Container(
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
          Container(
            height:
                300, // Altura predeterminada para evitar conflictos de desplazamiento
            child: ListView.builder(
              itemCount: tutorias.length,
              itemBuilder: (BuildContext context, int index) {
                final tutoria = tutorias[index];
                final courseName = tutoria['MATERIA'] ?? 'Sin materia';
                final tutorName = buscarNombreDeUsuario(tutoria['ID_TUTOR']);
                final schedules = [
                  tutoria['HORARIO1'] ?? 'No disponible',
                  tutoria['HORARIO2'] ?? 'No disponible',
                  tutoria['HORARIO3'] ?? 'No disponible',
                ];
                final assignedStudents = [
                  tutoria['ID_ALUMNO1'] != null
                      ? buscarNombreDeUsuario(tutoria['ID_ALUMNO1'])
                      : null,
                  tutoria['ID_ALUMNO2'] != null
                      ? buscarNombreDeUsuario(tutoria['ID_ALUMNO2'])
                      : null,
                  tutoria['ID_ALUMNO3'] != null
                      ? buscarNombreDeUsuario(tutoria['ID_ALUMNO3'])
                      : null,
                ];

                // Convertir listas a List<String?>
                final List<String?> schedulesNullable =
                    List<String?>.from(schedules);
                final List<String?> assignedStudentsNullable =
                    List<String?>.from(assignedStudents);

                return CourseItem(
                  courseName: courseName,
                  tutorName: tutorName,
                  schedules: schedulesNullable,
                  assignedStudents: assignedStudentsNullable,
                );
              },
            ),
          ),
        ],
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
  final List<String?> schedules; // Lista de horarios
  final List<String?> assignedStudents; // Lista de alumnos asignados

  const CourseItem({
    required this.courseName,
    required this.tutorName,
    required this.schedules,
    required this.assignedStudents,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF7ff9cb),
        borderRadius: BorderRadius.circular(10),
      ),
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
            'Tutor: $tutorName',
            style: TextStyle(
              color: Color(0xFF13161c),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Horarios y Alumnos Asignados:',
            style: TextStyle(
              color: Color(0xFF13161c),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          // Construir la lista de horarios y alumnos asignados
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < schedules.length; i++)
                Expanded(
                  child: Container(
                    //margin: EdgeInsets.symmetric(horizontal: 0),
                    child: ListTile(
                      title: Text(
                        'Horario ${i + 1}: ${schedules[i] ?? 'No disponible'}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left, // Alineado a la izquierda
                      ),
                      subtitle: Text(
                        assignedStudents[i] != null
                            ? 'Alumno: ${assignedStudents[i]}'
                            : 'Aún no asignado',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left, // Alineado a la izquierda
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
