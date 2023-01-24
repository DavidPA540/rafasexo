// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_app/models/respuesta_global.dart';
import 'package:my_app/providers/metodos_http.dart' as dataservice;
import 'package:flutter/services.dart';
import 'credencial_empleado.dart';

class Relacion extends StatefulWidget {
  final String nombre;
  const Relacion({Key? key, required this.nombre}) : super(key: key);

  @override
  State<Relacion> createState() => _Relacion();
}

class _Relacion extends State<Relacion> {
  bool isVisible = false;
  late RespuestaGlobal respuestaGlobal = RespuestaGlobal();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final controller = TextEditingController();
  late final controller2 = TextEditingController();
  late final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  String? selectedValue, selectedValue2;

  List<String> selectvalueX = ['Consultar empleado', 'Relacionar empleado'];

  @override
  void initState() {
    configInit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void configInit() {
    selectedValue2 = selectvalueX.first;

    isVisible = true;
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "1",
        child: Text("CICE"),
      ),
      const DropdownMenuItem(
        value: "15",
        child: Text("SEMAVE"),
      ),
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
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            _option1(),
            const SizedBox(height: 10),
            _option2(),
            const SizedBox(
              height: 10,
            ),
            _option3(),
            _buttonSelect(),
          ],
        ),
      ),
    );
  }

  SizedBox _buttonSelect() {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  isVisible
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 55,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _getrelacion();
                                }
                              },
                              label: const Text("Buscar"),
                              icon: const Icon(Icons.search)),
                        )
                      : const SizedBox(),
                  !isVisible
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 55,
                          child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _showAlertDialogLogout();
                                }
                              },
                              label: const Text("Relacionar"),
                              icon: const Icon(Icons.check)),
                        )
                      : const SizedBox(),
                ]),
          ),
        ],
      ),
    );
  }

  Form _option3() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
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
                            borderSide: const BorderSide(
                                width: 3,
                                color: Color.fromRGBO(238, 117, 35, 1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !isVisible
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * .9,
                            height: MediaQuery.of(context).size.height * .1,
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
                                  borderSide: const BorderSide(
                                      width: 3,
                                      color: Color.fromRGBO(238, 117, 35, 1)),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox _option2() {
    return SizedBox(
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
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color.fromRGBO(238, 117, 35, 1),
                        width: 3)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Empresa"),
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
    );
  }

  SizedBox _option1() {
    return SizedBox(
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color.fromRGBO(238, 117, 35, 1),
                          width: 3)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue2,
                      onChanged: (String? newValue) {
                        if (newValue == selectvalueX.first) {
                          isVisible = true;
                        } else {
                          isVisible = false;
                        }
                        selectedValue2 = newValue!;
                        setState(() {});
                      },
                      items: selectvalueX
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )),
            ],
          ),
        ],
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
