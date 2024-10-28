import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  final ScrollController _scrollController =
      ScrollController(); // Controlador de scroll
  List<Map<String, String>> messages = [];
  late GenerativeModel _model;
  bool _isConnected = true;
  bool _isLoading = false;
  final FlutterTts flutterTts = FlutterTts();

  // Define el número máximo de mensajes a enviar como contexto
  final int maxContextMessages = 10;

  // Variables para Speech to Text
  bool _hasSpeech = false;
  bool _isListening = false;
  String lastWords = '';
  String _currentLocaleId = 'es_ES';
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey:
          'AIzaSyADl4iRQDNbimyFNgYJaFUvb-HTtk58Pyk', // Reemplaza con tu clave API
    );
    _loadMessages(); // Cargar los mensajes guardados al iniciar
    _checkConnectivity(); // Verificar conectividad al iniciar
    Connectivity().onConnectivityChanged.listen(_updateConnectivityStatus);
    initSpeechState(); // Inicializar el estado de reconocimiento de voz
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Limpia el controlador cuando el widget se destruya
    super.dispose();
  }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
      );
      if (hasSpeech) {
        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? 'es_ES';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastWords = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  void startListening() {
    lastWords = '';
    speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      partialResults: true,
    );
    setState(() {
      _isListening = true;
    });
  }

  void stopListening() {
    speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      _controller.text =
          lastWords; // Actualiza el campo de texto con las palabras reconocidas
      if (result.finalResult && lastWords.isNotEmpty) {
        sendMessage(lastWords); // Envía el mensaje reconocido por voz
        _controller.clear(); // Limpia el campo de texto
      }
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      // Update the UI with the sound level if needed
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastWords = 'Error: ${error.errorMsg}';
    });
  }

  void statusListener(String status) {
    setState(() {
      _isListening = speech.isListening;
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _updateConnectivityStatus(
      List<ConnectivityResult> result) async {
    setState(() {
      _isConnected =
          result.isNotEmpty && result.first != ConnectivityResult.none;
    });
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
    }
  }

  // Método para guardar el historial y contexto actual
  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages = json.encode(messages);
    await prefs.setString('chat_messages', encodedMessages);
  }

  // Método para enviar un mensaje, teniendo en cuenta el contexto completo
  Future<void> sendMessage(String message) async {
    setState(() {
      messages.add({'user': message}); // Agrega el mensaje del usuario
      _isLoading = true; // Inicia la animación de carga
    });
    _saveMessages(); // Guarda el historial actualizado

    _scrollToBottom(); // Desplaza hacia abajo cuando se agrega un nuevo mensaje

    try {
      // Prepara el contexto a enviar al modelo
      final List<Content> content = [];

      // Agrega los mensajes anteriores al contexto, respetando el límite
      int start = (messages.length - maxContextMessages < 0
              ? 0
              : messages.length - maxContextMessages)
          .toInt();
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
        messages.add({
          'bot': response.text ?? 'No response available.'
        }); // Respuesta del bot
        _isLoading = false;
      });
      _saveMessages(); // Guarda el historial actualizado con la respuesta del bot

      _scrollToBottom(); // Desplaza hacia abajo cuando se recibe una respuesta

      // Reproduce la respuesta del bot usando Text-to-Speech
      await flutterTts.speak(response.text ?? 'No response available.');
    } catch (error) {
      setState(() {
        messages.add({'bot': 'Error: No se pudo obtener una respuesta.'});
        _isLoading =
            false; // Termina la animación de carga incluso si ocurre un error
      });
      _saveMessages(); // Guarda el historial incluso si ocurre un error

      _scrollToBottom(); // Desplaza hacia abajo en caso de error
    }
  }

  // Método para desplazarse hacia el final de la lista de mensajes
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot con Gemini'),
        backgroundColor: Colors.deepPurple, // Cambia el color del AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                controller:
                    _scrollController, // Asigna el controlador de scroll
                itemCount: messages.length +
                    (_isLoading
                        ? 1
                        : 0), // Incrementa el conteo si está cargando
                itemBuilder: (context, index) {
                  if (_isLoading && index == messages.length) {
                    // Mostrar un indicador de carga al final si está cargando
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1.0,
                            bottom: 2.0), // Añade padding en la parte de abajo
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      ),
                    );
                  }
                  final message = messages[index];
                  final isUser = message.containsKey('user');
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.deepPurple : Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message[isUser ? 'user' : 'bot'] ??
                            'No message available',
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
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
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _isListening ? stopListening : startListening,
                  child: Icon(_isListening ? Icons.mic_off : Icons.mic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
