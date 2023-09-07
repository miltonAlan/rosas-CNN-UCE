import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'package:ejemplo/screens/resultados_admin.dart';
import 'package:ejemplo/screens/text_provider.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo/widgets/custom_button.dart';
import 'package:ejemplo/widgets/custom_text_field.dart';
import 'package:ejemplo/providers/firebase_ejemplo.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _logindb(BuildContext context, String email, String password) async {
    // Llama a la función de inicio de sesión con Firebase Authentication y Firestore.
    bool loginSuccess =
        await signInWithEmailAndPassword(context, email, password);

    if (loginSuccess) {
      // Obtiene el rol del usuario después del inicio de sesión.
      final String rol =
          Provider.of<TestResultProvider>(context, listen: false).rol;

      String successMessage = 'Ingreso exitoso como $rol';

      // Muestra un mensaje de éxito antes de navegar a la pantalla correspondiente.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          duration: Duration(seconds: 2),
        ),
      );

      if (rol == 'Administrador') {
        // Si el usuario es administrador, navega a la pantalla de administrador.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultadosAdmin(),
          ),
        );
      } else {
        // Si el usuario no es administrador, navega a la pantalla de trabajador.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CaptureImageScreen(),
          ),
        );
      }
    } else {
      // Si la autenticación falla, puedes mostrar un mensaje de error.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error de inicio de sesión'),
          content: Text('Usuario o contraseña incorrectos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingreso'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              CustomButton(
                onPressed: () {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  _logindb(context, email, password);
                },
                label: 'Ingresar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
