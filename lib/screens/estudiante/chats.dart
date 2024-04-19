import 'package:flutter/material.dart';

// Clase para representar un mensaje
class Message {
  final String sender;
  final String text;

  Message(this.sender, this.text);
}

// Clase para representar un chat
class Chat {
  final String name;
  final List<Message> messages;

  Chat(this.name, this.messages);
}

class ChatsScreen extends StatefulWidget {
  final String nombre; // Nuevo
  final String tipoUsuario; // Nuevo

  @override
  _ChatsScreenState createState() => _ChatsScreenState();

  ChatsScreen({required this.nombre, required this.tipoUsuario});
}

class _ChatsScreenState extends State<ChatsScreen> {
  Chat? selectedChat;
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();

  List<Chat> chats = [
    Chat('Nombre del chat 1', [
      Message('Yo', 'Hola'),
      Message('Otro usuario', 'Hola, ¿cómo estás?'),
    ]),
    Chat('Nombre del chat 2', [
      Message('Yo', '¡Hola!'),
      Message('Otro usuario', '¿Qué tal?'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF13161c),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Vista de escritorio
            return Column(
              children: [
                header(context),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 1,
                        child: chatList(),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: selectedChat != null
                            ? content()
                            : Center(
                                child: Text('Selecciona un chat',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20))),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Vista móvil
            return Column(
              children: [
                header(context),
                Expanded(child: selectedChat != null ? content() : chatList()),
              ],
            );
          }
        },
      ),
    );
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                setState(() {
                  selectedChat = null;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                selectedChat!.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true, // Invierte el orden de los mensajes
                    itemCount: selectedChat!.messages.length,
                    itemBuilder: (context, index) {
                      final message = selectedChat!.messages[index];
                      return Container(
                        alignment: message.sender == 'Yo'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: message.sender == 'Yo'
                                  ? Color.fromARGB(255, 90, 223, 172)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                messageInput(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget chatList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          right:
              BorderSide(color: Colors.white), // Agrega un borde a la derecha
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              'Chats',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      selectedChat = chat;
                    });
                  },
                  title: Text(chat.name, style: TextStyle(color: Colors.white)),
                  subtitle: Text(chat.messages.first.text,
                      style: TextStyle(color: Colors.white)),
                  tileColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  shape: Border(
                      bottom: BorderSide(
                          color: Colors
                              .white)), // Agrega un borde blanco solo abajo
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget messageInput() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: messageFocusNode,
              onSubmitted: (message) {
                _sendMessage(
                    message); // Llama a una función para enviar el mensaje
              },
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              // Aquí puedes enviar el mensaje
              String message = messageController.text;
              messageController.clear();
              // Lógica para enviar el mensaje
              if (selectedChat != null) {
                setState(() {
                  selectedChat!.messages.insert(0, Message('Yo', message));
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    if (selectedChat != null) {
      setState(() {
        selectedChat!.messages.insert(0, Message('Yo', message));
      });
      messageController
          .clear(); // Borra el texto del campo de entrada después de enviar el mensaje
      FocusScope.of(context)
          .requestFocus(messageFocusNode); // Retoma el enfoque del TextField
    }
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

/* void main() {
  runApp(MaterialApp(
    home: ChatsScreen(),
  ));
}
 */