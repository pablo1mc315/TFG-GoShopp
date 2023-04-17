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

  Producto(String nombreProducto, double precioProducto) {
    nombre = nombreProducto;
    precio = precioProducto;
    estaComprado = false;
  }
}
