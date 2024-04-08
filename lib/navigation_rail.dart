import 'package:coursehub/screens/chats.dart';
import 'package:coursehub/screens/configuracion.dart';
import 'package:coursehub/screens/cursos.dart';
import 'package:coursehub/screens/home.dart';
import 'package:flutter/material.dart';

class NavigationRailScreen extends StatefulWidget {
  @override
  _NavigationRailScreenState createState() => _NavigationRailScreenState();
}

class _NavigationRailScreenState extends State<NavigationRailScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CursosScreen(),
    ChatsScreen(),
    ConfiguracionScreen()
  ];

  @override
  Widget build(BuildContext context) {
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
                selectedIcon: Icon(Icons.home, color: Colors.white ),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book, color: Color.fromARGB(255, 223, 223, 223)),
                selectedIcon: Icon(Icons.book, color: Colors.white),
                label: Text('Cursos'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat_sharp, color: Color.fromARGB(255, 223, 223, 223)),
                selectedIcon: Icon(Icons.chat_sharp, color: Colors.white),
                label: Text('Chats'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings, color: Color.fromARGB(255, 223, 223, 223)),
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
}
