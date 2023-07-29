import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API App',
      theme: ThemeData.dark(), // Usar tema oscuro
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl =
      'https://ejemplosimple.azurewebsites.net'; // Dirección de la API
  TextEditingController responseController = TextEditingController();
  File? selectedImage;
  File? processedImage;
  String errorMessage = '';

  Future<void> _getMethod() async {
    try {
      http.Response response = await http.get(Uri.parse('$apiUrl/datetime'));
      if (response.statusCode == 200) {
        // Mostrar la respuesta del método GET en la sección de la izquierda
        setState(() {
          errorMessage = '';
          responseController.text = response.body;
        });
      } else {
        setState(() {
          errorMessage =
              'Error al obtener la fecha y hora. Código de estado: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al obtener la fecha y hora: $e';
      });
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        processedImage =
            null; // Resetea la imagen procesada cuando se selecciona una nueva imagen.
        errorMessage = '';
      });
    } else {
      setState(() {
        errorMessage = 'No se seleccionó ninguna imagen.';
      });
    }
  }

  Future<void> _postMethod() async {
    if (selectedImage == null) {
      setState(() {
        errorMessage = 'No se ha seleccionado ninguna imagen para procesar.';
      });
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/invert'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('img', selectedImage!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        setState(() {
          errorMessage = '';
          processedImage = File.fromRawPath(responseData);
        });
      } else {
        setState(() {
          errorMessage =
              'Error al procesar la imagen. Código de estado: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al procesar la imagen: $e';
      });
    }
  }

  void _clearFields() {
    setState(() {
      responseController.clear();
      selectedImage = null;
      processedImage = null;
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API App'),
        actions: [
          IconButton(
            onPressed: _clearFields,
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _getMethod,
                        child: Text('METODO GET'),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: TextFormField(
                          controller: responseController,
                          maxLines: null,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Respuesta GET',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _selectImage,
                        child: Text('Seleccionar Imagen'),
                      ),
                      SizedBox(height: 20),
                      selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              height: 100,
                              width: 100,
                            )
                          : Container(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _postMethod,
                        child: Text('Ejecutar POST'),
                      ),
                      SizedBox(height: 20),
                      processedImage != null
                          ? Image.file(
                              processedImage!,
                              height: 100,
                              width: 100,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          errorMessage.isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.red,
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
