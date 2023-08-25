import 'package:flutter/material.dart';
import 'package:ejemplo/screens/main_screen.dart'; // Cambia por el nombre de tu archivo de la pantalla principal

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: Colors.white,
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Text(
                          'Welcome!'), // Puedes personalizar el contenido del encabezado
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    ListTile(
                      title: Text('Main Screen'),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      },
                    ),
                    // Agrega más ListTile para otras opciones del drawer
                  ],
                ),
              );
            },
          );
        },
      ),
      title: Text('App Bar Title'), // Cambia el título según tu necesidad
      // Agrega cualquier otro elemento necesario en la AppBar
    );
  }
}
