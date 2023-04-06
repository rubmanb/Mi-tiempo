import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mi_tiempo/models/config.dart';

import '../MainDrawer.dart';

class Geolocalizacion extends StatelessWidget {
  const Geolocalizacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: const Text("Geolocalización"),
        ),
        body: const Geolocalizador());
  }
}

class Geolocalizador extends StatefulWidget {
  // El estado del widget vendrá determinado por la posición

  const Geolocalizador({Key? key}) : super(key: key);

  @override
  _GeolocalizadorState createState() => _GeolocalizadorState();
}

class _GeolocalizadorState extends State<Geolocalizador> {
  late Future<List> _municipio;

  @override
  void initState() {
    super.initState();
    _municipio = obtenerMunicipioMasCercano();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _municipio, // El future será la variable privada _posicion
        builder: (context, AsyncSnapshot snapshot) {
          // Método builder
          if (!snapshot.hasData) {
            return const Text('Esperando ubicación...');
          }

          // Cuando el snapshot contenga datos,

          return Container(
              // Contenedor general, con una imagen de fondo
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/background.jpg"),
                      fit: BoxFit.cover)),
              child: Padding(
                // Añadimos un padding a los diferentes widgets
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "${snapshot.data[0]}",
                        textAlign: TextAlign.center,
                        // Con style establecemos el estilo del texto,
                        // En este caso el headline3, definido en el tema de la aplicación.
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      ElevatedButton(
                        child: Text('OK'),
                        onPressed: () {
                          Config.codigo = snapshot.data[1];
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}

Future<List> obtenerMunicipioMasCercano() {
  Future<Position> _posicion = _determinePosition();
  return _posicion.then((value) {
    // Value contiene las coordenadas: Latidut y Longitud
    // Comparamos con el JSON
    double _latitud = value.latitude;
    double _longitud = value.longitude;
    return obtenerMunicipios().then((municipiosString) {
      var municipios = json.decode(municipiosString);

      double distancia_menor = double.maxFinite;
      String municipio_mas_cercano = "";
      String codigo_municipio_mas_cercano = "";
      for (var provincia in municipios["municipios"]) {
        for (var municipio in provincia["municipios"]) {
          try {
            double distancia =
                (double.parse(municipio["longitud"]) - _longitud).abs() +
                    (double.parse(municipio["latitud"]) - _latitud).abs();
            if (distancia < distancia_menor) {
              distancia_menor = distancia;
              municipio_mas_cercano = municipio["nombre"];
              codigo_municipio_mas_cercano = municipio["codigo"];
            }
          } catch (Exc) {
            print(Exc);
          }
        }
      }
      return [
        municipio_mas_cercano,
        codigo_municipio_mas_cercano,
        distancia_menor
      ];
    });
  });
}

Future<String> obtenerMunicipios() async =>
    await rootBundle.loadString('assets/municipios_por_provincia.json');

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Comprobación del servicio
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // El servicio de geolocalización no está activado
    // así que se indica al usuario
    return Future.error('El servicio de localización está desactivado');
  }

  // Comprobamos y pedimos permiso al usuario
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permisos denegados temporalmente, la siguiente
      // vez que se utilice esta funcionalidad lo volverá
      // a preguntar.
      return Future.error('Sin permisos');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Los Permisos están denegados de forma permanente, por
    // lo que no se pueden volver a pedir.
    return Future.error('Los pemisos están denegados permanentemente.');
  }

  // Si tenemos permisos, devolvemos la localización.
  return await Geolocator.getCurrentPosition();
}
