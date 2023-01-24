import 'package:my_app/providers/metodos_http.dart' as dataservice;
import 'package:my_app/models/datos_empleado.dart';
import 'dart:async';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class empleado extends StatefulWidget {
  const empleado({Key? key, required this.datosEmpleados, required this.nombre})
      : super(key: key);

  final DatosEmpleados datosEmpleados;
  final String nombre;
  @override
  State<empleado> createState() => _empleadoState();
}

enum asistencias { asistencia, noasistencia }

asistencias? _dato = asistencias.noasistencia;

asistencias? _area = asistencias.noasistencia;

String? datos = "";

String? datos2 = "";

// ignore: camel_case_types
class _empleadoState extends State<empleado> {
  Widget _volver() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(child: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ))
      ]),
    );
  }

  Widget _buildCabecera() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.datosEmpleados.nombre.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(widget.datosEmpleados.matricula.toString())),
                Container(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text(widget.datosEmpleados.area.toString())],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Turno " + widget.datosEmpleados.turno.toString())
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text(widget.datosEmpleados.ida.toString())],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContenido() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(children: [
        Expanded(
            child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Captura nombra CICE:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.datosEmpleados.captura.toString())
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Solicitud CICE:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.datosEmpleados.solicitud.toString())
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Envío CICE:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.datosEmpleados.ida.toString())
                ],
              ),
            )
          ],
        ))
      ]),
    );
  }

  Widget _buildAcciones() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(children: [
        Expanded(
            child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Asistencia:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Radio(
                      value: asistencias.asistencia,
                      groupValue: _dato,
                      onChanged: (asistencias? grupo) {
                        setState(() {
                          _dato = grupo;
                          datos = '1';
                        });
                      }),
                  Text("Si"),
                  Radio(
                      value: asistencias.noasistencia,
                      groupValue: _dato,
                      onChanged: (asistencias? grupo) {
                        setState(() {
                          _dato = grupo;
                          datos = '0';
                        });
                      }),
                  Text("NO")
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Asistencia Area:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Radio(
                      value: asistencias.asistencia,
                      groupValue: _area,
                      onChanged: (asistencias? grupo) {
                        setState(() {
                          _area = grupo;
                          datos2 = '1';
                        });
                      }),
                  Text("Si"),
                  Radio(
                      value: asistencias.noasistencia,
                      groupValue: _area,
                      onChanged: (asistencias? grupo) {
                        setState(() {
                          _area = grupo;
                          datos2 = '0';
                        });
                      }),
                  Text("NO")
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        _showAlertDialogLogout2();
                      },
                      label: const Text("Enviar Asistencia"),
                      icon: const Icon(Icons.check))
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        _showAlertDialogLogout3();
                      },
                      label: const Text("Enviar Asistencia Area"),
                      icon: const Icon(Icons.check))
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        _showAlertDialogLogout();
                      },
                      label: const Text("Enviar correo de Problema"),
                      icon: const Icon(Icons.mail_outline))
                ],
              ),
            )
          ],
        ))
      ]),
    );
  }

  _showAlertDialogLogout() {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text('Mandar correo de Problema'),
            content: const Text('¿Desea mandar el correo?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No, cancelar')),
              TextButton(
                  onPressed: () {
                    _postcorreo();
                    Navigator.pop(context);
                  },
                  child: const Text('Si, enviar el correo'))
            ],
          );
        });
  }

  _showAlertDialogLogout2() {
    showDialog<String>(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text('Asistencia'),
            content: const Text('¿Esta seguro de mandar la Asistencia?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No, cancelar')),
              TextButton(
                  onPressed: () {
                    _postasistencia();
                    Navigator.pop(context);
                  },
                  child: const Text('Si, enviar asistencia'))
            ],
          );
        });
  }

  _showAlertDialogLogout3() {
    showDialog<String>(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text('Asistencia de Area'),
            content:
                const Text('¿Esta seguro de mandar la Asistencia de Area?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No, cancelar')),
              TextButton(
                  onPressed: () {
                    _postasistarea();
                    Navigator.pop(context);
                  },
                  child: const Text('Si, enviar asistencia'))
            ],
          );
        });
  }

  _postasistarea() async {
    try {
      dataservice.postasistarea(
        datos2.toString(),
        widget.datosEmpleados.turno.toString(),
        widget.datosEmpleados.matricula.toString(),
        widget.datosEmpleados.ida.toString(),
      );
      _showSnackBar2();
    } catch (exception) {
      _showAlertDialogErrors(exception.toString());
    }
  }

  _postasistencia() async {
    try {
      dataservice.postasistencia(
        widget.nombre.toString(),
        widget.datosEmpleados.matricula.toString(),
        widget.datosEmpleados.ida.toString(),
        datos.toString(),
        widget.datosEmpleados.turno.toString(),
      );
      _showSnackBar();
    } catch (exception) {
      _showAlertDialogErrors(exception.toString());
    }
  }

  _postcorreo() async {
    try {
      dataservice.postcorreo(
          widget.datosEmpleados.nombre.toString(),
          widget.datosEmpleados.matricula.toString(),
          widget.datosEmpleados.area.toString(),
          widget.datosEmpleados.turno.toString(),
          widget.datosEmpleados.ida.toString(),
          widget.datosEmpleados.captura.toString(),
          widget.datosEmpleados.solicitud.toString(),
          widget.datosEmpleados.ida.toString());
      _showSnackBar3();
    } catch (exception) {
      _showAlertDialogErrors(exception.toString());
    }
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
          Text('Se envio la asistencia del empleado')
        ]),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 5000),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        )));
  }

  _showSnackBar2() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: const <Widget>[
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 4),
          Text('Se envio la asistencia del Area')
        ]),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 5000),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        )));
  }

  _showSnackBar3() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: const <Widget>[
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 4),
          Text('Se envio el correo')
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        _volver(),
        _buildCabecera(),
        _buildContenido(),
        _buildAcciones()
      ],
    ));
  }
}
