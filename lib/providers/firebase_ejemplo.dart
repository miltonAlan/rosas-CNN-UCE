import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemplo/screens/text_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsuarios() async {
  List usuarios = [];
  CollectionReference collectionReferenceUsuarios = db.collection('usuarios');
  QuerySnapshot queryUsuarios = await collectionReferenceUsuarios.get();
  queryUsuarios.docs.forEach((element) {
    usuarios.add(element.data());
  });
  return usuarios;
}

Future<bool> addUsuario(String name, String lastName, String email,
    String password, String role) async {
  try {
    // Referencia a la colección "usuarios" en Firestore
    final CollectionReference usuariosCollection =
        FirebaseFirestore.instance.collection("usuarios");

    // Crear un nuevo documento con un ID automático
    await usuariosCollection.add({
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
      // Puedes agregar más campos si es necesario
    });

    // Si llegamos aquí, la operación de escritura fue exitosa
    return true;
  } catch (e) {
    // Si hay un error, puedes manejarlo de la manera que desees
    print("Error al agregar usuario: $e");
    return false;
  }
}

Future<bool> signInWithEmailAndPassword(
    BuildContext context, String email, String password) async {
  try {
    // Consulta la colección de "usuarios" en Firestore para verificar si existe un usuario con los campos de correo y contraseña proporcionados.
    final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .limit(1)
        .get();

    // Si se encuentra al menos un usuario con los campos de correo y contraseña coincidentes, el inicio de sesión se considera válido.
    if (userSnapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> userList = [];

      for (var doc in userSnapshot.docs) {
        userList.add(doc.data() as Map<String, dynamic>);
      }
      final String? userRole = userList[0]["role"] as String?;
      final String? nombreTrabajador = userList[0]["name"] as String?;
      print(userRole);
      final testResultProvider =
          Provider.of<TestResultProvider>(context, listen: false);
      testResultProvider.rol = userRole ?? "Rol no definido";
      testResultProvider.nombreTrabajador =
          nombreTrabajador ?? "Nombre no definido";

      return true;
    } else {
      return false; // Los campos de correo y contraseña no coinciden con ningún usuario en la colección.
    }
  } catch (e) {
    // Si hay un error durante la consulta, puedes manejarlo aquí
    print('Error en la consulta de inicio de sesión: $e');
    return false; // Devuelve false en caso de error
  }
}

Future<List<Map<String, dynamic>>> obtenerMedicionesTrabajador(
    String trabajador) async {
  List<Map<String, dynamic>> mediciones = [];
  try {
    final QuerySnapshot trabajadorData = await db
        .collection('imagenes')
        .where('nombreTrabajador', isEqualTo: trabajador)
        .get();

    for (QueryDocumentSnapshot doc in trabajadorData.docs) {
      mediciones.add(doc.data() as Map<String, dynamic>);
    }

    // // Imprimir las mediciones
    // for (Map<String, dynamic> medicion in mediciones) {
    //   print('Fecha: ${medicion['fecha']}');
    //   print('ImageUrl: ${medicion['imageUrl']}');
    //   print('Nombre Trabajador: ${medicion['nombreTrabajador']}');
    //   print('Rosas:');
    //   if (medicion['rosas'] != null) {
    //     for (int i = 0; i < medicion['rosas'].length; i++) {
    //       print('  $i:');
    //       print('    Altura: ${medicion['rosas'][i]['altura']}');
    //     }
    //   } else {
    //     print('    Sin datos de rosas');
    //   }
    //   print('\n');
    // }

    return mediciones;
  } catch (e) {
    print('Error al obtener mediciones del trabajador: $e');
    return [];
  }
}

Future<List<String>> obtenerImagenes() async {
  return [
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c'
  ];
}

Future<List<String>> obtenerImagenes2(String nombreTrabajador) async {
  print("nombreTrabajadorXXXXXXXXXXXXXXXXXXXXX: $nombreTrabajador");
  return [
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c'
  ];
}

Future<bool> subirImagenConTexto(
  List<Map<String, dynamic>> rosasData, // Cambiar a una lista de mapas
  String imagePath,
  String nombreTrabajador,
  String fecha,
) async {
  try {
    final File imagen = File(imagePath);
    final imageName = imagen.uri.pathSegments.last.split('.').first;

    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('imagenes/$imageName.jpg');

    await storageRef.putFile(imagen);
    final imageUrl = await storageRef.getDownloadURL();

    final CollectionReference imagenesCollection =
        FirebaseFirestore.instance.collection("imagenes");

    // Ahora, construimos la lista de rosas en el formato deseado
    List<Map<String, dynamic>> rosasList = [];
    for (var rosaData in rosasData) {
      Map<String, dynamic> rosa = {
        'altura': rosaData['altura'],
      };
      rosasList.add(rosa);
    }

    await imagenesCollection.add({
      'imageUrl': imageUrl,
      'nombreTrabajador': nombreTrabajador,
      'fecha': fecha,
      'rosas': rosasList, // Agregar la lista de rosas como un campo
    });

    return true; // Subida exitosa
  } catch (e) {
    print("Error al subir la imagen y los datos: $e");
    return false; // Error en la subida
  }
}
