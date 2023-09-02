import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:ejemplo/screens/login_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo/screens/main_screen.dart';
import 'package:ejemplo/widgets/custom_button.dart';
import 'package:ejemplo/widgets/custom_text_field.dart';
import 'package:ejemplo/providers/firebase_ejemplo.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'administrador';

  Future<void> _register(BuildContext context) async {
    String name = _nameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String role = _selectedRole;

    bool registroExitoso =
        await registroDb(name, lastName, email, password, role);

    bool showDialogLoading = true;

    if (registroExitoso) {
      // Mostrar diálogo solo si el registro es exitoso
      showDialogLoading = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Registro Exitoso'),
          content: Text('¡El registro se ha completado con éxito!'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el mensaje de éxito
                // Navegar a la pantalla de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(), // Reemplaza con tu página de inicio de sesión
                  ),
                );
              },
              child: Text('Ir al inicio de sesión'),
            ),
          ],
        ),
      );
    }

    if (showDialogLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Registrando Usuario'),
          content: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Esperar un tiempo, dependiendo de si se muestra el diálogo o no
    await Future.delayed(Duration(seconds: showDialogLoading ? 2 : 0));

    Navigator.pop(context); // Cerrar el diálogo
  }

  Future<bool> registroDb(String name, String lastName, String email,
      String password, String role) async {
    final resultado = await addUsuario(name, lastName, email, password, role);
    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        // Envuelve en SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Name',
              ),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
              ),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: ['administrador', 'trabajador'].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _selectedRole = newValue!;
                },
                decoration: InputDecoration(labelText: 'Role'),
              ),
              SizedBox(height: 24.0),
              CustomButton(
                onPressed: () => _register(context),
                label: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
