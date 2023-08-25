import 'package:flutter/material.dart';

class SelectImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Selección de Imagen'),
      ),
      body: Center(
        child: Text('Aquí se selecciona una imagen de la galería'),
      ),
    );
  }
}
