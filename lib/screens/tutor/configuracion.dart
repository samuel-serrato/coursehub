import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              header(context),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
              ),
              SizedBox(height: 20),
              Text(
                'Información del perfil',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Nombre: Usuario Ejemplo',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Correo: usuario@example.com',
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
                          'Nombre de usuario',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        Text(
                          'Tipo de usuario',
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
