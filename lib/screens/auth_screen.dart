import 'package:flutter/material.dart';
import 'package:ejemplo/screens/login_screen.dart';
import 'package:ejemplo/screens/register_screen.dart';
import 'package:ejemplo/screens/config.dart'; // Importa la nueva pantalla

class AuthScreen extends StatelessWidget {
  final String iconImagePath = 'assets/icono.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autenticarse'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centra horizontalmente
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              icon: Icon(Icons.login),
              label: Text('Ingresar'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(150, 45)),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              icon: Icon(Icons.person_add),
              label: Text('Registrarse'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(150, 45)),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfigScreen(),
                  ),
                );
              },
              icon: Icon(Icons.settings),
              label: Text('Configuración'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(150, 45)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
