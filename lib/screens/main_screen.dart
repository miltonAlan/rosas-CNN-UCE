import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'package:ejemplo/screens/select_image_screen.dart';
import 'package:flutter/material.dart';

// Agrega la importación de la pantalla AuthScreen si aún no lo has hecho.
import 'package:ejemplo/screens/auth_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Bienvenido a la aplicación'),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Carga imágenes desde cámara/galería'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CaptureImageScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Pantalla de resultados'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeasurementScreen()),
                );
              },
            ),
            // Nueva opción para la pantalla de autenticación
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Bienvenido a la aplicación',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
