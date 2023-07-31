import 'package:ejemplo/providers/captured_images_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Importa la clase del modelo para manejar el estado de las imágenes
import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';

class CaptureImageScreen extends StatefulWidget {
  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  String _currentPage = '/capture'; // Página actual

  @override
  Widget build(BuildContext context) {
    // Obtiene el modelo de estado de imágenes capturadas usando Provider
    final capturedImagesModel = Provider.of<CapturedImagesModel>(context);
    bool hasImages = capturedImagesModel.capturedImages.isNotEmpty;

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
                _onOptionSelected(context, '/capture', CaptureImageScreen());
              },
            ),
            ListTile(
              title: Text('Pantalla de resultados'),
              onTap: () {
                _onOptionSelected(context, '/measurement', MeasurementScreen());
              },
            ),
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
      body: Center(
        child: capturedImagesModel.capturedImages.isEmpty
            ? Text('No se ha capturado ninguna imagen')
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: capturedImagesModel.capturedImages.length,
                itemBuilder: (context, index) {
                  String imagePath = capturedImagesModel.capturedImages[index];
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
        onPressed: hasImages ? _processImages : null,
        label: Text('Procesar Imágenes'),
      ),
    );
  }

  Future<void> _openCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Agrega la imagen capturada al modelo de estado usando Provider
      Provider.of<CapturedImagesModel>(context, listen: false)
          .addCapturedImage(pickedFile.path);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Agrega la imagen seleccionada de la galería al modelo de estado usando Provider
      Provider.of<CapturedImagesModel>(context, listen: false)
          .addCapturedImage(pickedFile.path);
    }
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }

  void _removeImage(int index) {
    // Elimina la imagen del modelo de estado usando Provider
    Provider.of<CapturedImagesModel>(context, listen: false)
        .removeCapturedImage(index);
  }

  void _processImages() async {
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

  void _onOptionSelected(BuildContext context, String route, Widget screen) {
    if (_currentPage != route) {
      setState(() {
        _currentPage = route;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      Navigator.pop(context); // Cerrar el Drawer si la pantalla es la actual
    }
  }
}
