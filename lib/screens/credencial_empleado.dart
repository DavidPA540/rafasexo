import 'package:my_app/providers/metodos_http.dart' as dataservice;
import 'package:my_app/models/respuesta_global.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/alta_matricula.dart';

// ignore: camel_case_types
class credencial_empleado extends StatefulWidget {
  const credencial_empleado(
      {Key? key, required this.respuestaGlobal, required this.nombre})
      : super(key: key);

  final RespuestaGlobal respuestaGlobal;
  final String nombre;
  @override
  State<credencial_empleado> createState() => _empleadoState();
}

bool isVisible = false;
bool isLoading = false;
final controller = TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// ignore: camel_case_types
class _empleadoState extends State<credencial_empleado> {
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
                    "${widget.respuestaGlobal.empleado?.nombre} ${widget.respuestaGlobal.empleado?.apellidoPaterno} ${widget.respuestaGlobal.empleado?.apellidoMaterno}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                        "Empresa: ${widget.respuestaGlobal.empleado?.empresa?.nombre.toString()} | Número empleado: ${widget.respuestaGlobal.empleado?.numero}")),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Estado: ${widget.respuestaGlobal.empleado?.estado.toString()}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Credencial: ${widget.respuestaGlobal.empleado?.credencial.toString()}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Teléfono: ${widget.respuestaGlobal.empleado?.telefono.toString()}")
                    ],
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
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: isVisible,
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Edición de teléfono",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )),
                      Visibility(
                        visible: isVisible,
                        child: Form(
                          key: _formKey,
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              controller: controller,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: ((value2) {
                                if (value2!.isEmpty) {
                                  return "Tiene que colocar un Telefono";
                                }
                                return null;
                              }),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone),
                                hintText: 'Teléfono',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 3,
                                      color: Color.fromRGBO(238, 117, 35, 1)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: isVisible,
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: 120,
                                    height: 40,
                                    child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _showAlertDialogLogout();
                                          }
                                        },
                                        label: const Text("Guardar"),
                                        icon: const Icon(Icons.save)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 120,
                                    height: 40,
                                    child: ElevatedButton.icon(
                                        onPressed: () => setState(
                                            () => isVisible = !isVisible),
                                        label: const Text("Cancelar"),
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Color.fromARGB(255, 255, 0, 0)),
                                        icon: const Icon(Icons.cancel)),
                                  ),
                                ]),
                          )),
                    ],
                  ),
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
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 60,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            _showAlertDialogLogout2();
                          },
                          label: const Text("Eliminar Relacion"),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 0, 0)),
                          icon: const Icon(Icons.delete)),
                    ),
                    Container(
                      width: 120,
                      height: 60,
                      child: ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => isVisible = !isVisible),
                          label: const Text("Editar Teléfono"),
                          icon: const Icon(Icons.edit)),
                    ),
                  ]),
            ),
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
            title: const Text('Actualizar teléfono'),
            content: const Text(
                'Se actualizará el número de teléfono, ¿Desea continuar?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No, regresar')),
              TextButton(
                  onPressed: () {
                    _posttelefono();
                    controller.clear();
                    isVisible = !isVisible;
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                      return new credencial_empleado(
                          respuestaGlobal: widget.respuestaGlobal,
                          nombre: widget.nombre);
                    }));
                  },
                  child: const Text('Si, actualizar'))
            ],
          );
        });
  }

  _showAlertDialogLogout2() {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text('Eliminar relación'),
            content: const Text(
                'Se eliminará la relación empleado - credencial, ¿Desea continuar?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No, regresar')),
              TextButton(
                  onPressed: () {
                    controller.clear();
                    _posteliminar();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Si, eliminar'))
            ],
          );
        });
  }

  _posttelefono() async {
    try {
      setState(() {
        isLoading = true;
      });
      dataservice.posttelefono(
          "${widget.respuestaGlobal.empleado?.empresa?.id.toString()}",
          "${widget.respuestaGlobal.empleado?.numero}",
          "${widget.respuestaGlobal.empleado?.credencial.toString()}",
          controller.text);

      setState(() {
        isLoading = false;
      });
      _showSnackBar2();
    } catch (exception) {
      _showAlertDialogErrors(exception.toString());
    }
  }

  _posteliminar() async {
    try {
      setState(() {
        isLoading = true;
      });
      dataservice.posteliminar(
        "${widget.respuestaGlobal.empleado?.empresa?.id.toString()}",
        "${widget.respuestaGlobal.empleado?.numero}",
        "${widget.respuestaGlobal.empleado?.credencial.toString()}",
      );
      setState(() {
        isLoading = false;
      });
      _showSnackBar();
    } catch (exception) {
      _showAlertDialogErrors(exception.toString());
    }
  }

  _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: const <Widget>[
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 4),
          Text('Se ha sido eliminada con éxito.')
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
          Text('El teléfono se actualizó correctamente.')
        ]),
        backgroundColor: Colors.green,
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

  Widget _buildtodo() {
    return Scaffold(
        body: ListView(
      children: [
        _volver(),
        _buildCabecera(),
        _buildAcciones(),
        _buildContenido()
      ],
    ));
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
                return _posteliminar();
              },
              child: Center(
                child: _buildtodo(),
              )),
    );
  }
}
