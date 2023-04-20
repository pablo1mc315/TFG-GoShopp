// Clase que representa cada producto de una lista de la compra

import 'package:goshopp/models/tipoproducto.dart';

class Producto {
  // ======= ATRIBUTOS =======

  String? nombre;
  double? precio;
  int? cantidad;
  String? medida;
  TipoProducto? tipo;
  bool? estaComprado;

  // ======= CONSTRUCTOR =======

  Producto(String n, double p, TipoProducto t) {
    nombre = n;
    precio = p;
    tipo = t;
    estaComprado = false;
  }
}
