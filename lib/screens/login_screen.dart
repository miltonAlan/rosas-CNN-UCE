import 'package:flutter/material.dart';
// import 'package:ejemplo/screens/register_screen.dart';
import 'package:ejemplo/screens/main_screen.dart';
import 'package:ejemplo/widgets/custom_button.dart';
import 'package:ejemplo/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    // Simulate login delay (You can replace this with actual API call)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Logging In'),
        content: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close the dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                onPressed: () => _login(context),
                label: 'Login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
