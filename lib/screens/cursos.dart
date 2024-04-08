import 'package:flutter/material.dart';

class CursosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      /* appBar: AppBar(
        title: Text('Cursos'),
      ), */
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header(),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
              _buildCursoRow('Recomendados para ti', 7),
              SizedBox(height: 50.0),
              _buildCursoRow('Nuevos', 7),
              SizedBox(height: 50.0),
              _buildCursoRow('Matemáticas', 7),
              SizedBox(height: 50.0),
              _buildCursoRow('Desarrollo de Software', 7),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCursoRow(String title, int count) {
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
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCursoItem('Curso ${index + 1}');
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
                  icon: Icon(Icons.arrow_forward, color: Colors.white,),
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

  Widget _buildCursoItem(String nombreCurso) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 300.0, // Ancho de cada card
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
              'Descripción del curso...',
              style: TextStyle(
                color: Color(0xFF13161c),
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tutor: ',
              style: TextStyle(
                color: Color(0xFF13161c),
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget header() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      'Nombre del usuario Completo',
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CursosScreen(),
  ));
}
