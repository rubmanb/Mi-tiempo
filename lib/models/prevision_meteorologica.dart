class prevSemana {
  int precipitacion = 0;
  int tMax = 0;
  int tMin = 0;
  String valorEstado = "";

  prevSemana(this.precipitacion, this.tMax, this.tMin, this.valorEstado){
    this.precipitacion = precipitacion;
    this.tMax = tMax;
    this. tMin = tMin;
    this..valorEstado = valorEstado;
  }
}



class PrevisionMeteorologica {
  String municipio = "";
  String codigo = "";
  int precipitacion = 0;
  int tMax = 0;
  int tMin = 0;
  String estado = "";
  String valorEstado = "";
  String periodo = "";

  /* 
  Ampliación para la previsión de mañana
  */

  List<prevSemana> diasSemana = [];





  String get imagen {
    return _obtenerImagen(valorEstado);
  }

  String getImagenDia(int dia) {
    return _obtenerImagen(diasSemana[dia].valorEstado);
  }

  String _obtenerImagen(String value) {
    Set<String> soleado = <String>{"11", "11n", "12", "12n"};
    Set<String> pocoNublado = <String>{"13", "13n", "14", "14n"};
    Set<String> nublado = <String>{"15", "16n", "16", "17n", "17"};
    Set<String> lluviaDebil = <String>{
      "23",
      "23n",
      "24",
      "24n",
      "43",
      "43n",
      "44",
      "44n",
      "45",
      "45n",
      "46n",
      "61",
      "61n",
      "62",
      "62n",
      "63",
      "63n"
    };
    Set<String> lluvia = <String>{
      "25",
      "25n",
      "26",
      "26n",
      "51",
      "51n",
      "52",
      "52n",
      "53",
      "53n",
      "54",
      "45n"
    };
    Set<String> nieve = <String>{
      "33",
      "33n",
      "34",
      "34n",
      "35",
      "35n",
      "36",
      "36n",
      "71",
      "71n",
      "72n",
      "73",
      "73n"
    };

    if (soleado.contains(value)) return "soleado.png";
    if (pocoNublado.contains(value)) return "poco_nublado.png";
    if (nublado.contains(value)) return "nublado.png";
    if (lluviaDebil.contains(value)) return "lluvia_debil.png";
    if (lluvia.contains(value)) return "lluvia.png";
    if (nieve.contains(value)) return "nieve.png";

    return "nieve.png";
  }

  // Constructor
  PrevisionMeteorologica(this.codigo, this.municipio);

  @override
  String toString() {
    return ("""Municipio: $municipio ($codigo)
    Probabilidad de precipitación: $precipitacion
    Temperaturas: $tMin-$tMax
    Estado del cielo: $estado ($valorEstado)
    Período de validez: $periodo
    """
    );
  }
}
