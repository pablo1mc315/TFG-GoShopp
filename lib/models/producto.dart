// Clase que representa cada producto de una lista de la compra

import 'package:goshopp/models/tipoproducto.dart';

class Producto {
  // ======= ATRIBUTOS =======

  String? id;
  String? nombre;
  double? precio;
  TipoProducto? tipo;
  bool? estaComprado;

  // ======= CONSTRUCTOR =======

  Producto(String idP, String n, double p, TipoProducto t, bool c) {
    id = idP;
    nombre = n;
    precio = p;
    tipo = t;
    estaComprado = c;
  }
}
