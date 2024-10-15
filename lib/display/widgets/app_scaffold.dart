import 'package:flutter/material.dart';
import 'package:flutter_challenges/display/screens/chatBot/chat_bot.dart';
import 'package:flutter_challenges/display/screens/home.dart';
import 'package:flutter_challenges/display/screens/news/news_bottom_bar.dart';
import 'package:flutter_challenges/display/screens/info/my_info.dart';

import '../screens/input/input.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.bottomNavigationBar,
  });

  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Color.fromARGB(255, 209, 171, 249)),
                child: Text('Menú de Navegación'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contact_phone_rounded),
              title: const Text('Contactos'),
              onTap: () {
                Navigator.push(context, Home.route());
              },
            ),
            ListTile(
              leading: const Icon(Icons.man_2_rounded),
              title: const Text('Mi info'),
              onTap: () {
                Navigator.push(context, MyInfo.route());
              },
            ),
            ListTile(
              leading: const Icon(Icons.newspaper_rounded),
              title: const Text('Noticias'),
              onTap: () {
                Navigator.push(context, NewsBottomBar.route());
              },
            ),
            ListTile(
              leading: const Icon(Icons.input_rounded),
              title: const Text('input'),
              onTap: () {
                Navigator.push(context, Input.route());
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('chat bot'),
              onTap: () {
                Navigator.push(context, ChatBotScreen.route());
              },
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
