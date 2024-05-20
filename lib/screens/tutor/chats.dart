import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatefulWidget {
  final String nombre; //nombreusuarioactual
  final String tipoUsuario;
  final int idUsuario;

  @override
  _ChatsScreenState createState() => _ChatsScreenState();

  ChatsScreen({
    required this.nombre,
    required this.tipoUsuario,
    required this.idUsuario,
  });
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Tutoria> _listaTutorias = [];
  List<Chats> _listaChats = [];
  Map<int, Map<String, dynamic>> usuarios = {};
  List<Mensajes> _listaMensajes = [];
  int? _selectedTutoriaId;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    obtenerTutorias();
    fetchDatosUsuario();
    obtenerMensajesPeriodicamente();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(String timeString) {
    DateTime time = DateFormat('HH:mm:ss').parse(timeString);
    return DateFormat('hh:mm a').format(time);
  }

  Future<void> obtenerTutorias() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44339/api/tutorias'));
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        setState(() {
          _listaTutorias = (parsedJson as List)
              .map((item) => Tutoria(
                    idTutoria: item['ID_TUTORIA'],
                    idTutor: item['ID_TUTOR'],
                    materia: item['MATERIA'],
                    fechaCreacion: item['FECHA_CREACION'].toString(),
                    horario1: item['HORARIO1']?.toString(),
                    horario2: item['HORARIO2']?.toString(),
                    horario3: item['HORARIO3']?.toString(),
                    idAlumno1: item['ID_ALUMNO1'],
                    idAlumno2: item['ID_ALUMNO2'],
                    idAlumno3: item['ID_ALUMNO3'],
                  ))
              .toList();
          _listaTutorias
              .sort((a, b) => a.fechaCreacion.compareTo(b.fechaCreacion));
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  /* List<Tutoria> filtrarTutorias(int idUsuario) {
    return _listaTutorias.where((tutoria) {
      return tutoria.idTutor == idUsuario;
    }).toList();
  } */

  List<Tutoria> filtrarTutorias(List<Tutoria> tutorias, int idUsuario) {
    return tutorias.where((tutoria) {
      return (tutoria.idAlumno1 != null &&
              tutoria.horario1 != null &&
              tutoria.idTutor == idUsuario) ||
          (tutoria.idAlumno2 != null &&
              tutoria.horario2 != null &&
              tutoria.idTutor == idUsuario) ||
          (tutoria.idAlumno3 != null &&
              tutoria.horario3 != null &&
              tutoria.idTutor == idUsuario);
    }).toList();
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
        ? '${usuarios[id]!['NOMBRE']} ${usuarios[id]!['APELLIDOS']}'
        : 'Desconocido';
  }

  Future<void> obtenerMensajes() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44339/api/mensajes'));
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        setState(() {
          _listaMensajes = (parsedJson as List)
              .map((item) => Mensajes(
                    idMensaje: item['ID_MENSAJE'],
                    idUsuario: item['ID_USUARIO'],
                    idChat: item['ID_TUTORIA'],
                    mensaje: item['MENSAJE'],
                    fecha: item['FECHA_CREACION'],
                  ))
              .toList();
          _listaMensajes.sort((a, b) => b.fecha.compareTo(a.fecha));
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void obtenerMensajesPeriodicamente() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      obtenerMensajes();
    });
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

  String _getUltimoMensaje(int idTutoria) {
    final mensajesFiltrados =
        _listaMensajes.where((mensaje) => mensaje.idChat == idTutoria).toList();
    if (mensajesFiltrados.isNotEmpty) {
      final ultimoMensaje = mensajesFiltrados.first;
      final nombreUsuario = usuarios[ultimoMensaje.idUsuario] != null
          ? '${usuarios[ultimoMensaje.idUsuario]!['NOMBRE']} ${usuarios[ultimoMensaje.idUsuario]!['APELLIDOS']}'
          : 'Desconocido';
      return '${nombreUsuario}: ${ultimoMensaje.mensaje}';
    } else {
      return 'No hay mensajes';
    }
  }

  @override
  Widget build(BuildContext context) {
    //List<Tutoria> tutoriasFiltradas = filtrarTutorias(widget.idUsuario);

    List<Tutoria> tutoriasFiltradas =
        filtrarTutorias(_listaTutorias, widget.idUsuario);

    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      body: usuarios.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                header(context),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // Modo desktop
                        return desktopView();
                      } else {
                        // Modo móvil
                        return mobileView();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget desktopView() {
    List<Tutoria> tutoriasFiltradas =
        filtrarTutorias(_listaTutorias, widget.idUsuario);

    String obtenerHorarioMostrar(Tutoria tutoria) {
      if (tutoria.idAlumno1 != null && tutoria.horario1 != null) {
        return tutoria.horario1!;
      } else if (tutoria.idAlumno2 != null && tutoria.horario2 != null) {
        return tutoria.horario2!;
      } else if (tutoria.idAlumno3 != null && tutoria.horario3 != null) {
        return tutoria.horario3!;
      } else {
        return 'No asignado';
      }
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: tutoriasFiltradas.length,
            itemBuilder: (context, index) {
              final tutoria = tutoriasFiltradas[index];
              String horarioMostrar = obtenerHorarioMostrar(tutoria);

              // Obtener el ID del alumno correspondiente
              int? idAlumno;
              if (tutoria.idAlumno1 != null && tutoria.horario1 != null) {
                idAlumno = tutoria.idAlumno1;
              } else if (tutoria.idAlumno2 != null &&
                  tutoria.horario2 != null) {
                idAlumno = tutoria.idAlumno2;
              } else if (tutoria.idAlumno3 != null &&
                  tutoria.horario3 != null) {
                idAlumno = tutoria.idAlumno3;
              }

              return Card(
                color: _selectedTutoriaId == tutoria.idTutoria
                    ? Colors.grey[800]
                    : Color(0xFF13161c),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tutoria.materia} - ${buscarNombreDeUsuario(idAlumno!)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Horario: ${horarioMostrar != null ? formatTime(horarioMostrar) : 'No asignado'}',
                        style:
                            TextStyle(color: Color(0xFF7ff9cb), fontSize: 14.0),
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                  subtitle: Text(
                    'Último mensaje: ${_getUltimoMensaje(tutoria.idTutoria)}',
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedTutoriaId = tutoria.idTutoria;
                    });
                  },
                ),
              );
            },
          ),
        ),
        VerticalDivider(
          color: Colors.white,
          width: 1,
        ),
        Expanded(
          flex: 2,
          child: _selectedTutoriaId != null
              ? Column(
                  children: [
                    Expanded(
                      child: ChatScreen(
                        // Pasar los parámetros necesarios al ChatScreen
                        nombreAlumno: widget.nombre,
                        nombreTutor: buscarNombreDeUsuario(tutoriasFiltradas
                            .firstWhere((tutoria) =>
                                tutoria.idTutoria == _selectedTutoriaId!)
                            .idTutor),
                        idTutoria: _selectedTutoriaId!,
                        listaMensajes: _listaMensajes,
                        usuarios: usuarios,
                        idEstudiante: widget.idUsuario,
                        tutoria: tutoriasFiltradas.firstWhere((tutoria) =>
                            tutoria.idTutoria ==
                            _selectedTutoriaId!), // Pasar una sola tutoría aquí
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'Selecciona una tutoría para ver el chat.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ],
    );
  }

  Widget mobileView() {
    List<Tutoria> tutoriasFiltradas =
        filtrarTutorias(_listaTutorias, widget.idUsuario);

    String obtenerHorarioMostrar(Tutoria tutoria) {
      if (tutoria.idAlumno1 != null && tutoria.horario1 != null) {
        return tutoria.horario1!;
      } else if (tutoria.idAlumno2 != null && tutoria.horario2 != null) {
        return tutoria.horario2!;
      } else if (tutoria.idAlumno3 != null && tutoria.horario3 != null) {
        return tutoria.horario3!;
      } else {
        return 'No asignado';
      }
    }

    return ListView.builder(
      itemCount: tutoriasFiltradas.length,
      itemBuilder: (context, index) {
        final tutoria = tutoriasFiltradas[index];
        String horarioMostrar = obtenerHorarioMostrar(tutoria);

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutoria.materia,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Último mensaje: ${_getUltimoMensaje(tutoria.idTutoria)}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          subtitle: Text(
            'Horario: ${horarioMostrar != null ? formatTime(horarioMostrar) : 'No asignado'}',
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                    nombreAlumno: widget.nombre,
                    nombreTutor: buscarNombreDeUsuario(tutoria.idTutor),
                    idTutoria: tutoria.idTutoria,
                    listaMensajes: _listaMensajes,
                    usuarios: usuarios,
                    idEstudiante: widget.idUsuario,
                    tutoria: tutoria),
              ),
            );
          },
        );
      },
    );
  }
}

