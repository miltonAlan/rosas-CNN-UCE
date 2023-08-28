import 'package:ejemplo/screens/text_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // Importa el paquete provider

class ConfigScreen extends StatelessWidget {
  final TextEditingController _urlController = TextEditingController();

  Future<void> _testUrl(BuildContext context) async {
    final testResultProvider =
        Provider.of<TestResultProvider>(context, listen: false);

    String url = _urlController.text;
    print("XXXXXXXXXjXX" + url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        testResultProvider.testResult = 'Estado 200 OK';
        testResultProvider.text = url;
      } else {
        testResultProvider.testResult = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      testResultProvider.testResult = 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'Ingrese la URL'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testUrl(context),
              child: Text('Probar URL'),
            ),
            SizedBox(height: 16),
            Consumer<TestResultProvider>(
              builder: (context, testResultProvider, _) => Text(
                testResultProvider.testResult,
                style: TextStyle(
                  color: testResultProvider.testResult.startsWith('Error')
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
