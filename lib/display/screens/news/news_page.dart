import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key, required this.title, required this.url});

  static Route route({
    required String title,
    required String url,
  }) {
    return MaterialPageRoute(
      builder: (context) => NewsPage(
        title: title,
        url: url,
      ),
    );
  }

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Puedes actualizar una barra de carga si lo deseas.
          },
          onPageStarted: (String url) {
            // Acción cuando la página comienza a cargar.
          },
          onPageFinished: (String url) {
            // Acción cuando la página termina de cargar.
          },
          onHttpError: (HttpResponseError error) {
            // Manejo de errores HTTP.
          },
          onWebResourceError: (WebResourceError error) {
            // Manejo de otros errores.
          },
          onNavigationRequest: (NavigationRequest request) {
            // Bloquear navegación a ciertas URLs si es necesario.
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