class Tutoria {
  final int idTutoria;
  final int idTutor;
  final String materia;
  final String fechaCreacion;
  final String? horario1;
  final String? horario2;
  final String? horario3;
  final int? idAlumno1;
  final int? idAlumno2;
  final int? idAlumno3;

  Tutoria({
    required this.idTutoria,
    required this.idTutor,
    required this.materia,
    required this.fechaCreacion,
    this.horario1,
    this.horario2,
    this.horario3,
    this.idAlumno1,
    this.idAlumno2,
    this.idAlumno3,
  });
}

class Chats {
  final int idChat;
  final int estudiante;
  final String tutor;
  final int idTutoria;

  Chats({
    required this.idChat,
    required this.estudiante,
    required this.tutor,
    required this.idTutoria,
  });
}

class ChatScreen extends StatefulWidget {
  final String nombreAlumno;
  final String nombreTutor;
  final int idTutoria;
  final List<Mensajes> listaMensajes;
  final Map<int, Map<String, dynamic>> usuarios;
  final int idEstudiante;
  final Tutoria tutoria; // Nuevo parámetro

  ChatScreen({
    required this.idEstudiante,
    required this.nombreAlumno,
    required this.nombreTutor,
    required this.idTutoria,
    required this.listaMensajes,
    required this.usuarios,
    required this.tutoria, // Nuevo parámetro
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _mensajeController = TextEditingController();
  Timer? _timer;
  List<Mensajes> _listaMensajes = [];

  void _enviarMensaje(String mensaje) async {
    if (mensaje.isEmpty) {
      return;
    }

    final url = Uri.parse('https://localhost:44339/api/mensajes');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'ID_USUARIO': widget.idEstudiante,
      'ID_TUTORIA': widget.idTutoria,
      'MENSAJE': mensaje,
      'FECHA_CREACION': DateTime.now().toIso8601String(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        setState(() {
          widget.listaMensajes.add(Mensajes(
            idMensaje: json.decode(response.body)['ID_MENSAJE'],
            idUsuario: widget.idEstudiante,
            idChat: widget.idTutoria,
            mensaje: mensaje,
            fecha: DateTime.now().toIso8601String(),
          ));
          widget.listaMensajes.sort((a, b) => b.fecha.compareTo(a.fecha));
        });
        _mensajeController.clear();
        FocusScope.of(context).unfocus();
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  String buscarNombreDeUsuario(int? id) {
    if (id == null) return 'Desconocido';
    return widget.usuarios[id] != null
        ? '${widget.usuarios[id]!['NOMBRE']} ${widget.usuarios[id]!['APELLIDOS']}'
        : 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    final mensajesFiltrados = widget.listaMensajes
        .where((mensaje) => mensaje.idChat == widget.idTutoria)
        .toList();

    // Obtener el ID del alumno correspondiente a la tutoría actual
    final int? idAlumno = widget.tutoria.idAlumno1 ??
        widget.tutoria.idAlumno2 ??
        widget.tutoria.idAlumno3;
    final nombreAlumno = buscarNombreDeUsuario(idAlumno);

    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 14, 16, 20),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '${widget.tutoria.materia ?? 'Desconocido'} - ${nombreAlumno ?? 'Desconocido'}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: mensajesFiltrados.length,
              itemBuilder: (context, index) {
                final mensaje = mensajesFiltrados[index];
                final esEstudiante = mensaje.idUsuario == widget.idEstudiante;
                final nombreUsuario = widget.usuarios[mensaje.idUsuario] != null
                    ? '${widget.usuarios[mensaje.idUsuario]!['NOMBRE']} ${widget.usuarios[mensaje.idUsuario]!['APELLIDOS']}'
                    : 'Desconocido';

                return Align(
                  alignment: esEstudiante
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: esEstudiante
                          ? Color.fromARGB(255, 71, 210, 157)
                          : Colors.grey[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: esEstudiante
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombreUsuario,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          mensaje.mensaje,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          DateFormat('hh:mm a')
                              .format(DateTime.parse(mensaje.fecha)),
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          messageInput(),
        ],
      ),
    );
  }

  Widget messageInput() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (mensaje) {
                _enviarMensaje(mensaje);
              },
              controller: _mensajeController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              _enviarMensaje(_mensajeController.text);
            },
          ),
        ],
      ),
    );
  }
}

class Mensajes {
  final int idMensaje;
  final int idUsuario;
  final int idChat;
  final String mensaje;
  final String fecha;

  Mensajes({
    required this.idMensaje,
    required this.idUsuario,
    required this.idChat,
    required this.mensaje,
    required this.fecha,
  });
}
