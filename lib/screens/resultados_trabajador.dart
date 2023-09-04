import 'package:ejemplo/providers/firebase_ejemplo.dart';
import 'package:ejemplo/screens/drawer_modular.dart';
import 'package:ejemplo/screens/text_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar provider aquí
import 'package:intl/intl.dart';

class ResultadosTrabajador extends StatefulWidget {
  @override
  _MiPantallaDataTableState createState() => _MiPantallaDataTableState();
}

class _MiPantallaDataTableState extends State<ResultadosTrabajador> {
  List<String> imagenesTrabajador = [];
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
  List<Map<String, dynamic>> medicionesTrabajador = [];

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
                imagenesTrabajador[index],
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Mover el acceso al Provider aquí, después de que initState haya completado.
    final String nombreTrabajador =
        Provider.of<TestResultProvider>(context).nombreTrabajador ??
            "Nombre no definido";

    _cargarMedicionesTrabajador(nombreTrabajador);
  }

  Future<void> _cargarMedicionesTrabajador(String nombreTrabajador) async {
    try {
      medicionesTrabajador =
          await obtenerMedicionesTrabajador(nombreTrabajador);
      List<String> imagenesTrabajadorObtenidas = [];
      // Imprimir las mediciones
      for (Map<String, dynamic> medicion in medicionesTrabajador) {
        imagenesTrabajadorObtenidas.add(medicion['imageUrl']);
        print('Fecha: ${medicion['fecha']}');
        print('ImageUrl: ${medicion['imageUrl']}');
        print('Nombre Trabajador: ${medicion['nombreTrabajador']}');
        print('Rosas:');
        if (medicion['rosas'] != null) {
          for (int i = 0; i < medicion['rosas'].length; i++) {
            print('  $i:');
            print('    Altura: ${medicion['rosas'][i]['altura']}');
          }
        } else {
          print('    Sin datos de rosas');
        }
        print('\n');
      }
      setState(() {
        imagenesTrabajador = imagenesTrabajadorObtenidas;
      });
    } catch (error) {}
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
        title: Text(
            'Visualización de resultados \npara el $rol: $nombreTrabajador'),
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
            DataTable(
              showCheckboxColumn: true, // Esto oculta las casillas de selección
              horizontalMargin: 5, // Ajusta este valor según tus preferencias
              dividerThickness:
                  2, // Establece el grosor de las líneas divisorias
              columns: [
                DataColumn(label: Text('Imagen')),
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Conteo')),
              ],
              rows: medicionesTrabajador.asMap().entries.map((entry) {
                final index = entry.key;
                final medicion = entry.value;
                final imageUrl = medicion['imageUrl'];
                final fechastr = medicion['fecha'];
                final rosasCount = (medicion['rosas'] ?? []).length;
                late String
                    formattedFecha; // Declarar la variable de fecha formateada

                try {
                  final formatoFecha = DateFormat('yyyy_MM_d_H');

                  final fecha = formatoFecha.parse(
                      fechastr); // Intentar convertir la cadena en DateTime

                  formattedFecha =
                      DateFormat('dd/MMMM/yyyy HH:mm').format(fecha);
                } catch (e) {
                  // Manejar el error si la cadena no es una fecha válida
                  formattedFecha = 'Fecha inválida';
                }

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
                    DataCell(Text(formattedFecha)),
                    DataCell(Text(rosasCount.toString())),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
