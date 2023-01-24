import 'package:flutter/material.dart';
import 'package:my_app/screens/alta_matricula.dart';
import 'package:my_app/screens/empleado.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/screens/ultimas_actualizaciones.dart';
import 'dart:async';

class Menu extends StatefulWidget {
  final String nombre;
  final String usuario;

  const Menu({Key? key, required this.nombre, required this.usuario})
      : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String _titulo = 'Nombramientos';
  int _selectDrawerItem = 0;

  _getDrawerItemWidget(int index) {
    switch (index) {
      case 0:
        return UltimasActualizaciones(
          nombre: widget.usuario,
        );
      case 1:
        return Relacion(
          nombre: widget.usuario,
        );
    }
  }

  _onSelectItem(int index) {
    Navigator.pop(context);
    setState(() {
      _selectDrawerItem = index;
      switch (index) {
        case 0:
          _titulo = 'Nombramientos';
          break;
        case 1:
          _titulo = 'Relacionar Credencial';
          break;
      }
    });
  }

  _getFirstCharacter(String nombre) {
    return nombre[0].toUpperCase();
  }

  _showAlertDialogLogout() {
    showDialog<String>(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Desea cerrar su sesión?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No, cancelar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                      return const Login();
                    }), (Route<dynamic> route) => false);
                  },
                  child: const Text('Si, cerrar sesión'))
            ],
          );
        });
  }

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
                title: Text(_titulo),
                backgroundColor: const Color.fromRGBO(0, 95, 184, 1)),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 95, 184, 1)),
                      accountName: Text(widget.nombre.toString()),
                      accountEmail: Text('@${widget.usuario}'),
                      currentAccountPicture: CircleAvatar(
                          backgroundColor:
                              const Color.fromRGBO(238, 117, 35, 1),
                          child: Text(
                              _getFirstCharacter(widget.nombre.toString()),
                              style: const TextStyle(
                                  fontSize: 40.0, color: Colors.white)))),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Nombramientos'),
                    selected: (0 == _selectDrawerItem),
                    onTap: () {
                      _onSelectItem(0);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_score_outlined),
                    title: const Text('Relacionar Credencial'),
                    selected: (1 == _selectDrawerItem),
                    onTap: () {
                      _onSelectItem(1);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar sesión'),
                    onTap: () {
                      _showAlertDialogLogout();
                    },
                  ),
                ],
              ),
            ),
            body: SafeArea(
                child: _getDrawerItemWidget(_selectDrawerItem),
                top: true,
                bottom: true,
                left: true,
                right: true,
                minimum: const EdgeInsets.all(16))),
        onWillPop: () async => _showAlertDialogLogout());
  }
}
