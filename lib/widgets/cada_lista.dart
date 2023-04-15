import 'package:flutter/material.dart';

class CadaListaWidget extends StatelessWidget {
  final String? nombre;
  final String? descripcion;

  const CadaListaWidget(this.nombre, this.descripcion, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey[350]!,
                  blurRadius: 2,
                  offset: const Offset(0, 1))
            ], borderRadius: BorderRadius.circular(50.0), color: Colors.white),
            child: MaterialButton(
              disabledTextColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 1),
              onPressed: null,
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Text(nombre.toString()),
                      Text(descripcion.toString())
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
