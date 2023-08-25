import 'package:flutter/material.dart';
import 'package:ejemplo/screens/login_screen.dart';
import 'package:ejemplo/screens/register_screen.dart';

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
                icon: Icon(Icons.login), // Icono para el botón
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
                icon: Icon(Icons.person_add), // Icono para el botón
                label: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
