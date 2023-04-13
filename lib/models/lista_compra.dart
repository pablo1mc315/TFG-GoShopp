// Clase que representa una lista de la compra

import 'package:goshopp/models/producto.dart';
import 'package:goshopp/models/usuario.dart';

class ListaCompra {
  // ======= ATRIBUTOS =======

  String? nombre;
  String? descripcion;
  Usuario? propietario;
  List<Producto>? productosLista;
  List<Producto>? productosComprados;

  // ======= CONSTRUCTOR =======

  ListaCompra(String n, String d) {
    nombre = n;
    descripcion = d;
    propietario = null;
    productosLista = [];
    productosComprados = [];
  }

  // ======= MÉTODOS =======

  // Método que recoje un objeto en formato JSON y lo asigna a cada atributo
  ListaCompra.fromJson(Map<dynamic, dynamic> json) {
    nombre = json['nombre'] as String;
    descripcion = json['descripcion'] as String;
    propietario = json['propietario'] as Usuario;
    productosLista = json['productosLista'] as List<Producto>;
    productosComprados = json['productosComprados'] as List<Producto>;
  }

  // Método que construye un objeto en formato JSON
  Map<dynamic, dynamic> toJson() {
    return <dynamic, dynamic>{
      'nombre': nombre,
      'descripcion': descripcion,
      'propietario': propietario,
      'productosLista': productosLista,
      'productosComprados': productosComprados
    };
  }
}
