import 'package:flutter/material.dart';
import 'package:flutter_challenges/display/screens/news/news.dart';
import 'package:flutter_challenges/display/screens/news/news_http.dart';
import 'package:flutter_challenges/display/widgets/app_scaffold.dart';

class NewsBottomBar extends StatefulWidget {
  const NewsBottomBar({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const NewsBottomBar(),
    );
  }

  @override
  State<NewsBottomBar> createState() => _NewsBottomBarState();
}

class _NewsBottomBarState extends State<NewsBottomBar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    News(),
    NewsHttp(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Noticias",
      body: _pages[_selectedIndex], // Cambiar de página según el BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Dio'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Http'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}