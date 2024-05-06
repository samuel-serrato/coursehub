import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String nombre;
  final String tipoUsuario; // Nuevo
  final int idUsuario;

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  HomeScreen(
      {required this.nombre,
      required this.tipoUsuario,
      required this.idUsuario});
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tutorias = [];
  Map<int, Map<String, dynamic>> usuarios =
      {}; // Almacena el nombre y apellido del usuario por ID

  @override
  void initState() {
    super.initState();
    fetchTutorias();
    fetchDatosUsuario();
  }

  Future<void> fetchTutorias() async {
    final response =
        await http.get(Uri.parse('https://localhost:44339/api/tutorias'));
    if (response.statusCode == 200) {
      setState(() {
        tutorias = json.decode(response.body).cast<Map<String, dynamic>>();
        tutorias = tutorias
            .where((tutoria) =>
                tutoria['ID_ALUMNO1'] == widget.idUsuario ||
                tutoria['ID_ALUMNO2'] == widget.idUsuario ||
                tutoria['ID_ALUMNO3'] == widget.idUsuario)
            .toList();
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

  Future<void> liberarHorario(
      int idTutoria, Map<String, dynamic> tutoria) async {
    final url = 'https://localhost:44339/api/tutorias/$idTutoria';
    String? horarioSeleccionado;

    // Determinar cuál horario debe ser nulo
    if (tutoria['ID_ALUMNO1'] == widget.idUsuario) {
      horarioSeleccionado = 'ID_ALUMNO1';
    } else if (tutoria['ID_ALUMNO2'] == widget.idUsuario) {
      horarioSeleccionado = 'ID_ALUMNO2';
    } else if (tutoria['ID_ALUMNO3'] == widget.idUsuario) {
      horarioSeleccionado = 'ID_ALUMNO3';
    }

    print('Horario seleccionado: $horarioSeleccionado');

    // Construir el cuerpo JSON dinámicamente
    final Map<String, dynamic> requestBody = {
      horarioSeleccionado!:
          null, // Usar el valor de horarioSeleccionado como clave
    };

    print('Solicitud HTTP: $requestBody');

    // Enviar la solicitud HTTP
    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    print('Respuesta HTTP: ${response.statusCode}');
    print('Cuerpo de respuesta: ${response.body}');

    // Añadir puntos de impresión adicionales si es necesario
    // Por ejemplo:
    // print('Después de la solicitud HTTP');

    if (response.statusCode == 200) {
      // Si la actualización fue exitosa, vuelves a cargar las tutorías
      fetchTutorias();
    } else {
      throw Exception('Error al liberar el horario');
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
                /*        filaBienvenida(),
                SizedBox(height: 20), */
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

  Widget cursosActivos() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cursos Activos:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tutorias.length,
              itemBuilder: (BuildContext context, int index) {
                final tutoria = tutorias[index];
                final String horario = getHorario(
                    tutoria); // Obtener el horario correspondiente al alumno
                // Al presionar el botón "Liberar Horario", se llama a la función liberarHorario
                void liberarHorarioCallback() {
                  liberarHorario(tutoria['ID_TUTORIA'],
                      tutoria); // Pasar el ID de la tutoría
                }

                return Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: CourseItem(
                    courseName: tutoria['MATERIA'] ?? 'Sin materia',
                    category:
                        tutoria['CATEGORIA'] ?? 'Sin categoría', // Nueva línea
                    tutorName:
                        'Tutor: ${buscarNombreDeUsuario(tutoria['ID_TUTOR'])}',
                    schedule: horario,
                    liberarHorarioCallback:
                        liberarHorarioCallback, // Pasar la función como callback
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String getHorario(Map<String, dynamic> tutoria) {
    final int idUsuario = widget.idUsuario;
    if (tutoria['ID_ALUMNO1'] == idUsuario) {
      return tutoria['HORARIO1'];
    } else if (tutoria['ID_ALUMNO2'] == idUsuario) {
      return tutoria['HORARIO2'];
    } else if (tutoria['ID_ALUMNO3'] == idUsuario) {
      return tutoria['HORARIO3'];
    }
    return 'Horario no disponible';
  }

  Widget cursosCompletados() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cursos Completados:',
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
                        Container(),
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
  final String category; // Nuevo parámetro
  final String tutorName;
  final String schedule; // Cambiado a schedule en lugar de schedules
  final VoidCallback liberarHorarioCallback; // Nueva callback

  const CourseItem({
    required this.courseName,
    required this.category, // Actualizado
    required this.tutorName,
    required this.schedule, // Cambiado a schedule en lugar de schedules
    required this.liberarHorarioCallback, // Nueva callback
  });

  String convertirFormato12Horas(String tiempo24Horas) {
    // Creamos un objeto de formato para el tiempo de 24 horas
    final DateFormat format24Horas = DateFormat('HH:mm');

    // Parseamos el tiempo en formato de 24 horas
    final DateTime dateTime = format24Horas.parse(tiempo24Horas);

    // Creamos un objeto de formato para el tiempo de 12 horas
    final DateFormat format12Horas = DateFormat('h:mm a');

    // Formateamos el tiempo en formato de 12 horas y lo devolvemos
    return format12Horas.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
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
            // Cambiado para mostrar el horario
            'Horario: ${convertirFormato12Horas(schedule)}',
            style: TextStyle(
              color: Color(0xFF13161c),
            ),
          ),
          SizedBox(height: 50),
          Row(
            children: [
              Icon(
                Icons.label,
                color: Color(0xFF13161c),
                size: 18,
              ),
              SizedBox(width: 4),
              Text(
                category,
                style: TextStyle(
                  color: Color(0xFF13161c),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed:
                    liberarHorarioCallback, // Llama a la callback cuando se presiona
                child: Text('Liberar Horario'), // Texto para el botón
              ),
            ],
          ),
        ],
      ),
    );
  }
}
