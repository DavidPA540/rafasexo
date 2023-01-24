import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/respuesta_login.dart';

import '../models/datos_empleado.dart';
import '../models/respuesta_global.dart';

Future<RespuestaLogin> login(String usuario, String password) async {
  String url =
      'https://www.grupocice.com/serviciosgf2/estadomaniobrasws/webresources/seguridad/login';

  Map data = {'usuario': usuario, 'password': password};

  var body = json.encode(data);

  return http
      .post(Uri.parse(url),
          headers: {"Content-Type": "application/json; charset=UTF-8"},
          body: body)
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    return RespuestaLogin.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));
  });
}

Future<List<String>> getTurnos(String fecha) async {
  String url =
      //'http://localhost:8080/nombramientos/webresources/rf/turnos/$fecha';
      'https://www.grupocice.com/servicioswf2/nombramientosws/webresources/rf/turnos/$fecha';
  return http.get(Uri.parse(url), headers: {
    "Content-Type": "application/json; charset=UTF-8"
  }).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    //var responseJson = json.decode(utf8.decode(response.bodyBytes));

    List<String> turnos =
        (jsonDecode(response.body) as List<dynamic>).cast<String>();

    return turnos;
  });
}

Future<List<String>> getespeci(String fecha) async {
  String url =
      //'http://localhost:8080/nombramientos/webresources/rf/categoria/$fecha';
      'https://www.grupocice.com/servicioswf2/nombramientosws/webresources/rf/categoria/$fecha';

  return http.get(Uri.parse(url), headers: {
    "Content-Type": "application/json; charset=UTF-8"
  }).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    //var responseJson = json.decode(utf8.decode(response.bodyBytes));

    List<String> especi =
        (jsonDecode(response.body) as List<dynamic>).cast<String>();

    return especi;
  });
}

Future<List<DatosEmpleados>> postconsulta(
    String fecha, String turno, String matricula, String categorias) async {
  String url =
      //'http://localhost:8080/nombramientos/webresources/rf/consultanombramiento';
      'https://www.grupocice.com/servicioswf2/nombramientosws/webresources/rf/consultanombramiento';
  return http
      .post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: jsonEncode(<String, String>{
      'fecha': fecha,
      'turno': turno,
      'matricula': matricula,
      'categoria': categorias
    }),
  )
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    return (responseJson as List)
        .map((e) => DatosEmpleados.fromJson(e))
        .toList();
  });
}

Future<List<DatosEmpleados>> postasistencia(String usaconfi, String maemple,
    String fecasis, String asistencia, String turno) async {
  String
      url = //'http://localhost:8080/nombramientos/webresources/rf/asistencia';
      'https://www.grupocice.com/servicioswf2/nombramientosws/webresources/rf/asistencia';

  return http
      .post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: jsonEncode(<String, String>{
      'usaconfi': usaconfi,
      'maemple': maemple,
      'fecasis': fecasis,
      'asistencia': asistencia,
      'turno': turno
    }),
  )
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    return responseJson;
  });
}

Future<List<DatosEmpleados>> postasistarea(
    String areaasis, String turno, String maemple, String fecasis) async {
  String url = //'http://localhost:8080/nombramientos/webresources/rf/asisarea';
      'https://www.grupocice.com/servicioswf2/nombramientosws/webresources/rf/asisarea';

  return http
      .post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: jsonEncode(<String, String>{
      'areaasis': areaasis,
      'turno': turno,
      'maemple': maemple,
      'fecasis': fecasis
    }),
  )
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    return responseJson;
  });
}

Future<List<DatosEmpleados>> postcorreo(
    String nombre,
    String matricula,
    String area,
    String Turno,
    String fecha,
    String captura,
    String solicitud,
    String ida) async {
  String url = //'http://localhost:8080/nombramientos/webresources/rf/correo';
      'https://www.grupocice.com/servicioswf2/nombramientosws/webresources/rf/correo';

  return http
      .post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: jsonEncode(<String, String>{
      'nombre': nombre,
      'matricula': matricula,
      'area': area,
      'turno': Turno,
      'fecha': fecha,
      'captura': captura,
      'solicitud': solicitud,
      'ida': ida
    }),
  )
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    return responseJson;
  });
}

Future<RespuestaGlobal> getrelacion(
    String idempresa, String numeroempledo) async {
  String url =
      'https://www.grupocice.com/servicioswf2/nombracredenciales/webresources/credencial/buscarempleadov2?idempresa=$idempresa&numeroempleado=$numeroempledo';
  return http.get(Uri.parse(url), headers: {
    "Content-Type": "application/json; charset=UTF-8"
  }).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    return RespuestaGlobal.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));
  });
}

Future<RespuestaGlobal> postrelacionar(
    String idempresa, String numeroempledo, String foliocredencial) async {
  String url =
      'https://www.grupocice.com/servicioswf2/nombracredenciales/webresources/credencial/relacionarv2';
  return http
      .post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: jsonEncode(<String, String>{
      'idEmpresa': idempresa,
      'numeroEmpleado': numeroempledo,
      'folioCredencial': foliocredencial,
      'usuario': "0",
      'telefono': ""
    }),
  )
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    return RespuestaGlobal.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));
  });
}

Future<RespuestaGlobal> posttelefono(String idempresa, String numeroempledo,
    String foliocredencial, String telefono) async {
  String url =
      'https://www.grupocice.com/servicioswf2/nombracredenciales/webresources/credencial/actualizartelefonov2';
  return http
      .post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: jsonEncode(<String, String>{
      'idEmpresa': idempresa,
      'numeroEmpleado': numeroempledo,
      'folioCredencial': foliocredencial,
      'usuario': "0",
      'telefono': ""
    }),
  )
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    return RespuestaGlobal.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));
  });
}

Future<RespuestaGlobal> posteliminar(
    String idempresa, String numeroempledo, String foliocredencial) async {
  String url =
      'https://www.grupocice.com/servicioswf2/nombracredenciales/webresources/credencial/eliminarelacionv2';
  return http
      .post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: jsonEncode(<String, String>{
      'idEmpresa': idempresa,
      'numeroEmpleado': numeroempledo,
      'folioCredencial': foliocredencial,
      'usuario': "0",
      'telefono': ""
    }),
  )
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(
          "Error: ${statusCode.toString()} - ${response.body.toString()}");
    }
    return RespuestaGlobal.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));
  });
}
