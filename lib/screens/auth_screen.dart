import 'package:flutter/material.dart';
import 'package:ejemplo/screens/login_screen.dart';
import 'package:ejemplo/screens/register_screen.dart';
import 'package:ejemplo/screens/config.dart'; // Importa la nueva pantalla

class AuthScreen extends StatelessWidget {
  final String iconImagePath = 'assets/icono.png'; // Ruta del icono

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autenticarse'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                icon: Icon(Icons.person_add),
                label: Text('Registrarse'),
              ),
              SizedBox(height: 16), // Agrega un espacio en blanco
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConfigScreen()), // Dirige a la pantalla de configuración
                  );
                },
                icon: Icon(
                    Icons.settings), // Icono para el botón de configuración
                label: Text('Configuración'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
