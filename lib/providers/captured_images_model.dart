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
    _capturedImagesProcessed
        .add(imagePath); // Función para agregar a la nueva lista
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
}
