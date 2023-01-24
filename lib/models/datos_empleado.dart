class DatosEmpleados {
  final String? nombre;
  final String? area;
  final String? matricula;
  final String? turno;
  final String? especialidad;
  final String? fecha;
  final String? captura;
  final String? solicitud;
  final String? envio;
  final String? ida;

  DatosEmpleados(
      {required this.nombre,
      required this.area,
      required this.matricula,
      required this.turno,
      required this.especialidad,
      required this.fecha,
      required this.captura,
      required this.solicitud,
      required this.envio,
      required this.ida});

  factory DatosEmpleados.fromJson(Map<String, dynamic> json) {
    return DatosEmpleados(
        nombre: json['nombre'],
        area: json['area'],
        matricula: json['matricula'],
        turno: json['turno'],
        especialidad: json['especialidad'],
        fecha: json['fecha'],
        captura: json['captura'],
        solicitud: json['solicitud'],
        envio: json['envio'],
        ida: json['ida']);
  }
}
