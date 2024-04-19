import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfiguracionScreen extends StatefulWidget {
  final String nombre;
  final String tipoUsuario;
  final int idUsuario; // Agregamos el ID del usuario aquí

  ConfiguracionScreen({
    required this.nombre,
    required this.tipoUsuario,
    required this.idUsuario,
  });

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  String? _correo = '';
  String? _apellidos = '';
  String? _telefono = '';
  String? _descripcion = '';

  @override
  void initState() {
    super.initState();
    _cargarInformacionUsuario();
  }

  Future<void> _cargarInformacionUsuario() async {
    final url = Uri.parse('https://localhost:44339/api/datosusuario');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> datosUsuarios = jsonDecode(response.body);

      // Buscar el usuario actual por su ID_USUARIO
      final usuarioActual = datosUsuarios.firstWhere(
        (usuario) => usuario['ID_USUARIO'] == widget.idUsuario,
        orElse: () => null,
      );

      if (usuarioActual != null) {
        setState(() {
          _apellidos = usuarioActual['APELLIDOS'];
          _correo = usuarioActual['EMAIL'];
          _telefono = usuarioActual['TELEFONO'];
          _descripcion = usuarioActual['DESCRIPCION'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Resto del código de la pantalla de configuración
              header(context),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Información del perfil',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Nombre: ${widget.nombre}  ${_apellidos}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tipo de Usuario: ${widget.tipoUsuario}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Correo: ${_correo ?? "Cargando..."}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'Teléfono: ${_telefono ?? "Cargando..."}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'Descripción: ${_descripcion ?? "Cargando..."}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Acción para editar perfil
                            },
                            child: Text(
                              'Editar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white),
              ListTile(
                leading: Icon(Icons.language, color: Colors.white),
                title: Text(
                  'Idioma',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Acción para cambiar idioma
                },
              ),

              Divider(color: Colors.white),
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.white),
                title: Text('Notificaciones',
                    style: TextStyle(color: Colors.white)),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Acción para configurar notificaciones
                },
              ),
              Divider(color: Colors.white),
              // Añade más ListTile según tus opciones de configuración
            ],
          ),
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
