import 'package:flutter/material.dart';
import 'package:ejemplo/screens/main_screen.dart';
import 'package:ejemplo/widgets/custom_button.dart';
import 'package:ejemplo/widgets/custom_text_field.dart';
// import 'package:ejemplo/models/user.dart';
import 'package:ejemplo/widgets/custom_app_bar.dart'; // Agrega esta línea

class RegisterScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'administrador';

  void _register(BuildContext context) {
    // Simulate registration delay (You can replace this with actual API call)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Registering User'),
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
      appBar: CustomAppBar(
        title: 'Register',
        showBackButton: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
