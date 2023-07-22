import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;

  Future<void> _uploadImage() async {
    if (_image == null) return;

    String url = 'http://tu-servicio-web.com/procesar_imagen';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile(
      'imagen',
      _image!.readAsBytes().asStream(),
      _image!.lengthSync(),
      filename: _image!.path.split('/').last,
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      // Procesar la respuesta (imagen procesada) aquí
      print(await response.stream.bytesToString());
    } else {
      // Manejar errores en caso de que la solicitud falle
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('Seleccione una imagen')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleccionar imagen'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Enviar imagen'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageUploadScreen(),
  ));
}
