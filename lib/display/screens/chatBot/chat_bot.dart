import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const ChatBotScreen(),
    );
  }

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  late GenerativeModel _model;
  bool _isConnected = true;

  // Define el número máximo de mensajes a enviar como contexto
  static const int maxContextMessages = 10;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyADl4iRQDNbimyFNgYJaFUvb-HTtk58Pyk', // Reemplaza con tu clave API
    );
    _loadMessages(); // Cargar los mensajes guardados al iniciar
    _checkConnectivity(); // Verificar conectividad al iniciar
    Connectivity().onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _updateConnectivityStatus(List<ConnectivityResult> result) async {
    setState(() {
      _isConnected = result.isNotEmpty && result.first != ConnectivityResult.none;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_isConnected');
  }

  // Método para cargar el historial y contexto guardado
  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessages = prefs.getString('chat_messages');
    if (savedMessages != null) {
      setState(() {
        // Convierte cada elemento de la lista decodificada en Map<String, String>
        messages = List<Map<String, String>>.from(
          json.decode(savedMessages).map(
                (item) => Map<String, String>.from(item),
          ),
        );
      });
      print('Mensajes cargados: $messages');
    } else {
      print('No hay mensajes guardados');
    }
  }

  // Método para guardar el historial y contexto actual
  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages = json.encode(messages);
    await prefs.setString('chat_messages', encodedMessages);
    print('Mensajes guardados: $messages');
  }

  // Método para enviar un mensaje, teniendo en cuenta el contexto completo
  Future<void> sendMessage(String message) async {
    setState(() {
      messages.add({'user': message}); // Agrega el mensaje del usuario
    });
    _saveMessages(); // Guarda el historial actualizado

    try {
      // Prepara el contexto a enviar al modelo
      final List<Content> content = [];

      // Agrega los mensajes anteriores al contexto, respetando el límite
      int start = messages.length - maxContextMessages < 0
          ? 0
          : messages.length - maxContextMessages;
      for (int i = start; i < messages.length; i++) {
        final message = messages[i];
        if (message.containsKey('user')) {
          content.add(Content.text('Usuario: ${message['user']}'));
        } else {
          content.add(Content.text('Bot: ${message['bot']}'));
        }
      }

      // Agrega el mensaje actual del usuario
      content.add(Content.text('Usuario: $message'));

      // Genera una respuesta desde el modelo de Google Gemini
      final response = await _model.generateContent(content);

      // Muestra la respuesta del chatbot
      setState(() {
        messages.add({'bot': response.text ?? 'No response available.'}); // Respuesta del bot
      });
      _saveMessages(); // Guarda el historial actualizado con la respuesta del bot
    } catch (error) {
      setState(() {
        messages.add({'bot': 'Error: No se pudo obtener una respuesta.'});
      });
      _saveMessages(); // Guarda el historial incluso si ocurre un error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatBot con Gemini')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message.containsKey('user');
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isUser ? message['user']! : message['bot']!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Input de mensaje con botón para enviar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Escribe tu mensaje...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isConnected
                      ? () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text); // Envía el mensaje
                      _controller.clear(); // Limpia el campo de texto
                    }
                  }
                      : null, // Deshabilitar botón si no está conectado
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

