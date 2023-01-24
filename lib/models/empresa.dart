class Empresa {
  final int? id;
  final String? nombre;

  Empresa({this.id, this.nombre});

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(id: json['id'], nombre: json['nombre']);
  }
}
