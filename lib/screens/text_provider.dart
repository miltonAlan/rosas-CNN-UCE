import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TestResultProvider extends ChangeNotifier {
  String _text = '';

  String get text => _text;

  set text(String newText) {
    _text = newText;
    notifyListeners();
  }

  String _testResult = '';

  String get testResult => _testResult;

  set testResult(String newText) {
    _testResult = newText;
    notifyListeners();
  }
}
