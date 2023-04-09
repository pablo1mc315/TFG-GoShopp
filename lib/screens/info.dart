import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 100, 190),
      ),
      body: const Column(
        children: <Widget>[
          Center(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "GoShopp",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 100, 190),
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Desarrollado por: Pablo Muñoz Castro\n\n"
                    "Esta aplicación ha sido desarrollada como Trabajo de Fin "
                    "de Grado para el Grado en Ingeniería Informática en la "
                    "Universidad de Granada.\n\n"
                    "El objetivo de nuestra aplicación es facilitar la gestión "
                    "de listas de la compra entre grupos de personas como, por "
                    "ejemplo, de una unidad familiar o de compañeros de piso, "
                    "así como listas de la compra personales.",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 100, 190)),
                  )))
        ],
      ),
    );
  }
}
