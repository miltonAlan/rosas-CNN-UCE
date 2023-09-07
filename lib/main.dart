import 'package:ejemplo/screens/ejemplo_uso_firebase.dart';
import 'package:ejemplo/screens/login_screen.dart';
import 'package:ejemplo/screens/resultados_admin.dart';
import 'package:ejemplo/screens/resultados_trabajador.dart';
import 'package:ejemplo/screens/text_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ejemplo/providers/captured_images_model.dart';
import 'package:ejemplo/providers/counter_model.dart';
// import 'package:ejemplo/providers/test_result_provider.dart'; // Asegúrate de importar TestResultProvider
import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          create: (_) => CapturedImagesModel(),
        ),
        // Agrega el provider de TestResultProvider
        ChangeNotifierProvider<TestResultProvider>(
          create: (_) => TestResultProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Ejemplo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/auth',
        routes: {
          '/auth': (context) => AuthScreen(),
          '/capture': (context) => CaptureImageScreen(),
          '/measurement': (context) => MeasurementScreen(),
          '/ejemplofirebase': (context) => EjemploFirebase(),
          '/resultadosAdmin': (context) => ResultadosAdmin(),
          '/resultadosTrabajador': (context) => ResultadosTrabajador(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
