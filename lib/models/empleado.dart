import 'package:my_app/models/empresa.dart';
import 'package:my_app/screens/empleado.dart';

class Empleado {
  late final Empresa? empresa;
  late final int? numero;
  late final String? nombre;
  late final String? apellidoPaterno;
  late final String? apellidoMaterno;
  late final String? estado;
  late final String? telefono;
  late final int? credencial;

  Empleado(
      {this.empresa,
      this.numero,
      this.nombre,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.estado,
      this.telefono,
      this.credencial});

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
        empresa: Empresa?.fromJson(json['empresa']),
        numero: json['numero'],
        nombre: json['nombre'],
        apellidoPaterno: json['apellidoPaterno'],
        apellidoMaterno: json['apellidoMaterno'],
        estado: json['estado'],
        telefono: json['telefono'],
        credencial: json['credencial']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["empresa"] = empresa;
    map["numero"] = numero;
    map["nombre"] = nombre;
    map["apellidoPaterno"] = apellidoPaterno;
    map["apellidoMaterno"] = apellidoMaterno;
    map["estado"] = estado;
    map["telefono"] = telefono;
    map["credencial"] = credencial;
    return map;
  }
}
