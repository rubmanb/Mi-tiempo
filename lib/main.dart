import 'package:flutter/material.dart';
import 'package:mi_tiempo/models/config.dart';
import 'package:mi_tiempo/models/prevision_meteorologica.dart';
import 'package:mi_tiempo/obtener_prevision.dart';
import 'package:mi_tiempo/views/creditos.dart';
import 'package:mi_tiempo/views/geolocalizacion.dart';
import 'package:mi_tiempo/views/prediccion.dart';
import 'package:mi_tiempo/views/prevision_semanal.dart';
import 'package:mi_tiempo/views/seleccion_municipio.dart';

void main() {
  // Lanzamos MyApp
  runApp(const MyApp());
}

// Nuestra aplicación es un widget sin estado, que
// contendrá una aplicación MaterialApp

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Eliminamos el banner de "Debug"
      theme: ThemeData(
        // Tema para la aplicación
        colorScheme: // Esquema de color
            ColorScheme.fromSwatch().copyWith(primary: Colors.blueGrey),

        fontFamily: 'Roboto', // Fuente por defecto

        textTheme: const TextTheme(
          // Propiedades específicas para los diferentes
          // estilos de texto
          headline5:
              TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
          headline4:
              TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
          headline3:
              TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
          headline2:
              TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
        ),
      ),
      // Establecemos el título de la aplicación y la página Home de ésta,
      // que será un widget de tipo MiAppTiempo.
      title: 'Mi App del tiempo',
      initialRoute:
          '/', // Indica la ruta inicial, es decir, la pantalla por defecto
      routes: {
        '/': (context) => const MiAppTiempo(
            title:
                'Mi App del Tiempo'), // La ruta raíz (/) es la primera pantalla
        '/PrevisionSemanal': (context) => const PrevisionSemanal(),
        '/selectorMunicipio': (context) => const SeleccionMunicipio(),
        '/geolocalizacion': (context) => const Geolocalizacion(),
        '/creditos': (context) => const Creditos(),
      },
      //home: const MiAppTiempo(title: 'Mi App del Tiempo'),
    );
  }
}
