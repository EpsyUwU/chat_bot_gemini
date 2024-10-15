import 'package:flutter/material.dart';
import 'package:flutter_challenges/core/utils/basic_models.dart';
import 'package:flutter_challenges/display/widgets/app_scaffold.dart';
import 'package:flutter_challenges/display/widgets/home/student_card.dart';

class Input extends StatefulWidget {
  const Input({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Input(),
    );
  }

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  final TextEditingController _controller = TextEditingController();
  String displayedText = '';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Input',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Input field con botón
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Escribe algo aquí...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      displayedText = _controller.text; // Actualiza el texto ingresado
                    });
                  },
                  child: const Text('Mostrar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Muestra el texto ingresado
            Text(
              displayedText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Lista de tarjetas de estudiantes

          ],
        ),
      ),
    );
  }
}

