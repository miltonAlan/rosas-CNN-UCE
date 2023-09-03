import 'dart:io';
import 'package:ejemplo/providers/firebase_ejemplo.dart';
import 'package:ejemplo/screens/drawer_modular.dart';
import 'package:ejemplo/screens/text_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ejemplo/providers/captured_images_model.dart';
import 'package:ejemplo/screens/auth_screen.dart';
import 'package:ejemplo/screens/capture_image_screen.dart';
import 'package:photo_view/photo_view.dart';

class MeasurementScreen extends StatefulWidget {
  @override
  _MeasurementScreenState createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  bool _isUploading = false;

  Future<void> _guardarResultados(BuildContext context) async {
    final capturedImagesModel =
        Provider.of<CapturedImagesModel>(context, listen: false);

    setState(() {
      _isUploading = true; // Activar indicador de carga
    });

    await capturedImagesModel.subirTodasLasImagenesConTexto(context);

    setState(() {
      _isUploading = false; // Desactivar indicador de carga
    });

    // Mostrar un SnackBar con el mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Resultados guardados con éxito'),
        duration: Duration(seconds: 4), // Duración del mensaje
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String rol =
        Provider.of<TestResultProvider>(context, listen: false).rol ??
            "Rol no definido";
    final String nombreTrabajador =
        Provider.of<TestResultProvider>(context).nombreTrabajador ??
            "Nombre no definido";

    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Resultados'),
      ),
      drawer:
          AppDrawerAndNavigation.buildDrawer(context, rol, nombreTrabajador),
      body: Center(
        child: _isUploading
            ? CircularProgressIndicator() // Mostrar indicador de carga si se está subiendo
            : _buildImageGrid(context),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              _guardarResultados(
                  context); // Llama al método para guardar resultados
            },
            label: Text('Guardar Resultados'),
            icon: Icon(Icons.upload_file), // Icono del primer botón
          ),
          FloatingActionButton.extended(
            onPressed: () {
              _clearImagesProcessed(
                  context); // Llama al método para borrar todas las imágenes procesadas
            },
            label: Text('Borrar Todas'),
            icon: Icon(Icons.close), // Icono del segundo botón
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    final capturedImagesModel = context.watch<CapturedImagesModel>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: capturedImagesModel.capturedImagesProcessed.length,
            itemBuilder: (context, index) {
              String imagePath =
                  capturedImagesModel.capturedImagesProcessed[index];
              // print("mostradas" +
              //     capturedImagesModel.capturedImagesProcessed[index]);
              return GestureDetector(
                onTap: () {
                  _showImageDetail(context, imagePath);
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _removeImage(context, index);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onOptionSelected(BuildContext context, String route, Widget screen) {
    final currentPage = ModalRoute.of(context)?.settings.name;
    if (currentPage != route) {
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.pop(context);
    }
  }

  void _showImageDetail(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: PhotoView(
              imageProvider: FileImage(File(imagePath)),
              backgroundDecoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeImage(BuildContext context, int index) {
    Provider.of<CapturedImagesModel>(context, listen: false)
        .removeCapturedImageProcessed(index);
  }

  void _clearImagesProcessed(BuildContext context) {
    Provider.of<CapturedImagesModel>(context, listen: false)
        .clearCapturedImagesProcessed();
  }
}
