import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_tiempo/models/config.dart';

import '../MainDrawer.dart';

// El esqueleto de la vista será un widget sin estado
class SeleccionMunicipio extends StatelessWidget {
  const SeleccionMunicipio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text("Selección de municipio"),
      ),
      body:
          //  Separamos el contenido principal en otro widget
          const SelectorMunicipio(),
    );
  }
}

class SelectorMunicipio extends StatefulWidget {
  // El selector de municipio sí que será un widget con estado,
  // puesto que deberá obtener la lista de municipios de forma
  // asíncrona y crear el widget.
  const SelectorMunicipio({Key? key}) : super(key: key);

// Sobreescribimos el método createState e iniciamos el ciclo de vida del estado
  @override
  _SelectorMunicipioState createState() => _SelectorMunicipioState();
}

class _SelectorMunicipioState extends State<SelectorMunicipio> {
  late Future
      _municipios; // Propiedad que se actualizará con el contenido del fichero de municipios

  @override
  void initState() {
    // En el método initState del ciclo de vida, realizamos
    // las inicializaciones de las propietades del estado.
    _municipios = obtenerMunicipios();
    super.initState(); // Recordemos que debemos invocar al constructor de la clase padre.
  }

  // Método como función flecha que lee el contenido del fichero JSON
  // con las provincias y lo devuelve como un String dentro del Future
  Future<String> obtenerMunicipios() async =>
      await rootBundle.loadString('assets/municipios_por_provincia.json');

// Método build para construir el widget.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _municipios, // El future será la variable privada _municipios
      builder: (context, AsyncSnapshot snapshot) {
        // Método builder
        if (!snapshot.hasData) {
          return Text('Cargando municipios...');
        }

        // Cuando el snapshot contenga datos, los decodificamos en JSON
        // Y generamos la lista de municipios
        var municipios = json.decode(snapshot.data);
        List lista_municipios = [];

        // Recorrido del JSON para crear la List con
        // los municipios
        for (var provincia in municipios["municipios"]) {
          for (var municipio in provincia["municipios"]) {
            lista_municipios.add([
              municipio["nombre"],
              municipio["codigo"],
              provincia["provincia"]
            ]);
          }
        }

        // Ordenamos los municipios por nombre
        lista_municipios.sort((m1, m2) => m1[0].compareTo(m2[0]));

        // Creamos la vista
        return ListView.builder(
            itemCount: lista_municipios.length,
            itemBuilder: (BuildContext context, int index) {
              // Cada elemento de la lista se compondrá del nombre del
              // municipio como título y la província como subtítulo
              return ListTile(
                title: Text(
                    lista_municipios[index][0]), // Título principal del item
                subtitle: Text(lista_municipios[index][2]), // Subtítulo

                // Preparamos el callback para cuando se haga Tap sobre
                // el elemento de la lista. Lo que haremos es modificar
                // El código que tenemos en la configuración, de modo que
                // automáticamente se actualice la previsión, al depender
                // esta de estem mismo valor.
                // Cuando lo modifiquemos, reemplazaremos la ruta de navegación
                // por la raíz, que es la predicción.
                onTap: () {
                  Config.codigo = lista_municipios[index][1];
                  Navigator.of(context).pushReplacementNamed('/');
                },
              );
            });
      },
    );
  }
}
