import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Agregamos esta importación

class CursosScreen extends StatefulWidget {
  final String nombre; // Nuevo
  final String tipoUsuario; // Nuevo
  final int idUsuario;

  @override
  State<CursosScreen> createState() => _CursosScreenState();

  CursosScreen(
      {required this.nombre,
      required this.tipoUsuario,
      required this.idUsuario});
}

class _CursosScreenState extends State<CursosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<Map<String, dynamic>> tutorias = []; // Nueva lista de tutorías
  Map<int, Map<String, dynamic>> usuarios =
      {}; // Almacena el nombre y apellido del usuario por ID

  List<bool> _horarioSeleccionado = [
    false,
    false,
    false
  ]; // Estado de selección de horarios

  @override
  void initState() {
    super.initState();
    fetchTutorias(); // Llama a fetchTutorias al iniciar la pantalla
    fetchDatosUsuario();
  }

  Future<void> fetchTutorias() async {
    final response =
        await http.get(Uri.parse('https://localhost:44339/api/tutorias'));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> fetchedTutorias =
          json.decode(response.body).cast<Map<String, dynamic>>();

      // Ordenar las tutorías por fecha de creación
      fetchedTutorias
          .sort((a, b) => b['FECHA_CREACION'].compareTo(a['FECHA_CREACION']));

      // Limitar la cantidad de tutorías a las últimas 5
      fetchedTutorias = fetchedTutorias.take(5).toList();

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

  void _seleccionarHorario(int index, int cursoIndex) async {
    setState(() {
      _horarioSeleccionado[index] = true;
    });
    final tutoriaId = tutorias[cursoIndex]['ID_TUTORIA'];
    try {
      final response = await http.put(
        Uri.parse('https://localhost:44339/api/tutorias/$tutoriaId'),
        body: json.encode({
          if (index == 0) 'ID_ALUMNO1': widget.idUsuario.toString(),
          if (index == 1) 'ID_ALUMNO2': widget.idUsuario.toString(),
          if (index == 2) 'ID_ALUMNO3': widget.idUsuario.toString(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        fetchTutorias();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al reservar el horario'),
        ));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al realizar la solicitud'),
      ));
    }
  }

  void _mostrarConfirmacion(BuildContext context, int index, int cursoIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Est seguro de que quiere reservar este horario?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    ).then((confirmado) {
      if (confirmado != null && confirmado) {
        _seleccionarHorario(index, cursoIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      /* appBar: AppBar(
        title: Text('Cursos'),
      ), */
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header(context),
              search(),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  /* _buildCursoRow('Recomendados para tii', 7),
                  SizedBox(height: 50.0), */
                  _buildCursoRow('Nuevos'),
/*                   SizedBox(height: 50.0),
                  _buildCursoRow('Matemáticas', 7),
                  SizedBox(height: 50.0),
                  _buildCursoRow('Desarrollo de Software', 7), */
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCursoRow(String title) {
    ScrollController _scrollController = ScrollController();

    void _scroll(bool forward) {
      final double scrollDistance = forward ? 400.0 : -400.0;
      _scrollController.animateTo(
        _scrollController.offset + scrollDistance,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 220.0, // Altura de la fila
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: tutorias.length, // Usar la cantidad de tutorías
                itemBuilder: (BuildContext context, int index) {
                  final tutoria = tutorias[index];
                  final courseName = tutoria['MATERIA'] ?? 'Sin materia';
                  final tutorName = buscarNombreDeUsuario(
                          tutoria['ID_TUTOR']) ??
                      'Sin tutor'; // Modificar según la estructura de tus datos
                  // Construir el item de curso utilizando los datos de la tutoría
                  final category =
                      tutoria['CATEGORIA'] ?? 'Sin categoría'; // Nueva línea
                  final List<String> horarios = [
                    tutoria['HORARIO1'] ?? 'No disponible',
                    tutoria['HORARIO2'] ?? 'No disponible',
                    tutoria['HORARIO3'] ?? 'No disponible',
                  ];
                  final List<bool> horariosOcupados = [
                    tutoria['ID_ALUMNO1'] != null,
                    tutoria['ID_ALUMNO2'] != null,
                    tutoria['ID_ALUMNO3'] != null,
                  ];
                  return _buildCursoItem(courseName, tutorName, category,
                      horarios, horariosOcupados, index);
                },
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(221, 46, 46, 46),
                ),
                child: IconButton(
                  hoverColor: Colors.transparent,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    _scroll(false); // Scroll hacia la izquierda
                  },
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(221, 46, 46, 46),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scroll(true); // Scroll hacia la derecha
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

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

  Widget _buildCursoItem(String nombreCurso, String tutorName, String category,
      List<String> horarios, List<bool> horariosOcupados, int cursoIndex) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 350.0, // Ancho de cada card
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xFF7ff9cb),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombreCurso,
              style: TextStyle(
                color: Color(0xFF13161c),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tutor: $tutorName', // Mostrar el nombre del tutor
              style: TextStyle(
                color: Color(0xFF13161c),
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Horarios:', // Agregar título para los horarios
              style: TextStyle(
                color: Color(0xFF13161c),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(horarios.length, (index) {
                final horario = horarios[index];
                return ElevatedButton(
                  onPressed: horario != null && !horariosOcupados[index]
                      ? () => _mostrarConfirmacion(context, index, cursoIndex)
                      : null,
                  child: Text(
                    horario != null
                        ? convertirFormato12Horas(horario)
                        : 'No disponible',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: horariosOcupados[index]
                        ? MaterialStateProperty.all(Colors.grey)
                        : MaterialStateProperty.all(
                            Color.fromARGB(255, 1, 83, 51)),
                  ),
                );
              }),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    fontSize: 14,
                  ),
                ),
              ],
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

  Widget search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  hintText: 'Buscar...',
                  hintStyle: TextStyle(color: Colors.white),
                  fillColor: Color(0xFF13161c),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF7ff9cb),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(width: 10.0),
        ],
      ),
    );
  }
}
