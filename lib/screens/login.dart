import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:coursehub/screens/estudiante/homeEstudiante.dart';
import '../navigation_railEstudiante.dart';
import '../navigation_railTutor.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;
  late int _userId; // Agregamos una variable para almacenar el ID del usuario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return Container(
      color: Color(0xFF001D82),
      child: Center(
        child: Container(
          width: 500,
          height: 500,
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 150,
              ),
              SizedBox(height: 50),
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
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Iniciar sesión',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final usersUrl = Uri.parse('https://localhost:44339/api/usuarios');
    final userDataUrl = Uri.parse('https://localhost:44339/api/datosusuario');
    final userTypeUrl = Uri.parse('https://localhost:44339/api/tipousuario');

    try {
      setState(() {
        _isLoading = true;
      });

      final usersResponse = await http.get(usersUrl);
      final userDataResponse = await http.get(userDataUrl);
      final userTypeResponse = await http.get(userTypeUrl);

      if (usersResponse.statusCode == 200 &&
          userDataResponse.statusCode == 200) {
        final List<dynamic> usuarios = jsonDecode(usersResponse.body);
        final List<dynamic> userData = jsonDecode(userDataResponse.body);
        final List<dynamic> userTypes = jsonDecode(userTypeResponse.body);

        for (final usuario in usuarios) {
          final String usuarioNombre = usuario['USUARIO'];
          final String pass = usuario['PASSWORD'];
          final int userId = usuario['ID_USUARIO'];
          final String tipoUsuarioString = usuario['ID_TIPO_USUARIO'];
          final int userTypeId = int.tryParse(tipoUsuarioString) ?? 0;

          if (usuarioNombre == username && pass == password) {
            await Future.delayed(Duration(seconds: 1));

            // Almacenar el ID del usuario correspondiente
            _userId = userId;

            // Buscar la descripción del tipo de usuario
            //Buscar coincidencia en id
            String userTypeDescription = '';
            for (final userType in userTypes) {
              final int typeId = userType['ID_TIPO_USUARIO'];
              if (typeId == userTypeId) {
                userTypeDescription = userType['DESCRIPCION'];
                break;
              }
            }

            // Buscar el nombre del usuario correspondiente al ID_USUARIO
            String nombre = '';
            for (final userDataItem in userData) {
              if (userDataItem['ID_USUARIO'] == userId) {
                nombre = userDataItem['NOMBRE'];
                break;
              }
            }

            // Redirigir según el tipo de usuario
            if (userTypeId == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationRailEScreen(
                    nombre: nombre,
                    tipoUsuario: userTypeDescription,
                    idUsuario: _userId,
                  ),
                ),
              );
            } else if (userTypeId == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationRailTScreen(
                    nombre: nombre,
                    tipoUsuario: userTypeDescription,
                    idUsuario: _userId,
                  ),
                ),
              );
            }

            setState(() {
              _errorMessage = 'Correcto';
            });
            return;
          }
        }

        // Si no se encuentra un usuario con las credenciales proporcionadas
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          _errorMessage = 'Credenciales incorrectas';
        });
      } else {
        setState(() {
          _errorMessage = 'Error en la solicitud';
        });
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      setState(() {
        _errorMessage = 'Error en la solicitud';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
