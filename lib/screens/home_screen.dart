import 'package:flutter/material.dart';
import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/settings_screen.dart';
import 'package:ejemplo/screens/profile_screen.dart';
import 'package:ejemplo/widgets/theme_switcher.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          ThemeSwitcher(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Bienvenido',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                // No es necesario navegar a la misma pantalla
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                // Navegar a la pantalla de configuración
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                // Navegar a la pantalla de perfil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AuthScreen()),
            );
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
