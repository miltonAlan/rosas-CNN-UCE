import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemplo/screens/text_provider.dart';
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
      print(userRole);
      final testResultProvider =
          Provider.of<TestResultProvider>(context, listen: false);
      testResultProvider.rol = userRole ?? "Rol no definido";

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

Future<List<String>> obtenerImagenes() async {
  // Aquí debes implementar la lógica para obtener las URLs de las imágenes desde Firebase Storage.
  // Puedes usar Firebase Storage para esto.
  // Por ahora, retornaremos una lista de URLs de ejemplo.
  return [
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c',
    'https://firebasestorage.googleapis.com/v0/b/mineria-95bea.appspot.com/o/23110.jpg?alt=media&token=0b329c13-df07-4db0-80a1-f5c6ec027a5c'
  ];
}
