import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:convert'; // Importa la librería dart:convert

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

  void _printJsonObject(Map<String, dynamic> jsonObject, [String prefix = '']) {
    jsonObject.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        print('$prefix$key:');
        _printJsonObject(value, '$prefix  ');
      } else {
        print('$prefix$key: $value');
      }
    });
  }

  void addCapturedImageProcessed(String imagePath, String jsonString) {
    try {
      // Carga la imagen utilizando el paquete 'image'
      img.Image originalImage =
          img.decodeImage(File(imagePath).readAsBytesSync())!;

      List<dynamic> jsonArray = jsonDecode(jsonString);

      // Iterar a través de la lista y acceder a las propiedades de cada objeto JSON
      for (var jsonObject in jsonArray) {
        _printJsonObject(jsonObject);
        print('---'); // Separador entre objetos
      }

      List<RectangleParams> rectangles =
          []; // Crea una lista vacía para almacenar los objetos RectangleParams.

      for (var jsonObject in jsonArray) {
        String imageFilename = jsonObject['image_filename'];
        double ratio = jsonObject['ratio'].toDouble();

        print('image_filename: $imageFilename');
        print('ratio: $ratio');

        List<dynamic> detections = jsonObject['detections'];
        for (var detection in detections) {
          List<dynamic> box = detection['box'];
          String label = detection['label'] == "0"
              ? "capullo"
              : (detection['label'] == "1" ? "tallo" : "hoja");
          String placeEtiqueta = label == "capullo"
              ? "izquierda"
              : (label == "tallo" ? "izquierda" : "derecha");

          double score = detection['score'];

          int colorValueTernario = label == "tallo"
              ? img.getColor(255, 0, 0)
              : (label == "capullo"
                  ? img.getColor(0, 0, 255)
                  : img.getColor(0, 255, 0));
          String text = label == "tallo"
              ? 'Tallo: \nlargo: ${(box[3].toInt() / ratio).toStringAsFixed(1)} cm'
              : (label == "capullo"
                  ? 'Capullo: \nlargo: ${(box[3].toInt() / ratio).toStringAsFixed(1)} cm \nancho: ${(box[2].toInt() / ratio).toStringAsFixed(1)} cm'
                  : '');
          // Crear un objeto RectangleParams y agregarlo a la lista rectangles.
          RectangleParams rectangle = RectangleParams(
            x: box[0].toInt(),
            y: box[1].toInt(),
            width: box[2].toInt(),
            height:
                box[3].toInt(), // Asegúrate de tener el índice correcto aquí.
            thickness: 10,
            place: placeEtiqueta,
            colorValue: colorValueTernario,
            text: text,
          );
          rectangles
              .add(rectangle); // Agregar el objeto RectangleParams a la lista.

          print('Detection:');
          print('  box: $box');
          print('  label: $label');
          print('  score: $score');
        }
      }
      img.Image modifiedImage =
          drawRectanglesOnImage(originalImage, rectangles);
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
    } catch (error) {
      print('addCapturedImageProcessed Error : $error');
      // Puedes realizar acciones adicionales aquí, como mostrar mensajes de error.
    }
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
      String text = rectParams.text;
      String place = rectParams.place; // Nuevo parámetro "place"

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

      // Calcula las coordenadas del texto según el valor de "place"
      int textX = 0, textY = 0;
      if (place == "superior") {
        textX = x +
            width ~/ 2 -
            (text.length * 10); // Ajusta según la fuente utilizada
        textY = y - 50;
      } else if (place == "inferior") {
        textX = x + width ~/ 5; // Texto en medio del ancho de la figura
        textY = y + height + 25;
      } else if (place == "izquierda") {
        textX = x - 300;
        textY = y + height ~/ 2 - 75;
      } else if (place == "derecha") {
        textX = x + width + 10;
        textY = y + height ~/ 2 - 10;
      }

      // Agrega el texto en el lateral izquierdo

      img.drawString(modifiedImage, img.arial_48, textX, textY, text,
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
  final String place; // Texto a agregar

  RectangleParams(
      {required this.x,
      required this.y,
      required this.width,
      required this.height,
      required this.thickness,
      required this.place,
      required this.text,
      required this.colorValue});
}
