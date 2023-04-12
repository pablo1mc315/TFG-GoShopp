import 'package:flutter/material.dart';
import 'package:goshopp/models/tipoproducto.dart';

class ProductoWidget extends StatelessWidget {
  final String? nombre;
  final double? precio;
  final int? cantidad;
  final String? medida;
  final TipoProducto? tipo;
  final bool? estaComprado;

  ProductoWidget(this.nombre, this.precio, this.cantidad, this.medida,
      this.tipo, this.estaComprado);

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
                  Row(
                    children: [Text(nombre.toString())],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text("$precio euros"),
          )
        ],
      ),
    );
  }
}
