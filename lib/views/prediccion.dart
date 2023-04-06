import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mi_tiempo/models/prevision_meteorologica.dart';

import '../MainDrawer.dart';
import '../obtener_prevision.dart';

class MiAppTiempo extends StatelessWidget {
  // Widget sin estado con la estructura de la aplicación (abbPar, body, etc.)

  // Constructor
  // El atributo key se usa para identificarlo en el árbol de componentes
  // El atributo title será el título de la barra superior
  const MiAppTiempo({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    // Constuctor del widget
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text(title),
      ),
      body: InfoTiempo(), //  Separamos el contenido principal en otro widget
    );
  }
}

// Infotiempo es un widget con estado, que utiliza _InfoTiempo
// para modelar el estado.
class InfoTiempo extends StatefulWidget {
  const InfoTiempo({Key? key}) : super(key: key);

  @override
  _InfoTiempo createState() => _InfoTiempo();
}

class _InfoTiempo extends State<InfoTiempo> {
  // El estado vendrá determinado por un objeto de tipo PrevisiónMeteorologica
  // Dado que se establecerá asíncronamente, utilizamos un future, que
  // además se inicializará más adelante. Para indicar esto utilizamos late.
  late Future<PrevisionMeteorologica> _value;

  @override
  initState() {
    // Establecemos el estado inicial
    super.initState();

    // obtenerPrevision devuelve un Future con un objeto
    // de previsión del tiempo
    _value = obtenerPrevision();
  }

// Constructor del Widget
  @override
  Widget build(BuildContext context) {
    return Container(
      // Contenedor general, con una imagen de fondo
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
      child: GestureDetector(
        // Detector de gestos
        // Detección de la velocidad en vertical
        // para detectar un swipe vertical
        // Utilizamos el atributo onPanEnd
        onPanEnd: (DragEndDetails downDetails) {
          if (downDetails.velocity.pixelsPerSecond.dy > 0) {
            setState(() {
              // Actualización de la previsión
              // a través del estado
              _value = obtenerPrevision();
            });
          }
        },
        child: Padding(
            // Añadimos un padding a los diferentes widgets
            padding: const EdgeInsets.all(24.0),
            child: Center(
                child: FutureBuilder(
              future: _value, // Resultado de la peracon asíncrona,
              // Propiedad builder del FutureBuilder: Con ella definimos
              // la forma de construir el widget cuando el Future es resuelto
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // Snapshot contiene el resultado de la resolución del Future
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Aquí el Future no se ha resuelto todavía
                  return const Center(
                    // Por tanto incluimos una animación de Espera
                    child: SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  // Aquí ya se ha resuelto el Future
                  if (snapshot.hasError) {
                    //var a = snapshot.error?.toString()??'';//veu que tipo d'error hi ha
                    // Comprobamos si hay error
                    return  Text('Error');//'Error:$a'
                  } else if (snapshot.hasData) {
                    // Si tiene datos, generamos un widget de tipo
                    // MyInfoWeather, proporcionándole la información de la
                    // previsión
                    return MyInfoWeather(prevision: snapshot.data);
                  } else {
                    // Si el snaphot no contiene datos, mostramos un texto
                    return const Text('Sin datos');
                  }
                } else {
                  // Mostramos cualquier otro estado
                  return Text('Estado: ${snapshot.connectionState}');
                }
              },
            ))),
      ),
    );
  }
}

// Widget para el contenido central con la previsión
class MyInfoWeather extends StatefulWidget {
  PrevisionMeteorologica prevision;
  MyInfoWeather({Key? key, required this.prevision}) : super(key: key);

  @override
  State<MyInfoWeather> createState() => _MyInfoWeatherState();
}

class _MyInfoWeatherState extends State<MyInfoWeather> {
  @override
  Widget build(BuildContext context) {
    // Se tratará de una serie de items ordenados en una columna
    return Column(
      children: <Widget>[
        Image(
            // El primer elemento es la imagen con la previsión
            image: AssetImage("assets/icons/png/${widget.prevision.imagen}"),
            height: 220.0),
        Center(
          // Texto con el municipio
          child: Text(
            widget.prevision.municipio,
            textAlign: TextAlign.center,
            // Con style establecemos el estilo del texto,
            // En este caso el headline3, definido en el tema de la aplicación.
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Text(
          // Texto con la previsión del estado
          widget.prevision.estado,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          // Texto con la probabilidad de precipitación
          "\n Probabilidad de lluvia ${widget.prevision.precipitacion}%",
          style: Theme.of(context).textTheme.headline5,
        ),
        Padding(
          // Bloque con las temperaturas
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "${widget.prevision.tMin}º",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "${widget.prevision.tMax}º",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
            ],
          ),
        ), // Añadimos el widet con la información del dia siguiente
        TomorrowWeather(
          tMax: widget.prevision.diasSemana[1].tMax,
          tMin: widget.prevision.diasSemana[1].tMin,
          estado: widget.prevision.getImagenDia(1),
          precipitacion: widget.prevision.diasSemana[1].precipitacion,
        ),
      ],
    );
  }
}

class TomorrowWeather extends StatelessWidget {
  final int tMax;
  final int tMin;
  final String estado;
  final int precipitacion;

  const TomorrowWeather(
      {Key? key,
      this.tMax = 0,
      this.tMin = 0,
      this.estado = "",
      this.precipitacion = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ahora se tratará de una serie de items ordenados en una fila
    return Row(
      children: <Widget>[
        Expanded(
          // La imagen dentro del Expanded se ajusta al tamaño
          child: Image(
            // El primer elemento es la imagen con la previsión
            image: AssetImage("assets/icons/png/$estado"),
          ),
        ),
        Expanded(
          child: Text(
            // Texto con la probabilidad de precipitación
            "$precipitacion%",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Expanded(
          child: Text(
            "$tMinº",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Expanded(
          child: Text(
            "$tMaxº",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ],
    );
  }
}
