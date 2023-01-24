import 'package:my_app/models/usuario.dart';

class RespuestaLogin {
  final Usuario usuario;
  final int respuestaLogin;
  final String? mensajeLogin;

  RespuestaLogin(
      {required this.usuario,
      required this.respuestaLogin,
      required this.mensajeLogin});

  factory RespuestaLogin.fromJson(Map<String, dynamic> json) {
    return RespuestaLogin(
        usuario: Usuario.fromJson(json['usuario']),
        respuestaLogin: json['respuestaLogin'],
        mensajeLogin: json['mensajeLogin']);
  }
}
