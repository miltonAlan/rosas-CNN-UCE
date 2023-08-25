import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:flutter/foundation.dart';

class CapturedImagesModel extends ChangeNotifier {
  List<String> _capturedImages = [];
  List<String> _capturedImagesProcessed = []; // Nueva lista agregada

  List<String> get capturedImages => _capturedImages;
  List<String> get capturedImagesProcessed =>
      _capturedImagesProcessed; // Getter para la nueva lista

  void addCapturedImage(String imagePath) {
    _capturedImages.add(imagePath);
    notifyListeners();
  }

  void addCapturedImages(List<String> imagePaths) {
    _capturedImages.addAll(imagePaths);
    notifyListeners();
  }

  void addCapturedImageProcessed(String imagePath) {
    // _capturedImagesProcessed
    //     .add(imagePath); // Función para agregar a la nueva lista
    // Ruta de la imagen original
    // String imgPath = imagePath;
    // String imagePath = 'assets/your_image.png'; // Reemplaza con la ruta correcta

    // Carga la imagen utilizando el paquete 'image'
    img.Image originalImage =
        img.decodeImage(File(imagePath).readAsBytesSync())!;

    // Coordenadas y tamaño del cuadrado
    // int squareX = 10;
    // int squareY = 50;
    // int squareSize = 300;
    // int squareThickness = 50; // Grosor del borde del cuadrado
    // int squareColorValue = img.getColor(
    // 255, 0, 0); // Valor de color del cuadrado (rojo en este caso)

    // Dibuja el cuadrado en la imagen
    // img.Image modifiedImage = drawSquareOnImage(originalImage, squareX, squareY,
    //     squareSize, squareThickness, squareColorValue);

    List<RectangleParams> rectangles = [
      RectangleParams(
          x: 99,
          y: 20,
          width: 600,
          height: 100,
          thickness: 10,
          colorValue: img.getColor(0, 0, 255),
          text: 'AAAAAAAAAaa'), // Agregar el texto
      RectangleParams(
          x: 500,
          y: 400,
          width: 600,
          height: 100,
          thickness: 10,
          colorValue: img.getColor(0, 0, 255),
          text: 'BBBBBBB'), // Agregar el texto
      // Agrega más rectángulos según lo necesites
    ];

    img.Image modifiedImage = drawRectanglesOnImage(originalImage, rectangles);
    // Guarda la imagen modificada
    // File modifiedFile = File(
    //     'path_to_save_modified_image.png'); // Ruta donde deseas guardar la imagen
    // modifiedFile.writeAsBytesSync(img.encodePng(modifiedImage));

    // print('Imagen con cuadrado guardada correctamente.');
    // Genera el nuevo path para la imagen modificada
    String originalFileName =
        imagePath.split('/').last; // Obtiene el nombre del archivo
    DateTime now = DateTime.now();
    String newFileName =
        '${now.hour}-${now.minute}-${now.second}-${now.millisecond}_${originalFileName}';
    String modifiedImagePath =
        imagePath.replaceFirst(originalFileName, newFileName);

    File(modifiedImagePath).writeAsBytesSync(img.encodePng(modifiedImage));

    _capturedImagesProcessed.add(modifiedImagePath);
    notifyListeners();
  }

  void addCapturedImagesProcessed(List<String> imagePaths) {
    _capturedImagesProcessed
        .addAll(imagePaths); // Función para agregar a la nueva lista
    notifyListeners();
  }

  void removeCapturedImage(int index) {
    _capturedImages.removeAt(index);
    notifyListeners();
  }

  void removeCapturedImageProcessed(int index) {
    _capturedImagesProcessed
        .removeAt(index); // Función para remover de la nueva lista
    notifyListeners();
  }

  void clearCapturedImages() {
    _capturedImages.clear();
    notifyListeners();
  }

  void clearCapturedImagesProcessed() {
    _capturedImagesProcessed.clear(); // Función para limpiar la nueva lista
    notifyListeners();
  }

  img.Image drawRectanglesOnImage(
      img.Image image, List<RectangleParams> rectangles) {
    img.Image modifiedImage =
        img.copyResize(image, width: image.width, height: image.height);

    for (var rectParams in rectangles) {
      int x = rectParams.x;
      int y = rectParams.y;
      int width = rectParams.width; // Ancho del rectángulo
      int height = rectParams.height; // Alto del rectángulo
      int thickness = rectParams.thickness;
      int colorValue = rectParams.colorValue;

      for (int i = x; i < x + width; i++) {
        for (int j = y; j < y + height; j++) {
          if ((i >= x && i < x + thickness) ||
              (i < x + width && i >= x + width - thickness) ||
              (j >= y && j < y + thickness) ||
              (j < y + height && j >= y + height - thickness)) {
            modifiedImage.setPixel(i, j, colorValue);
          }
        }
      }
      // Agrega el texto en el lateral izquierdo
      String text = rectParams.text;
      img.drawString(
          modifiedImage, img.arial_48, x - 50, y + height ~/ 2 - 10, text,
          color: img.getColor(0, 0, 0));
    }

    return modifiedImage;
  }
}

class RectangleParams {
  final int x;
  final int y;
  final int width; // Cambiar de 'size' a 'width'
  final int height; // Agregar el alto del rectángulo
  final int thickness;
  final int colorValue;
  final String text; // Texto a agregar

  RectangleParams(
      {required this.x,
      required this.y,
      required this.width,
      required this.height,
      required this.thickness,
      required this.text,
      required this.colorValue});
}
