import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:my_app/models/respuesta_global.dart';
import 'package:my_app/providers/metodos_http.dart' as dataservice;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:my_app/screens/empleado.dart';
import 'package:http/http.dart' as http;

import 'credencial_empleado.dart';

class relacion extends StatefulWidget {
  final String nombre;
  const relacion({Key? key, required this.nombre}) : super(key: key);

  @override
  State<relacion> createState() => _relacion();
}

class _relacion extends State<relacion> {
  bool isVisible = false;
  bool isVisible2 = true;
  late RespuestaGlobal respuestaGlobal = RespuestaGlobal();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final controller = TextEditingController();
  late final controller2 = TextEditingController();
  late final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  String? selectedValue;
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("CICE"), value: "1"),
      DropdownMenuItem(child: Text("SEMAVE"), value: "15"),
    ];
    return menuItems;
  }

  String? selectedValue2;
  List<DropdownMenuItem<String>> get dropdownItems2 {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Consultar empleado"), value: "1"),
      DropdownMenuItem(child: Text("Relacionar empleado"), value: "0"),
    ];
    return menuItems;
  }

  _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: const <Widget>[
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 4),
          Text('Relación empleado consultada')
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
          Icon(Icons.cancel, color: Colors.white),
          SizedBox(width: 4),
          Text('No se encontro la relacion')
        ]),
        backgroundColor: Colors.red,
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
          Text('Relación empleado Realizada')
        ]),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 5000),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        )));
  }

  _showAlertDialogLogout() {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text('Relacionar empleado - credencial'),
            content: const Text(
                'Se realizará la relación empleado - credencial, ¿Desea continuar?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No, regresar')),
              TextButton(
                  onPressed: () {
                    _postrelacionar();
                    controller2.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Si, relacionar'))
            ],
          );
        });
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

  _postrelacionar() async {
    try {
      setState(() {
        isLoading = true;
      });
      respuestaGlobal = await dataservice.postrelacionar(
          selectedValue!, controller2.text, controller.text);
      setState(() {
        isLoading = false;
      });
      _showSnackBar2();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => credencial_empleado(
              respuestaGlobal: respuestaGlobal, nombre: widget.nombre)));
      controller2.clear();
      controller.clear();
    } catch (exception) {
      _showAlertDialogErrors(exception.toString());
    }
  }

  _getrelacion() async {
    try {
      setState(() {
        isLoading = true;
      });
      respuestaGlobal =
          await dataservice.getrelacion(selectedValue!, controller2.text);
      setState(() {
        isLoading = false;
      });
      if (respuestaGlobal.empleado?.numero == 0) {
        _showSnackBar3();
      } else {
        _showSnackBar();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => credencial_empleado(
                respuestaGlobal: respuestaGlobal, nombre: widget.nombre)));
      }
    } catch (exception) {
      _showAlertDialogErrors(exception.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildtodo() {
    const _style = TextStyle(fontSize: 25);
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * .9,
                            height: MediaQuery.of(context).size.height * .09,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Color.fromRGBO(238, 117, 35, 1),
                                    width: 3)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text("Accion"),
                                value: selectedValue2,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (selectedValue2 == "1") {
                                      
                                      isVisible = true;
                                      isVisible2 = false;
                                      }else{
                                      isVisible = false;
                                      isVisible2 = true;  
                                      }
                                     
                                    selectedValue2 = newValue!;
                                  });
                                },
                                items: dropdownItems2,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          height: MediaQuery.of(context).size.height * .09,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Color.fromRGBO(238, 117, 35, 1),
                                  width: 3)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("Empresa"),
                              value: selectedValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              },
                              items: dropdownItems,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .9,
                                height: MediaQuery.of(context).size.height * .1,
                                child: TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: controller2,
                                  validator: ((value) {
                                    if (value!.isEmpty) {
                                      return "Tiene que colocar la matricula";
                                    }
                                    return null;
                                  }),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.search),
                                    hintText: 'Matricula',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          width: 3,
                                          color:
                                              Color.fromRGBO(238, 117, 35, 1)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                                  width: MediaQuery.of(context).size.width * .9,
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  child: TextFormField(
                                    controller: controller,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: ((value2) {
                                      if (value2!.isEmpty) {
                                        return "Tiene que colocar la Credencial";
                                      }
                                      return null;
                                    }),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: 'Folio Credencial',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Color.fromRGBO(
                                                238, 117, 35, 1)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Visibility(
                                visible: isVisible2,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .4,
                                  height:
                                      MediaQuery.of(context).size.height * .08,
                                  child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _getrelacion();
                                        }
                                      },
                                      label: const Text("Buscar"),
                                      icon: const Icon(Icons.search)),
                                )),
                            Visibility(
                                visible: isVisible,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .4,
                                  height:
                                      MediaQuery.of(context).size.height * .08,
                                  child: ElevatedButton.icon(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _showAlertDialogLogout();
                                        }
                                      },
                                      label: const Text("Relacionar"),
                                      icon: const Icon(Icons.check)),
                                )),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                return _getrelacion();
              },
              child: Center(
                child: _buildtodo(),
              )),
    );
  }
}
