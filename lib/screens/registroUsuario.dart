import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _userType = '';

  List<String> _selectedCategories =
      []; // Asegúrate de que _selectedCategories sea de tipo List<String>

// Declarar una variable para almacenar el número máximo de selecciones permitidas
  int maxSelections = 3;

// Declarar una lista para almacenar las categorías seleccionadas
  List<String> categorias = [
    'CIENCIAS EXACTAS',
    'DESARROLLO DE SOFTWARE',
    'HARDWARE',
    'DISEÑO',
    'ARTES',
    'LITERATURA',
    'IDIOMAS'
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategories = []; // Inicializa la lista aquí
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(context),
    );
  }

  Widget content(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Columna izquierda
        Container(
          padding: EdgeInsets.all(30),
          color: Color(0xFF7ff9cb),
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Agregar imagen aquí
              Image.asset(
                'assets/agregar.png', // Ruta de la imagen en tu proyecto
                width: 500, // Ajusta el tamaño de la imagen según sea necesario
                height: 500,
              ),
            ],
          ),
        ),
        // Columna derecha con formulario
        Container(
          padding: EdgeInsets.all(30),
          color: Color(0xFF13161c),
          width: MediaQuery.of(context).size.width / 2,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 70, horizontal: 30),
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registro de Usuario',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 20.0),
                        // Usuario y Contraseña
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Usuario',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  TextFormField(
                                    controller: _usernameController,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Color del borde cuando está habilitado
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contraseña',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Color del borde cuando está habilitado
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        // Nombre y Apellidos
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nombre',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  TextFormField(
                                    controller: _nameController,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Color del borde cuando está habilitado
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Apellidos',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  TextFormField(
                                    controller: _lastNameController,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Color del borde cuando está habilitado
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        // Correo y Teléfono
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Correo Electrónico',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green,
                                            width:
                                                2.0), // Borde verde al enfocar
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Color del borde cuando está habilitado
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Teléfono',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  TextFormField(
                                    controller: _phoneController,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Color del borde cuando está habilitado
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        // Descripción
                        Text(
                          'Descripción',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .white), // Color del borde cuando está habilitado
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        // Tipo de usuario
                        Row(
                          children: [
                            Text(
                              '¿Qué tipo de usuario eres?',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(width: 20.0),
                            Flexible(
                              child: RadioListTile(
                                title: Text(
                                  'Estudiante',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                value: '1',
                                groupValue: _userType,
                                onChanged: (value) {
                                  setState(() {
                                    _userType = value!;
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: RadioListTile(
                                title: Text(
                                  'Tutor',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                value: '2',
                                groupValue: _userType,
                                onChanged: (value) {
                                  setState(() {
                                    _userType = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        // Opción para seleccionar categoría
                        // Dentro del Column donde seleccionas el tipo de usuario (estudiante o tutor)
                        // Opción para seleccionar categorías
                        if (_userType == '1') // Si es estudiante
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        color: Colors.white, width: 2))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.0),
                                Text(
                                  'Selecciona tus categorías de interés:',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(height: 20.0),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: categorias.length,
                                  itemBuilder: (context, index) {
                                    final category = categorias[index];
                                    return CheckboxListTile(
                                      title: Text(
                                        category,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      value: _selectedCategories!
                                          .contains(category),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value != null && value) {
                                            // Si se selecciona una opción, y aún no se ha alcanzado el límite máximo
                                            if (_selectedCategories.length <
                                                maxSelections) {
                                              _selectedCategories.add(category);
                                            } else {
                                              // Si se intenta seleccionar más de la cantidad máxima permitida, no se permite la selección
                                              // Aquí puedes mostrar un mensaje de advertencia si lo deseas
                                            }
                                          } else {
                                            // Si se deselecciona una opción, eliminarla de la lista
                                            _selectedCategories
                                                .remove(category);
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        SizedBox(height: 20.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text('Registrar',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _crearDatosUsuario(int userId) async {
    try {
      final Map<String, dynamic> userData = {
        'ID_USUARIO': userId,
        'NOMBRE': _nameController.text,
        'APELLIDOS': _lastNameController.text,
        'TELEFONO': _phoneController.text,
        'EMAIL': _emailController.text,
        'DESCRIPCION': _descriptionController.text,
        // Agregar otros campos según tu estructura de datos
      };

      final response = await http.post(
        Uri.parse('https://localhost:44339/api/datosusuario'),
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final datosUsuarioId = responseData['ID_DATOS_USUARIO'];
        print(
            'Datos del usuario agregados exitosamente con ID: $datosUsuarioId');
      } else {
        print('Error al crear datos del usuario: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (error) {
      print('Error al crear datos del usuario: $error');
    }
  }

  Future<void> _enviarCategoriasEstudiante(int userId) async {
    try {
      for (String category in _selectedCategories) {
        final requestData = {
          'ID_USUARIO': userId.toString(),
          'CATEGORIA': category,
        };

        final response = await http.post(
          Uri.parse('https://localhost:44339/api/usuariocategoria'),
          body: json.encode(requestData),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          print(
              'Categoría "$category" enviada exitosamente para el usuario con ID: $userId');
        } else {
          print(
              'Error al enviar la categoría "$category": ${response.statusCode}');
          print('Cuerpo de la respuesta: ${response.body}');
        }
      }
    } catch (error) {
      print('Error al enviar categorías: $error');
    }
  }

  Future<void> _crearTutor(int userId) async {
    // Envía los datos del usuario, que en este caso es un tutor
    await _crearDatosUsuario(userId);
    print('Tutor agregado exitosamente');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Primero crea el usuario y espera su respuesta
        final userId = await _crearUsuario();
        if (userId != null) {
          // Envía los datos del usuario (datosusuario) para estudiantes y tutores
          await _crearDatosUsuario(userId);

          if (_userType == '1') {
            // Si el usuario es un estudiante, enviar las categorías seleccionadas
            await _enviarCategoriasEstudiante(userId);
          } else if (_userType == '2') {
            // Si el usuario es un tutor, crear el tutor
            await _crearTutor(userId);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Usuario agregado exitosamente'),
            ),
          );
          Navigator.of(context).pop(true); // Indica que se agregó correctamente
        }
      } catch (error) {
        print('Error al enviar formulario: $error');
        // Manejar cualquier error que ocurra durante el envío del formulario
      }
    }
  }

  Future<void> _enviarCategorias(int userId) async {
    try {
      for (String category in _selectedCategories) {
        final requestData = {
          'ID_USUARIO': userId.toString(),
          'CATEGORIA': category,
        };

        final response = await http.post(
          Uri.parse('https://localhost:44339/api/usuariocategoria'),
          body: json.encode(requestData),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          print(
              'Categoría "$category" enviada exitosamente para el usuario con ID: $userId');
        } else {
          print(
              'Error al enviar la categoría "$category": ${response.statusCode}');
          print('Cuerpo de la respuesta: ${response.body}');
        }
      }
    } catch (error) {
      print('Error al enviar categorías: $error');
    }
  }

  Future<int?> _crearUsuario() async {
    try {
      final Map<String, dynamic> userData = {
        'USUARIO': _usernameController.text,
        'PASSWORD': _passwordController.text,
        'ID_TIPO_USUARIO': _userType, // Ajusta según tu estructura de datos
      };

      final response = await http.post(
        Uri.parse('https://localhost:44339/api/usuarios'),
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['ID_USUARIO'];
      } else {
        print('Error al crear usuario: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error al crear usuario: $error');
      return null;
    }
  }

  Future<void> _crearEstudiante(int userId) async {
    try {
      final Map<String, dynamic> estudianteData = {
        'ID_USUARIO': userId,
        // Agrega aquí los campos específicos del estudiante
        // Por ejemplo:
        'NOMBRE': _nameController.text,
        'APELLIDOS': _lastNameController.text,
        'TELEFONO': _phoneController.text,
        'EMAIL': _emailController.text,
        'DESCRIPCION': _descriptionController.text,
        // Agrega otros campos según tu estructura de datos
      };

      // Añade un print para verificar los datos del estudiante antes de la solicitud HTTP
      print('Datos del estudiante: $estudianteData');

      final response = await http.post(
        Uri.parse('https://localhost:44339/api/datosusuario'),
        body: json.encode(estudianteData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final estudianteId = responseData['ID_DATOS_USUARIO'];
        print('Estudiante agregado exitosamente con ID: $estudianteId');
      } else {
        print('Error al crear estudiante: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (error) {
      print('Error al crear estudiante: $error');
    }
  }
}
