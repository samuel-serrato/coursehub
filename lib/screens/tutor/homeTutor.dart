import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Agregamos esta importación

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
  final TextEditingController _materiaController = TextEditingController();

  List<Map<String, dynamic>> tutorias = [];
  Map<int, Map<String, dynamic>> usuarios =
      {}; // Almacena el nombre y apellido del usuario por ID

  String selectedTime1 = '';
  String selectedTime2 = '';
  String selectedTime3 = '';

  @override
  void initState() {
    super.initState();
    fetchTutorias(
        widget.idUsuario); // No es necesario pasar el ID del usuario aquí
    fetchDatosUsuario();
  }

  void _dialogAgregarTutoria(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            //do your logic here:
            selectedTime1 = '';
            selectedTime2 = '';
            selectedTime3 = '';
            _materiaController.clear();
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: Color(0xFF13161c),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Ancho del 80% de la pantalla
                  height: MediaQuery.of(context).size.height *
                      0.6, // Ancho del 80% de la pantalla
                  padding:
                      EdgeInsets.all(20), // Espacio alrededor del contenido
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 8, left: 8, right: 8, bottom: 30),
                          child: Text(
                            'Agregar Tutoría',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        TextFormField(
                          controller: _materiaController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Materia',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 50),
                        _buildTimeButton(context, 'Horario 1', selectedTime1,
                            (time) {
                          setState(() {
                            selectedTime1 = time;
                          });
                        }),
                        SizedBox(height: 10),
                        _buildTimeButton(context, 'Horario 2', selectedTime2,
                            (time) {
                          setState(() {
                            selectedTime2 = time;
                          });
                        }),
                        SizedBox(height: 10),
                        _buildTimeButton(context, 'Horario 3', selectedTime3,
                            (time) {
                          setState(() {
                            selectedTime3 = time;
                          });
                        }),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF7ff9cb)),
                          ),
                          onPressed: () {
                            // Lógica para enviar solicitud post
                            addTutoria(context);
                          },
                          child: Text(
                            'Agregar Tutoría',
                            style: TextStyle(color: Color(0xFF13161c)),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFB80000),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedTime1 = '';
                              selectedTime2 = '';
                              selectedTime3 = '';
                              _materiaController.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTimeButton(BuildContext context, String labelText,
      String selectedTime, Function(String) onTimeSelected) {
    return TextButton(
      onPressed: () {
        showTimePicker(
          helpText: 'Selección de hora',
          hourLabelText: 'Hora',
          minuteLabelText: 'Minutos',
          cancelText: 'Cancelar',
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((pickedTime) {
          if (pickedTime != null) {
            String formattedTime = pickedTime.format(context);
            // No convertimos el tiempo seleccionado al formato de 12 horas aquí
            onTimeSelected(
                formattedTime); // Enviamos el tiempo en formato de 12 horas
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelText,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            selectedTime.isNotEmpty ? selectedTime : 'Seleccionar hora',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> fetchTutorias(int idUsuario) async {
    // Modificado: Agregar parámetro idUsuario
    final response =
        await http.get(Uri.parse('https://localhost:44339/api/tutorias'));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> fetchedTutorias =
          json.decode(response.body).cast<Map<String, dynamic>>();
      fetchedTutorias = fetchedTutorias
          .where((tutoria) => tutoria['ID_TUTOR'] == idUsuario)
          .toList();

      // Ordenar las tutorías por fecha de creación (suponiendo que 'FECHA_CREACION' es el campo que indica la fecha de creación)
      fetchedTutorias
          .sort((a, b) => b['FECHA_CREACION'].compareTo(a['FECHA_CREACION']));

      setState(() {
        tutorias = fetchedTutorias;
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
                Expanded(child: misAsignaturas()),
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

  Widget misAsignaturas() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mis Asignaturas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  _dialogAgregarTutoria(context);
                },
                child: Text(
                  'Agregar Tutoría',
                  style: TextStyle(color: Color(0xFF13161c)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
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

  String convertirFormato24Horas(String tiempo12Horas) {
    // Creamos un objeto de formato para el tiempo de 12 horas
    final DateFormat format12Horas = DateFormat('h:mm a');

    // Parseamos el tiempo en formato de 12 horas
    final DateTime dateTime = format12Horas.parse(tiempo12Horas);

    // Creamos un objeto de formato para el tiempo de 24 horas
    final DateFormat format24Horas = DateFormat('HH:mm');

    // Formateamos el tiempo en formato de 24 horas y lo devolvemos
    return format24Horas.format(dateTime);
  }

  // Función para agregar tutoría
  Future<void> addTutoria(BuildContext context) async {
    // Obtener la fecha actual
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Convertir las horas de formato de 12 a 24 antes de enviarlas a la base de datos
    String convertedTime1 = convertirFormato24Horas(selectedTime1);
    String convertedTime2 = convertirFormato24Horas(selectedTime2);
    String convertedTime3 = convertirFormato24Horas(selectedTime3);

    // Construye el cuerpo de la solicitud POST
    Map<String, dynamic> data = {
      'ID_TUTOR': widget.idUsuario,
      'MATERIA': _materiaController.text,
      'HORARIO1': convertedTime1, // Envía TimeSpan en formato de cadena
      'HORARIO2': convertedTime2,
      'HORARIO3': convertedTime3,
      'FECHA_CREACION': formattedDateTime,
    };

    try {
      // Realiza la solicitud POST al servidor
      final response = await http.post(
        Uri.parse('https://localhost:44339/api/tutorias'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        // Si la solicitud fue exitosa, cierra el diálogo y muestra un mensaje
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tutoría agregada exitosamente')),
        );
        // Actualiza la lista de tutorías
        await fetchTutorias(widget.idUsuario);
      } else {
        // Si hubo un error, muestra un mensaje de error en la consola
        print('Failed to add tutoria: ${response.statusCode}');
        // Si hubo un error, muestra un mensaje de error en la consola
        print('Failed to add tutoria: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Si hubo una excepción, muestra un mensaje de error en la consola
      print('Exception adding tutoria: $e');
    }
  }
}

class CourseItem extends StatelessWidget {
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
    final screenWidth = MediaQuery.of(context).size.width;

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
          // Utilizamos un ListView.builder para los horarios y alumnos asignados
          screenWidth <
                  600 // Cambia 600 por el ancho deseado para el tamaño móvil
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: schedules.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        'Horario ${index + 1}: ${convertirFormato12Horas(schedules[index] ?? 'No disponible')}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        assignedStudents[index] != null
                            ? 'Alumno: ${assignedStudents[index]}'
                            : 'Aún no asignado',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                )
              // En caso contrario, mantenemos la representación en fila como está
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < schedules.length; i++)
                      Expanded(
                        child: Container(
                          child: ListTile(
                            title: Text(
                              'Horario ${i + 1}: ${convertirFormato12Horas(schedules[i] ?? 'No disponible')}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              assignedStudents[i] != null
                                  ? 'Alumno: ${assignedStudents[i]}'
                                  : 'Aún no asignado',
                              style: TextStyle(
                                fontSize: 16,
                              ),
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
