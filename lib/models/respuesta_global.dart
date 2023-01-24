import 'package:my_app/models/empleado.dart';

class RespuestaGlobal {
  final Empleado? empleado;

  RespuestaGlobal({this.empleado});

  factory RespuestaGlobal.fromJson(Map<String, dynamic> json) {
    return RespuestaGlobal(empleado: Empleado?.fromJson(json['empleado']));
  }
}
