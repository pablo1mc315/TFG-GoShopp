// Clase que representa una lista de la compra

import 'package:goshopp/models/producto.dart';

class ListaCompra {
  // ======= ATRIBUTOS =======

  String? id;
  String? nombre;
  String? descripcion;
  String? idPropietario;
  List<Producto>? productosLista;

  // ======= CONSTRUCTOR =======

  ListaCompra(String idLista, String n, String d) {
    id = idLista;
    nombre = n;
    descripcion = d;
    idPropietario = null;
    productosLista = [];
  }
}
