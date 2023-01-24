class Usuario {
  final int clave;
  final String? username;
  final String? nombre;
  final int activo;

  Usuario(
      {required this.clave,
      required this.username,
      required this.nombre,
      required this.activo});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
        clave: json['clave'],
        username: json['username'],
        nombre: json['nombre'],
        activo: json['activo']);
  }
}
