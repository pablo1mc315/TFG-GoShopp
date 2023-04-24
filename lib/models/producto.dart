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

  Producto(String idP, String n, TipoProducto t) {
    id = idP;
    nombre = n;
    precio = -1;
    tipo = t;
    estaComprado = false;
  }
}
