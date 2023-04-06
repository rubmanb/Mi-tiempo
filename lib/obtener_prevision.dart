import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesaria para leer el JSON con los municipios
import 'package:http/http.dart' as http;
import 'package:mi_tiempo/models/config.dart';
import 'dart:convert';

import 'package:mi_tiempo/models/prevision_meteorologica.dart';

/* loadJsonData() async {
  //read json file
  final jsondata =  await rootBundle.loadString('assets/municipios_por_provincia.json');
      
  return "A";
}*/

Future<String> getMunicipio() async {
  final jsondata =
      await rootBundle.loadString('assets/municipios_por_provincia.json');
  var municipios = json.decode(jsondata);
  for (var provincia in municipios["municipios"]) {
    for (var municipio in provincia["municipios"]) {
      if (municipio["codigo"] == Config.codigo) {
        return (municipio["nombre"]);
      }
    }
  }
  return "";
}

Future<PrevisionMeteorologica> obtenerPrevision() async {
  String codigo = Config.codigo;
  String apiKey = Config.apiKey;

  String? municipio = await getMunicipio();
  PrevisionMeteorologica pm = PrevisionMeteorologica(codigo, municipio);
//  PrevisionMeteorologica pm = PrevisionMeteorologica(codigo, "AA");

  String url =
      'https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/diaria/$codigo?api_key=$apiKey';

  // Lanzamos la petición GET al servidor con la URL
  // El resultado será un Future
  var response = await http.get(Uri.parse(url));

  // En la resolución del Future tendremos el resultado de la petición
  if (response.statusCode == 200) {
    // La respuesta HTTP devuelve un código de estado y un Body.
    // Si el código de estado es 200, la petición es válida y en el
    // body tenemos la respuesta.
    // Así pues, descodificamos el body de esta respuesta
    // para ver qué información contiene.

    var bodyJSON = jsonDecode(response.body) as Map;

    // La clave "datos" contiene una URL temporal con la información

    // Así pues, lanzamos una nueva petición GET con esta URL
    var response2 = await http.get(Uri.parse(bodyJSON["datos"]));

    if (response2.statusCode == 200) {
      // La petición tiene éxito. Obtenemos los resultados
      // a partir de la lista de elementos contenida en el body
      var infoMeteo = jsonDecode(response2.body) as List;
      pm.precipitacion =
          infoMeteo[0]["prediccion"]["dia"][0]["probPrecipitacion"][0]["value"];
      pm.tMax = infoMeteo[0]["prediccion"]["dia"][0]["temperatura"]["maxima"];
      pm.tMin = infoMeteo[0]["prediccion"]["dia"][0]["temperatura"]["minima"];

      // El estado del cielo se especifica por intervalos horarios
      // Vamos a buscar el primer intervalo con valor, entre los 6
      // posibles intervalos. Obtendremos también el intervalo y el
      // código del estado del cielo.
      int i = 0;

      while (pm.estado == "" && i < 7) {
        pm.estado = infoMeteo[0]["prediccion"]["dia"][0]["estadoCielo"][i]
            ["descripcion"];
        pm.valorEstado =
            infoMeteo[0]["prediccion"]["dia"][0]["estadoCielo"][i]["value"];
        pm.periodo =
            infoMeteo[0]["prediccion"]["dia"][0]["estadoCielo"][i]["periodo"];
        i++;
      }


      for (var i = 0; i<7; i++){
        pm.diasSemana.add(prevSemana(
            infoMeteo[0]["prediccion"]["dia"][i]["probPrecipitacion"][0]["value"],
            infoMeteo[0]["prediccion"]["dia"][i]["temperatura"]["maxima"],
            infoMeteo[0]["prediccion"]["dia"][i]["temperatura"]["minima"],
            infoMeteo[0]["prediccion"]["dia"][i]["estadoCielo"][0]["value"]));

      }


      // Obtención de los datos para el día siguiente
      /*

      */
      // Una vez tenemos la previsión completa la devolvemos
      return pm;
    }
  } // if

  print(response.statusCode);
  return PrevisionMeteorologica(Config.codigo, municipio);
}
