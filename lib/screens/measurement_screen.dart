import 'package:flutter/material.dart';

class MeasurementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Medición'),
      ),
      body: Center(
        child: Text('Aquí se realiza la medición de objetos'),
      ),
    );
  }
}
