import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:ejemplo/screens/login_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo/screens/main_screen.dart';
import 'package:ejemplo/widgets/custom_button.dart';
import 'package:ejemplo/widgets/custom_text_field.dart';
import 'package:ejemplo/providers/firebase_ejemplo.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'Trabajador';
  final TextEditingController _tokenController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    String name = _nameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String role = _selectedRole;
    String enteredToken = _tokenController.text; // Get the entered token

    bool showDialogLoading = true;
    bool showTokenError = false; // Add this variable to track token error

    if (role == 'Administrador' && enteredToken != '0242931524') {
      // Check if the role is 'Administrador' and the token is incorrect
      showTokenError = true;
    } else {
      bool registroExitoso =
          await registroDb(name, lastName, email, password, role);

      if (registroExitoso) {
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
                  Navigator.pop(context); // Close the success message
                  // Navigate to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text('Ir al inicio de sesión'),
              ),
            ],
          ),
        );
      }
    }

    if (showDialogLoading && role != 'Administrador') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Procesando...'),
          content: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    if (showTokenError) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Token Incorrecto'),
          content: Text('El token ingresado no es válido.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the token error message
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    }

    await Future.delayed(Duration(seconds: showDialogLoading ? 2 : 0));

    Navigator.pop(context); // Close the dialog
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
                items: ['Administrador', 'Trabajador'].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Role'),
              ),
              if (_selectedRole == 'Administrador')
                CustomTextField(
                  controller: _tokenController,
                  labelText: 'Ingrese el token para ser Administrador',
                  // Aquí debes configurar el controlador y cualquier otra propiedad necesaria.
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
