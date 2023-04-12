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

  // ======= MÉTODOS =======

  // Método que recoje un objeto en formato JSON y lo asigna a cada atributo
  Producto.fromJson(Map<dynamic, dynamic> json) {
    nombre = json['nombre'] as String;
    precio = json['precio'] as double;
    cantidad = json['cantidad'] as int;
    medida = json['medida'] as String;
    tipo = json['tipo'] as TipoProducto;
    estaComprado = json['estaComprado'] as bool;
  }

  // Método que construye un objeto en formato JSON
  Map<dynamic, dynamic> toJson() {
    return <dynamic, dynamic>{
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'medida': medida,
      'tipo': tipo,
      'estaComprado': estaComprado,
    };
  }
}
