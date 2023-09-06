import 'package:ejemplo/providers/firebase_ejemplo.dart';
import 'package:ejemplo/screens/drawer_modular.dart';
import 'package:ejemplo/screens/text_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar provider aquí
import 'package:intl/intl.dart';

class ResultadosAdmin extends StatefulWidget {
  @override
  _MiPantallaDataTableState createState() => _MiPantallaDataTableState();
}

class _MiPantallaDataTableState extends State<ResultadosAdmin> {
  List<String> imagenesTrabajador = [];
  int selectedRow = -1; // Variable para rastrear la fila seleccionada.
  List<String> dropdownOptions = [];
  String dropdownValue = "Todos los trabajadores";
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
          title: Text('Detalle de la Imagen'),
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

    // Obtener los nombres de los trabajadores y actualizar las opciones del DropdownButton
    obtenerNombresTrabajadores().then((nombres) {
      setState(() {
        dropdownOptions = nombres;
        // dropdownValue = nombres.isNotEmpty ? nombres[0] : '';
      });

      // Luego, puedes cargar las mediciones del trabajador seleccionado, por ejemplo:
      // _cargarMedicionesTrabajador(nombreTrabajador);
    });
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

  Future<void> _cargarMedicionesTodosTrabajadores() async {
    try {
      medicionesTrabajador = await obtenerMedicionesTrabajadores();
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
    List<String> textosSuperiores = [];
    final String rol =
        Provider.of<TestResultProvider>(context).rol ?? "Rol no definido";
    final String nombreTrabajador =
        Provider.of<TestResultProvider>(context).nombreTrabajador ??
            "Nombre no definido";
    // Calcular la suma de los valores de la columna "Conteo"
    num totalRosasProcesadas = 0;
    for (var medicion in medicionesTrabajador) {
      final rosasCount = (medicion['rosas'] ?? []).length;
      totalRosasProcesadas += rosasCount.toInt(); // Convertir a int
    }
    setState(() {
      textosSuperiores.add(
          "Total de rosas procesadas: $totalRosasProcesadas"); // Agrega un nuevo texto
    });

    Map<String, int> contadoresRangos = {};

    for (Map<String, dynamic> medicion in medicionesTrabajador) {
      if (medicion['rosas'] != null) {
        for (int i = 0; i < medicion['rosas'].length; i++) {
          final altura = medicion['rosas'][i]['altura'];

          // Calcular el rango al que pertenece la altura
          int rango = ((altura) / 10).floor() * 10;
          // int rango = ((altura) / 10).ceil() * 10;

          // Incrementar el contador correspondiente al rango
          contadoresRangos.update('$rango', (value) => value + 1,
              ifAbsent: () => 1);
        }
      }
    }
    List<Widget> textosRangos = [];
    contadoresRangos.forEach((rango, cantidad) {
      setState(() {
        textosSuperiores
            .add("Cantidad entre $rango y ${int.parse(rango) + 10}: $cantidad");
      });
    });
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
                children: textosSuperiores.map((texto) {
                  return Text(
                    texto,
                    style: TextStyle(
                      fontSize: 18.0, // Tamaño de fuente deseado
                      // Puedes ajustar otros atributos de estilo aquí si es necesario
                    ),
                  );
                }).toList(),
              ),
            ),
// Modifica el Row que contiene el DropdownButton en el método build
            Row(
              children: [
                Text(
                  'Escoja un trabajador: ',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                DropdownButton<String>(
                  // value: "Todos los trabajadores",
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      // Actualiza tus datos según la opción seleccionada.
                      if (newValue == "Todos los trabajadores") {
                        // Cargar todas las mediciones para todos los trabajadores
                        _cargarMedicionesTodosTrabajadores();
                      } else {
                        // Cargar mediciones solo para el trabajador seleccionado
                        _cargarMedicionesTrabajador(newValue);
                      }
                    });
                  },
                  items: <String>[...dropdownOptions].map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
              ],
            ),
            DataTable(
              showCheckboxColumn: true, // Esto oculta las casillas de selección
              horizontalMargin: 5, // Ajusta este valor según tus preferencias
              dividerThickness:
                  2, // Establece el grosor de las líneas divisorias
              columns: [
                DataColumn(label: Text('Imagen')),
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Unidades')),
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
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Alineación de los botones
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (selectedRow != -1) {
                      // Accede a los datos de la fila seleccionada
                      final selectedMedicion =
                          medicionesTrabajador[selectedRow];
                      final imageUrl = selectedMedicion['imageUrl'];

                      // Muestra un cuadro de diálogo de confirmación
                      bool confirmarBorrado = await showDialog(
                        context:
                            context, // Asegúrate de tener acceso al contexto actual
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar borrado'),
                            content: Text(
                                '¿Está seguro de que desea borrar esta imagen?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Cierra el cuadro de diálogo y retorna false
                                },
                              ),
                              TextButton(
                                child: Text('Borrar'),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      true); // Cierra el cuadro de diálogo y retorna true
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmarBorrado == true) {
                        bool imagenBorrada = await borrarImagen(imageUrl);
                        if (imagenBorrada) {
                          if (dropdownValue == "Todos los trabajadores") {
                            // Cargar todas las mediciones para todos los trabajadores
                            _cargarMedicionesTodosTrabajadores();
                          } else {
                            // Cargar mediciones solo para el trabajador seleccionado
                            _cargarMedicionesTrabajador(dropdownValue);
                          }
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 1, horizontal: 1), // Ajusta el padding
                  ),
                  child: Text('Borrar Imagen Seleccionada'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (true) {
                      // Accede a los datos de la fila seleccionada
                      // Muestra un cuadro de diálogo de confirmación
                      bool confirmarBorrado = await showDialog(
                        context:
                            context, // Asegúrate de tener acceso al contexto actual
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar borrado'),
                            content: Text(
                                '¿Está seguro de que desea borrar todas sus imagenes? \n Este proceso no se puede deshacer.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Cierra el cuadro de diálogo y retorna false
                                },
                              ),
                              TextButton(
                                child: Text('Borrar'),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      true); // Cierra el cuadro de diálogo y retorna true
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmarBorrado == true) {
                        if (dropdownValue == "Todos los trabajadores") {
                          // Cargar todas las mediciones para todos los trabajadores
                          await borrarImagenesTrabajadores();
                          _cargarMedicionesTodosTrabajadores();
                        } else {
                          // Cargar mediciones solo para el trabajador seleccionado
                          bool imagenBorrada =
                              await borrarImagenesTrabajador(nombreTrabajador);
                          if (imagenBorrada) {
                            _cargarMedicionesTrabajador(dropdownValue);
                          }
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 1, horizontal: 1), // Ajusta el padding
                  ),
                  child: Text('Borrar todas las mediciones'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
