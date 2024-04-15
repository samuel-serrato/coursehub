import 'package:flutter/material.dart';

import '../navigation_railEstudiante.dart';
import '../navigation_railTutor.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(context),
    );
  }

  Widget content(BuildContext context) {
    return MediaQuery.of(context).size.width > 600
        ? Row(
            children: [
              Container(
                color: Color(0xFF7ff9cb),
                width: MediaQuery.of(context).size.width / 2,
                child: const Center(
                  child: Text(
                    'Imagen',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFF13161c),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Color(0xFF13161c),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: LoginForm(),
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Color(0xFF7ff9cb),
                child: const Center(
                  child: Text(
                    'Imagen',
                    style: TextStyle(
                        fontSize: 24.0, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Color(0xFF13161c),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: LoginForm(),
                  ),
                ),
              ),
            ],
          );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
   final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    String user = _userController.text;
    String password = _passwordController.text;

    if (user == '1' && password == '1') {
      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavigationRailEScreen()),
                            );
    } else if (user == '2' && password == '2') {
      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavigationRailTScreen()),
                            );
    } else {
      // Aquí puedes manejar el caso en que las credenciales sean incorrectas
      // Por ejemplo, mostrar un mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text('Usuario o contraseña incorrectos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                'Coursehub',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Usuario',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: _userController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.person),
            hintText: 'Ingrese su usuario',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
        ),
        SizedBox(height: 20.0),
        Text(
          'Contraseña',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.lock),
            hintText: 'Ingrese su contraseña',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
        ),
        SizedBox(height: 20.0),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFF7ff9cb),
              ),
            ),
            onPressed: () => _login(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
