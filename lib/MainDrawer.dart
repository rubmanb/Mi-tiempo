import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nuestro Navigation Drawer consistirá en una lista
    // de diferentes elementos, entre los que encontramos
    // la cabecera (DrawerHeader) y diferentes elementos
    // de lista (ListTile.)
    return Drawer(
      child: ListView(
        // Eliminamos el padding del listview
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/background.jpg'))),
            child: Text('Mi App del Tiempo',
                style: Theme.of(context).textTheme.headline3),
          ),
          ListTile(
            title: Text('Predicción',
                style: Theme.of(context).textTheme.headline6),
            onTap: () {
              // Obtenemos la ruta actual
              String currentRoute =
                  (ModalRoute.of(context)?.settings.name).toString();
              if (currentRoute != "/") {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
          ListTile(
            title: Text('Previsión Semanal',
                style: Theme.of(context).textTheme.headline6),
            onTap: () {
              String currentRoute =
              (ModalRoute.of(context)?.settings.name).toString();
              if (currentRoute != "/PrevisionSemanal") {
                Navigator.of(context)
                    .pushReplacementNamed("/PrevisionSemanal");
              }
            },
          ),
          ListTile(
            title: Text('Selección de municipio',
                style: Theme.of(context).textTheme.headline6),
            onTap: () {
              String currentRoute =
                  (ModalRoute.of(context)?.settings.name).toString();
              if (currentRoute != "/selectorMunicipio") {
                Navigator.of(context)
                    .pushReplacementNamed('/selectorMunicipio');
              }
            },
          ),
          ListTile(
            title: Text('El tiempo en mi ubicación',
                style: Theme.of(context).textTheme.headline6),
            onTap: () {
              String currentRoute =
                  (ModalRoute.of(context)?.settings.name).toString();
              if (currentRoute != "/geolocalizacion") {
                Navigator.of(context).pushReplacementNamed('/geolocalizacion');
              }
            },
          ),
          ListTile(
            title:
                Text('Créditos', style: Theme.of(context).textTheme.headline6),
            onTap: () {
              String currentRoute =
                  (ModalRoute.of(context)?.settings.name).toString();
              if (currentRoute != "/creditos") {
                Navigator.of(context).pushReplacementNamed('/creditos');
              }
            },
          )
        ],
      ),
    );
  }
}
