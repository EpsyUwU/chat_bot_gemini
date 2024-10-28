import 'package:flutter/material.dart';
import 'package:flutter_challenges/display/widgets/app_scaffold.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class GeoLocation extends StatefulWidget {
  const GeoLocation({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const GeoLocation(),
    );
  }

  @override
  _GeoLocationState createState() => _GeoLocationState();
}

class _GeoLocationState extends State<GeoLocation> {
  final TextEditingController _controller = TextEditingController();
  String displayedText = '';
  String locationLink = '';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Geo Location',
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
                      displayedText =
                          _controller.text; // Actualiza el texto ingresado
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
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Obtener Ubicación'),
            ),
            const SizedBox(height: 20),
            if (locationLink.isNotEmpty)
              GestureDetector(
                onTap: () => _launchURL(locationLink),
                child: Text(
                  locationLink,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Los servicios de ubicación no están habilitados, no se puede continuar
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos de ubicación están denegados, no se puede continuar
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos de ubicación están denegados permanentemente, no se puede continuar
      return;
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      locationLink =
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    });
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
