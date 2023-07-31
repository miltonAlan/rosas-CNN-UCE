import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Agrega esta línea
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';

import 'package:ejemplo/providers/captured_images_model.dart';
import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/measurement_screen.dart';

class CaptureImageScreen extends StatefulWidget {
  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  String _currentPage = '/capture';

  @override
  Widget build(BuildContext context) {
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
                icon: Icon(Icons
                    .collections), // Icono de visto para cargar múltiples imágenes
                onPressed:
                    _pickMultipleImagesFromGallery, // Agregamos la función para cargar múltiples imágenes
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
      Provider.of<CapturedImagesModel>(context, listen: false)
          .addCapturedImage(pickedFile.path);
    }
  }

  Future<void> _pickImageFromGallery() async {
    List<Asset> pickedImages = [];
    try {
      pickedImages = await MultiImagePicker.pickImages(
        maxImages: 99,
        enableCamera: true,
      );
    } catch (e) {
      print("Error al seleccionar imágenes: $e");
    }

    if (pickedImages.isNotEmpty) {
      List<String> imagePaths = [];
      for (var image in pickedImages) {
        imagePaths.add(await _getImagePath(image));
      }
      Provider.of<CapturedImagesModel>(context, listen: false)
          .addCapturedImages(imagePaths);
    }
  }

  Future<void> _pickMultipleImagesFromGallery() async {
    List<Asset> pickedImages = [];
    try {
      pickedImages = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
      );
    } catch (e) {
      print("Error al seleccionar imágenes: $e");
    }

    if (pickedImages.isNotEmpty) {
      List<String> imagePaths = [];
      for (var asset in pickedImages) {
        imagePaths.add(await _getImagePath(asset));
      }
      Provider.of<CapturedImagesModel>(context, listen: false)
          .addCapturedImages(imagePaths);
    }
  }

  Future<String> _getImagePath(Asset asset) async {
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    String imagePath = "${tempDir.path}/${asset.name}";
    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData);
    return imagePath;
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }

  void _removeImage(int index) {
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

    await Future.delayed(Duration(seconds: 2));

    Navigator.pop(context);
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
      Navigator.pop(context);
    }
  }
}
