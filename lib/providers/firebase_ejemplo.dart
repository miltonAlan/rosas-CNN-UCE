import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<bool> addUsuario(String usuario, String password) async {
  try {
    // Referencia a la colección "usuarios" en Firestore
    final CollectionReference usuariosCollection =
        FirebaseFirestore.instance.collection("usuarios");

    // Crear un nuevo documento con un ID automático
    await usuariosCollection.add({
      'usuario': usuario,
      'password': password,
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
