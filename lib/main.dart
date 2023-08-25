import 'package:ejemplo/providers/captured_images_model.dart';
import 'package:ejemplo/providers/counter_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(EjemploApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class EjemploApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CounterModel>(
          create: (_) => CounterModel(),
        ),
        ChangeNotifierProvider<CapturedImagesModel>(
          // Añade aquí el Provider de CapturedImagesModel
          create: (_) => CapturedImagesModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Ejemplo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/auth', // Especifica la ruta inicial
        routes: {
          '/auth': (context) => AuthScreen(),
          '/capture': (context) => CaptureImageScreen(),
          '/measurement': (context) => MeasurementScreen(),
        },
      ),
    );
  }
}
