import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:ejemplo/screens/ejemplo_uso_firebase.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'package:ejemplo/screens/resultados_admin.dart';
import 'package:ejemplo/screens/resultados_trabajador.dart';
import 'package:flutter/material.dart';

class AppDrawerAndNavigation {
  static void onOptionSelected(
      BuildContext context, String route, Widget screen) {
    final currentPage = ModalRoute.of(context)!.settings.name;

    if (currentPage != route) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      Navigator.pop(context);
    }
  }

  static Widget buildDrawer(
      BuildContext context, String rol, String nombreTrabajador) {
    bool isAdmin = (rol == 'administrador');

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Bienvenid@ $nombreTrabajador \n Rol: $rol'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          if (!isAdmin)
            ListTile(
              title: Text('Carga imágenes desde cámara/galería'),
              onTap: () {
                onOptionSelected(context, '/capture', CaptureImageScreen());
              },
            ),
          // ListTile(
          //   title: Text('EJEMPLO USO FIREBASE'),
          //   onTap: () {
          //     onOptionSelected(context, '/ejemplofirebase', EjemploFirebase());
          //   },
          // ),
          if (!isAdmin)
            ListTile(
              title: Text('Pantalla de revisión de resultados'),
              onTap: () {
                onOptionSelected(context, '/measurement', MeasurementScreen());
              },
            ),
          if (isAdmin)
            ListTile(
              title: Text('Resultados Generales'),
              onTap: () {
                onOptionSelected(
                    context, '/resultadosAdmin', ResultadosAdmin());
              },
            ),
          if (!isAdmin)
            ListTile(
              title: Text('Todas mis mediciones'),
              onTap: () {
                onOptionSelected(
                    context, '/resultadosTrabajador', ResultadosTrabajador());
              },
            ),
          if (isAdmin)
            ListTile(
              title: Text('Todas las mediciones'),
              onTap: () {
                onOptionSelected(
                    context, '/resultadosAdmin', ResultadosAdmin());
              },
            ),
          ListTile(
            title: Text('Cerrar Sesión'),
            onTap: () {
              onOptionSelected(context, '/logout', AuthScreen());
            },
          ),
        ],
      ),
    );
  }
}
