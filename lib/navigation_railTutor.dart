import 'package:coursehub/screens/tutor/chats.dart';
import 'package:coursehub/screens/tutor/configuracion.dart';
import 'package:coursehub/screens/tutor/cursos.dart';
import 'package:coursehub/screens/tutor/homeTutor.dart';
import 'package:flutter/material.dart';

class NavigationRailTScreen extends StatefulWidget {
  final String nombre; // Nuevo
  final String tipoUsuario; // Nuevo
  final int idUsuario; // Agregamos el ID del usuario aquí

  @override
  _NavigationRailTScreenState createState() => _NavigationRailTScreenState();

  NavigationRailTScreen(
      {required this.nombre,
      required this.tipoUsuario,
      required this.idUsuario});
}

class _NavigationRailTScreenState extends State<NavigationRailTScreen> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions = <Widget>[
    HomeScreen(
      nombre: widget.nombre,
      tipoUsuario: widget.tipoUsuario,
      idUsuario: widget
          .idUsuario, // Asegúrate de obtener el ID del usuario actual aquí
    ),
    //CursosScreen(),
    ChatsScreen(nombre: widget.nombre, tipoUsuario: widget.tipoUsuario),
    ConfiguracionScreen(
      nombre: widget.nombre,
      tipoUsuario: widget.tipoUsuario,
      idUsuario: widget.idUsuario,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          // Si el ancho de la pantalla es menor o igual a 600 (típicamente considerado como tamaño móvil)
          // mostrar BottomNavigationBar
          return Scaffold(
            body: _widgetOptions.elementAt(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor:
                  Color(0xFF13161c), // Color de fondo similar al NavigationRail
              selectedItemColor: Colors.white, // Color de ícono seleccionado
              unselectedItemColor:
                  Color(0xFF5A5A5A), // Color de ícono no seleccionado
              selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.bold), // Estilo de texto seleccionado
              unselectedLabelStyle: TextStyle(
                  fontWeight:
                      FontWeight.bold), // Estilo de texto no seleccionado
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                /* BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Cursos',
                ), */
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_sharp),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Configuracion',
                ),
              ],
            ),
          );
        } else {
          // Si el ancho de la pantalla es mayor que 600, mostrar NavigationRail
          return Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  elevation: 5,
                  minWidth: 100,
                  labelType: NavigationRailLabelType.all,
                  selectedLabelTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  unselectedLabelTextStyle: TextStyle(
                      color: Color(0xFF5A5A5A), fontWeight: FontWeight.bold),
                  backgroundColor: Color(0xFF13161c),
                  indicatorColor: Color(0xFF1d2029),
                  useIndicator: true,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.home,
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                      selectedIcon: Icon(Icons.home, color: Colors.white),
                      label: Text('Home'),
                    ),
                    /* NavigationRailDestination(
                      icon: Icon(Icons.book,
                          color: Color.fromARGB(255, 223, 223, 223)),
                      selectedIcon: Icon(Icons.book, color: Colors.white),
                      label: Text('Cursos'),
                    ), */
                    NavigationRailDestination(
                      icon: Icon(Icons.chat_sharp,
                          color: Color.fromARGB(255, 223, 223, 223)),
                      selectedIcon: Icon(Icons.chat_sharp, color: Colors.white),
                      label: Text('Chats'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings,
                          color: Color.fromARGB(255, 223, 223, 223)),
                      selectedIcon: Icon(Icons.settings, color: Colors.white),
                      label: Text('Configuracion'),
                    ),
                  ],
                ),
                Expanded(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
