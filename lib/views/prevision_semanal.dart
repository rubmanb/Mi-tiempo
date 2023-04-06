import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mi_tiempo/models/prevision_meteorologica.dart';

import '../MainDrawer.dart';
import '../obtener_prevision.dart';



class PrevisionSemanal extends StatelessWidget{
  const PrevisionSemanal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text("Previsión Semanal"),
      ),
      body:
      const EstadoTiempoSemanal(),
    );
  }
}


class EstadoTiempoSemanal extends StatefulWidget {
  const EstadoTiempoSemanal({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}


class _WeatherState extends State<EstadoTiempoSemanal> {
  late Future<PrevisionMeteorologica> _value;

  @override
  initState() {
    super.initState();
    _value = obtenerPrevision();
  }

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
                        return  const Text('Error');//'Error:$a'
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

class MyInfoWeather extends StatefulWidget {
  PrevisionMeteorologica prevision;
  MyInfoWeather({Key? key, required this.prevision}) : super(key: key);

  @override
  _MyInfoWeatherState createState() => _MyInfoWeatherState();
}

class _MyInfoWeatherState extends State<MyInfoWeather>{

  @override
  Widget build(BuildContext context) {
    var dias = widget.prevision.diasSemana;

    return ListView.builder(
      itemCount: dias.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            WeatherWeek(
              tMax: widget.prevision.diasSemana[index].tMax,
              tMin: widget.prevision.diasSemana[index].tMin,
              estado: widget.prevision.getImagenDia(index),
              precipitacion: widget.prevision.diasSemana[index].precipitacion,
            ),
          ],
        );
      },
    );
  }
}


class WeatherWeek extends StatelessWidget{
  final int tMax;
  final int tMin;
  final String estado;
  final int precipitacion;

  const WeatherWeek(
      {Key? key,
        this.tMax = 0,
        this.tMin = 0,
        this.estado = "",
        this.precipitacion = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
          Image(
              image: AssetImage("assets/icons/png/$estado"),
              height: 80.0),
          Text("$precipitacion%",
            style: Theme.of(context).textTheme.headline4,
          ),
          Text("$tMinº",
            style: Theme.of(context).textTheme.headline4,
          ),
          Text("$tMaxº",
            style: Theme.of(context).textTheme.headline4,
          ),
      ],
    );
  }
}