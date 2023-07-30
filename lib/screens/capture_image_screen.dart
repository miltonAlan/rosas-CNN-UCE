import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CaptureImageScreen extends StatefulWidget {
  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  List<String> _capturedImages = [];

  @override
  Widget build(BuildContext context) {
    bool hasImages =
        _capturedImages.isNotEmpty; // Verificar si hay imágenes capturadas

    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Captura de Imagen'),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: _openCamera,
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: _pickImageFromGallery,
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Bienvenido a la aplicación'),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Carga imágenes desde cámara/galería'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CaptureImageScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Pantalla de resultados'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeasurementScreen()),
                );
              },
            ),
            // Nueva opción para la pantalla de autenticación
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
            ),
          ],
        ),
      ),
      // Agrega el AppDrawer como el drawer de la pantalla
      body: Center(
        child: _capturedImages.isEmpty
            ? Text('No se ha capturado ninguna imagen')
            : GridView.builder(
                // Mostrar las miniaturas de las imágenes capturadas en un GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: _capturedImages.length,
                itemBuilder: (context, index) {
                  String imagePath = _capturedImages[index];
                  String fileName = _getFileName(imagePath);

                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Center(
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () => _removeImage(index),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            fileName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: hasImages
            ? _processImages
            : null, // Habilitar o deshabilitar el botón
        label: Text('Procesar Imágenes'),
      ),
    );
  }

  // Método para abrir la cámara y tomar una fotografía
  Future<void> _openCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _capturedImages.add(pickedFile
            .path); // Agregar la ruta de la imagen capturada a la lista
      });
    }
  }

  // Método para seleccionar una foto desde la galería
  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _capturedImages.add(pickedFile
            .path); // Agregar la ruta de la imagen seleccionada a la lista
      });
    }
  }

  // Método para obtener el nombre del archivo a partir de la ruta completa
  String _getFileName(String path) {
    return path.split('/').last;
  }

  // Método para eliminar una imagen de la lista _capturedImages
  void _removeImage(int index) {
    setState(() {
      _capturedImages.removeAt(index);
    });
  }

  // Método para simular el procesamiento de imágenes
  Future<void> _processImages() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Procesando Imágenes'),
        content: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    // Simulamos una demora de 2 segundos para el procesamiento de imágenes
    await Future.delayed(Duration(seconds: 2));

    Navigator.pop(context); // Cerrar el diálogo de progreso
    // Aquí puedes incluir la llamada a una API real para procesar las imágenes capturadas
    // Ejemplo: await _uploadImagesToServer();
  }

  // Método para invocar una API ficticia
  // Descomentar esta sección para usar una API real
  // Future<void> _uploadImagesToServer() async {
  //   // Aquí iría la lógica para invocar la API
  //   // Por ejemplo:
  //   // Realizar una petición HTTP a la API con las imágenes capturadas
  //   // Procesar la respuesta de la API
  //   // Actualizar el estado de la aplicación según la respuesta
  // }
}
