import 'package:flutter/material.dart';

class CursosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cursos'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCursoRow('Recomendados para ti', 7),
            SizedBox(height: 50.0),
            _buildCursoRow('Nuevos', 7),
            SizedBox(height: 50.0),
            _buildCursoRow('Matemáticas', 7),
            SizedBox(height: 50.0),
            _buildCursoRow('Desarrollo de Software', 7),
            SizedBox(height: 50.0),
            _buildCursoRow('Inglés', 7),
          ],
        ),
      ),
    );
  }

  Widget _buildCursoRow(String title, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          height: 220.0, // Altura de la fila
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return _buildCursoItem('Curso ${index + 1}');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCursoItem(String nombreCurso) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 300.0, // Ancho de cada card
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.blue, // Colores de ejemplo
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombreCurso,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Descripción del curso...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tutor: ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CursosScreen(),
  ));
}
