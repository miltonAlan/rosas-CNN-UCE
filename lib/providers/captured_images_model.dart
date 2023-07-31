import 'package:flutter/foundation.dart';

class CapturedImagesModel extends ChangeNotifier {
  List<String> _capturedImages = [];

  List<String> get capturedImages => _capturedImages;

  void addCapturedImage(String imagePath) {
    _capturedImages.add(imagePath);
    notifyListeners();
  }

  void removeCapturedImage(int index) {
    _capturedImages.removeAt(index);
    notifyListeners();
  }
}
