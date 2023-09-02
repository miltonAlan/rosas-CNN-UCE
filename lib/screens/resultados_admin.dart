import 'package:ejemplo/providers/firebase_ejemplo.dart';
import 'package:ejemplo/screens/drawer_modular.dart';
import 'package:ejemplo/screens/text_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar provider aquí

class ResultadosAdmin extends StatefulWidget {
  @override
  _MiPantallaDataTableState createState() => _MiPantallaDataTableState();
}

class _MiPantallaDataTableState extends State<ResultadosAdmin> {
  List<String> imagenes = [];
  int selectedRow = -1; // Variable para rastrear la fila seleccionada.
  List<String> dropdownOptions = [
    'trabajador 1',
    'trabajador 2',
    'trabajador 3',
    'Todos los empleados'
  ];
  String dropdownValue = 'trabajador 1'; // Valor predeterminado
  String textoParametrizable =
      'Texto predeterminado'; // Puedes establecer el valor inicial según tus necesidades.

  @override
  void initState() {
    super.initState();
    // Llamamos a la función para obtener las imágenes cuando se carga la pantalla.
    obtenerImagenes().then((listaImagenes) {
      setState(() {
        imagenes = listaImagenes;
      });
    });
  }

  void _showImageDetails(int index) {
    setState(() {
      selectedRow = index; // Actualizar el índice de la fila seleccionada.
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalle de la Rosa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mostrar la imagen a detalle (puedes ajustar el tamaño según sea necesario).
              Image.network(
                imagenes[index],
                width: 300,
                height: 300,
              ),
              SizedBox(height: 10),
              Text('Texto 1: Datos de la columna 1'),
              Text('Texto 2: Datos de la columna 2'),
              Text('Texto 3: Datos de la columna 3'),
              Text('Texto 4: Datos de la columna 4'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el AlertDialog.
                setState(() {
                  selectedRow = -1; // Restablecer la fila seleccionada.
                });
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String rol =
        Provider.of<TestResultProvider>(context).rol ?? "Rol no definido";
    final String nombreTrabajador =
        Provider.of<TestResultProvider>(context).nombreTrabajador ??
            "Nombre no definido";

    return Scaffold(
      appBar: AppBar(
        title: Text('Visualización de resultados \npara el administrador'),
      ),
      drawer:
          AppDrawerAndNavigation.buildDrawer(context, rol, nombreTrabajador),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Cambia a desplazamiento vertical
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical:
                      1.0), // Espaciado entre el DropdownButton y el nuevo widget
              child: Column(
                children: [
                  Text(
                      'cantidad rosas clase 50 cm............................................'),
                  Text(
                      'cantidad rosas clase 60 cm............................................'),
                  Text(
                      'cantidad rosas clase 70 cm............................................'),
                  Text(
                      'cantidad rosas clase 80 cm............................................'),
                ],
              ),
            ),
            // DropdownButton
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  // Aquí puedes actualizar tus datos según la opción seleccionada.
                });
              },
              items: dropdownOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            DataTable(
              showCheckboxColumn:
                  false, // Esto oculta las casillas de selección
              horizontalMargin: 5, // Ajusta este valor según tus preferencias
              dividerThickness:
                  2, // Establece el grosor de las líneas divisorias
              columns: [
                DataColumn(label: Text('Miniatura')),
                DataColumn(label: Text('Texto 1')),
                DataColumn(label: Text('Texto 2')),
                DataColumn(label: Text('Texto 3')),
              ],
              rows: imagenes.asMap().entries.map((entry) {
                final index = entry.key;
                final imageUrl = entry.value;

                return DataRow(
                  selected: selectedRow == index,
                  onSelectChanged: (selected) {
                    if (selected != null && selected) {
                      _showImageDetails(index);
                    }
                  },
                  cells: [
                    DataCell(
                      // Mostrar una miniatura o el icono de checklist si la URL de la imagen está vacía.
                      imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 75, // Define el ancho de la miniatura.
                            )
                          : Icon(Icons.ac_unit_rounded),
                    ),
                    DataCell(Text('Texto 1...')),
                    DataCell(Text('Texto 2')),
                    DataCell(Text('Texto 3')),
                  ],
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                textoParametrizable,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
