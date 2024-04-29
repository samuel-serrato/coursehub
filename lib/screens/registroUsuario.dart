import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints:
                BoxConstraints(maxWidth: 600), // Ancho máximo del contenedor
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Datos de Usuario',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Datos de Personales',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Apellidos',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('¿Qué tipo de usuario eres?'),
                      Flexible(
                        child: RadioListTile(
                          title: Text('Estudiante'),
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
                          title: Text('Tutor'),
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Registrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Primero crea el usuario y espera su respuesta
        final userId = await _crearUsuario();
        if (userId != null) {
          // Si se crea el usuario correctamente, crea el tutor asociado
          await _crearTutor(userId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tutor agregado exitosamente'),
            ),
          );
          //Navigator.of(context).pop(true); // Indica que se agregó correctamente
        }
      } catch (error) {
        print('Error al enviar formulario: $error');
        // Manejar cualquier error que ocurra durante el envío del formulario
      }
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

  Future<void> _crearTutor(int userId) async {
    try {
      final Map<String, dynamic> tutorData = {
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
        body: json.encode(tutorData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final tutorId = responseData[
            'ID_DATOS_USUARIO']; // Ajusta según tu estructura de datos
        print('Tutor agregado exitosamente con ID: $tutorId');
        // Retornar el ID del tutor agregado y regresar a la pantalla anterior
        Navigator.of(context)
            .pop({'id': tutorId, 'nombre': _nameController.text});

        print('Tutor agregado exitosamente');
      } else {
        print('Error al crear tutor: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (error) {
      print('Error al crear tutor: $error');
    }
  }
}
