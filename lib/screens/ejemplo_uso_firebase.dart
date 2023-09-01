import 'package:ejemplo/providers/firebase_ejemplo.dart';
import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'package:flutter/material.dart';

class EjemploFirebase extends StatelessWidget {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
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
                _onOptionSelected(context, '/capture', CaptureImageScreen());
              },
            ),
            ListTile(
              title: Text('EJEMPLO USO FIREBASE'),
              onTap: () {
                _onOptionSelected(
                    context, '/ejemplofirebase', EjemploFirebase());
              },
            ),
            ListTile(
              title: Text('Pantalla de resultados'),
              onTap: () {
                _onOptionSelected(context, '/measurement', MeasurementScreen());
              },
            ),
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
      body: FutureBuilder<List>(
        future: getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final usuarios = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: usuarios?.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios?[index];
                      return ListTile(
                        title: Text('Usuario: ${usuario['usuario']}'),
                        subtitle: Text('Password: ${usuario['password']}'),
                        // Otros campos del usuario aquí...
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _usuarioController,
                        decoration: InputDecoration(labelText: 'Usuario'),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Contraseña'),
                        obscureText: true, // Para ocultar la contraseña
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final usuario = _usuarioController.text;
                          final password = _passwordController.text;

                          // Llama al método addUsuario con los valores ingresados
                          final resultado = await addUsuario(usuario, password);

                          if (resultado) {
                            // Si la operación fue exitosa, muestra un mensaje o realiza alguna acción
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Usuario agregado con éxito'),
                              ),
                            );
                          } else {
                            // Si la operación falla, muestra un mensaje de error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al agregar el usuario'),
                              ),
                            );
                          }

                          // Limpia los campos de texto después de guardar
                          _usuarioController.clear();
                          _passwordController.clear();
                        },
                        child: Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _onOptionSelected(BuildContext context, String route, Widget screen) {
    final currentPage = ModalRoute.of(context)?.settings.name;
    if (currentPage != route) {
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.pop(context);
    }
  }
}
