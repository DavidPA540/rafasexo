import 'package:flutter/material.dart';
import 'package:my_app/providers/metodos_http.dart' as dataservice;
import 'package:my_app/models/datos_empleado.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:my_app/screens/empleado.dart';
import 'package:http/http.dart' as http;

class UltimasActualizaciones extends StatefulWidget {
  final String nombre;

  const UltimasActualizaciones({Key? key, required this.nombre})
      : super(key: key);

  @override
  State<UltimasActualizaciones> createState() => _UltimasActualizacionesState();
}

class _UltimasActualizacionesState extends State<UltimasActualizaciones> {
  List<DatosEmpleados> _listadoUltimasActualizaciones = [];
  bool isLoading = false;

  DateTime _mydatetime = DateTime.now();

  String fecha = "Seleccione fecha";

  List<String> listaturnos = [];
  String? selectedTurno = '';

  List<String> especi = [];
  String? selectedcatego = '';

  final controller = TextEditingController();

  Widget _buildListView() {
    const _style = TextStyle(fontSize: 25);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            /* const SizedBox(
              height: 10,
            ),*/
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // the search tuition
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: MediaQuery.of(context).size.height * .08,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              DateTime? _newDate = await showDatePicker(
                                context: context,
                                initialDate: _mydatetime,
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2110),
                              );
                              if (_newDate != null) {
                                setState(() {
                                  _mydatetime = _newDate;
                                  fecha =
                                      "${_mydatetime.day}-${_mydatetime.month}-${_mydatetime.year}";
                                });
                              }
                              _getTurnos(fecha);
                              _getespeci(fecha);
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(fecha),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(238, 117, 35, 1),
                                maximumSize: MediaQuery.of(context).size),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // The calendar picker
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: MediaQuery.of(context).size.height * .1,
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: controller,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Matricula empleado',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 3,
                                    color: Color.fromRGBO(238, 117, 35, 1)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // The dropdown Button Specialities
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: MediaQuery.of(context).size.height * .1,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    width: 3,
                                    color: Color.fromRGBO(238, 117, 35, 1)),
                              ),
                            ),
                            value: selectedcatego,
                            items: especi
                                .map((especi) => DropdownMenuItem<String>(
                                      value: especi,
                                      child: Text(especi,
                                          textAlign: TextAlign.justify),
                                    ))
                                .toList(),
                            onChanged: (especi) =>
                                setState(() => selectedcatego = especi),
                            hint: Text('Categorias'),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: MediaQuery.of(context).size.height * .1,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    width: 3,
                                    color: Color.fromRGBO(238, 117, 35, 1)),
                              ),
                            ),
                            value: selectedTurno,
                            items: listaturnos
                                .map((turno) => DropdownMenuItem<String>(
                                      value: turno,
                                      child: Text('Turno ' + turno,
                                          textAlign: TextAlign.justify),
                                    ))
                                .toList(),
                            onChanged: (turno) =>
                                setState(() => selectedTurno = turno),
                            hint: Text('Turnos'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: MediaQuery.of(context).size.height * .05,
                        child: ElevatedButton.icon(
                          onPressed: () => setState(() {
                            _postconsultas();
                          }),
                          icon: const Icon(Icons.manage_search),
                          label: Text("Buscar"),
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(238, 117, 35, 1)),
                        )),
                    /*  const SizedBox(
                      width: 30,
                    ),*/
                  ]),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * .5,
                child: ListView.builder(
                    itemCount: _listadoUltimasActualizaciones.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(_listadoUltimasActualizaciones[index]
                                .nombre
                                .toString()),
                            subtitle: Text(
                                "${_listadoUltimasActualizaciones[index].matricula}\nTurno "
                                "${_listadoUltimasActualizaciones[index].turno} | ${_listadoUltimasActualizaciones[index].ida}"),
                            isThreeLine: true,
                            dense: true,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => empleado(
                                        datosEmpleados:
                                            _listadoUltimasActualizaciones[
                                                index],
                                        nombre: widget.nombre,
                                      )));
                            },
                          ));
                    }),
              ),
            )),
          ],
        ),
      ),
    );
  }

  _postconsultas() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<DatosEmpleados> listEstadoManiobras = await dataservice.postconsulta(
          fecha,
          selectedTurno.toString(),
          controller.text,
          selectedcatego.toString());
      setState(() {
        _listadoUltimasActualizaciones = listEstadoManiobras;
        isLoading = false;
      });
      if (_listadoUltimasActualizaciones.isEmpty) {
        _showSnackBar3();
      } else {
        _showSnackBar();
      }
    } catch (exception) {
      setState(() {
        isLoading = false;
      });
      _showAlertDialogErrors(exception.toString());
    }
  }

  _getTurnos(String fechaseleccionada) async {
    try {
      setState(() {
        isLoading = true;
      });
      listaturnos = await dataservice.getTurnos(fechaseleccionada);
      setState(() {
        if (listaturnos.isNotEmpty) {
          selectedTurno = listaturnos[0];
        } else {
          _showAlertDialogAlerts('No se encontraron Turnos');
        }
        isLoading = false;
      });
    } catch (exception) {
      isLoading = false;
    }
  }

  _getespeci(String fechaseleccionada) async {
    especi = await dataservice.getespeci(fechaseleccionada);
    setState(() {
      if (especi.isNotEmpty) {
        selectedcatego = especi[0];
      } else {
        _showAlertDialogAlerts('No se encontraron Categorias');
      }
    });
  }

  _showAlertDialogAlerts(String mensaje) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text('Alerta!'),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'))
            ],
          );
        });
  }

  _showSnackBar3() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: const <Widget>[
          Icon(Icons.cancel, color: Colors.white),
          SizedBox(width: 4),
          Text('No se encontro nombramientos')
        ]),
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 5000),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        )));
  }

  _showAlertDialogErrors(String mensaje) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text('Error!'),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'))
            ],
          );
        });
  }

  _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: const <Widget>[
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 4),
          Text('Se consulto la lista de nombramientos')
        ]),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 5000),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        )));
  }

  @override
  void initState() {
    //_postconsultas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(0, 95, 184, 1)))
          : RefreshIndicator(
              onRefresh: () {
                return _postconsultas();
              },
              child: Center(
                child: _buildListView(),
              )),
    );
  }
}
