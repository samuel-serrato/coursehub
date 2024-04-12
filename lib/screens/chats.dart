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
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  Chat? selectedChat;
  TextEditingController messageController = TextEditingController();

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: chatList(),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: content(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: selectedChat != null
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          selectedChat!.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: selectedChat!.messages.length,
                          itemBuilder: (context, index) {
                            final message = selectedChat!.messages[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: message.sender == 'Yo'
                                      ? Colors.blue
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  message.text,
                                  style: TextStyle(color: Colors.white),
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
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Selecciona un chat',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
        ),
      ],
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

  Widget chatList() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Chats',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return 
            ListTile(
              onTap: () {
                setState(() {
                  selectedChat = chat;
                });
              },
              title: Text(chat.name, style: TextStyle(color: Colors.white)),
              subtitle: Text(chat.messages.last.text,
                  style: TextStyle(color: Colors.white)),
              tileColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
                                shape: Border(bottom: BorderSide(color: Colors.white)), // Agrega un borde blanco solo abajo

            );
          },
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
                  selectedChat!.messages.add(Message('Yo', message));
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatsScreen(),
  ));
}
