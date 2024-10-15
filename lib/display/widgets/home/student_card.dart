import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCard extends StatelessWidget {
  const StudentCard(
      {super.key,
      required this.name,
      required this.id,
      required this.tel,
      required this.sms});

  final String name;
  final String id;
  final String tel;
  final String sms;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: Text(name),
      subtitle: Text(id),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                _launchApp(tel);
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  Future<void> _launchApp(String urlString) async {
    final Uri url = Uri.parse(urlString); 
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'No se pudo abrir la aplicación para $url';
    }
  }
}
