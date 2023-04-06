import 'package:flutter/material.dart';

import '../MainDrawer.dart';

class Creditos extends StatelessWidget {
  const Creditos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text("Créditos"),
      ),
      body: Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Center(
              child: Text("Mi aplicación del tiempo",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4)),
          Center(
              child: Text("\npor RubénMB-DAM 2022\n",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6)),
          const Center(
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Image(
                  image: AssetImage("assets/icons/png/soleado.png"),
                ),
              ),
            ),
          ),
          Center(
              child: Text("\n\nImágenes de Darius Krause en Pexels.com\n",
                  style: Theme.of(context).textTheme.bodyText1)),
          Center(
              child: Text("Iconos de Iconixar y Freepic para Flaticon.com",
                  style: Theme.of(context).textTheme.bodyText1)),
        ]),
      ),
    );
  }
}
