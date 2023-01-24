import 'package:flutter/material.dart';
import 'package:my_app/providers/metodos_http.dart' as http_methods;
import 'package:my_app/models/respuesta_login.dart' as respuesta_login;
import 'package:my_app/screens/menu.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final username = TextEditingController();
  final password = TextEditingController();

  _showAlertDialogErrors(String titulo, String mensaje) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text(titulo),
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

  _login() async {
    if (username.text.isNotEmpty || password.text.isNotEmpty) {
      try {
        setState(() {
          isLoading = true;
        });
        respuesta_login.RespuestaLogin respuesta =
            await http_methods.login(username.text, password.text);
        if (respuesta.respuestaLogin != 1) {
          setState(() {
            isLoading = false;
          });
          _showAlertDialogErrors(
              'Inicio de sesión no válido', respuesta.mensajeLogin.toString());
        } else {
          if (respuesta.usuario.activo != 1) {
            setState(() {
              isLoading = false;
            });
            _showAlertDialogErrors('Inicio de sesión no válido',
                respuesta.mensajeLogin.toString());
          } else {
            if (!mounted) return;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Menu(
                          nombre: respuesta.usuario.nombre.toString(),
                          usuario: respuesta.usuario.username.toString(),
                        )));
            setState(() {
              isLoading = false;
            });
          }
        }
      } catch (ex) {
        setState(() {
          isLoading = false;
        });
        _showAlertDialogErrors('Error', '$ex');
      }
    }
  }

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(0, 95, 184, 1)))
          : Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.bottomRight,
                    widthFactor: 0.6,
                    heightFactor: 0.6,
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      color: Color.fromRGBO(0, 95, 184, 1),
                      child: SizedBox(
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset('./images/logo_cice.png',
                                width: 120, height: 120),
                            const Spacer(),
                            const Text(
                              "Nombramientos",
                              style: TextStyle(
                                  fontSize: 22.0,
                                  color: Color.fromRGBO(0, 95, 184, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            TextField(
                              controller: username,
                              enableInteractiveSelection: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Usuario',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  suffixIcon: const Icon(Icons.person)),
                            ),
                            const Spacer(),
                            TextField(
                              controller: password,
                              enableInteractiveSelection: false,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  suffixIcon: const Icon(Icons.lock)),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    _login();
                                  },
                                  label: const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  icon: const Icon(Icons.login),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromRGBO(
                                                  0, 95, 184, 1)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )))),
                            ),
                            const Spacer(),
                            const Text('v1.0.0',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 197, 197, 197),
                                    fontSize: 10))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
    );
  }
}
