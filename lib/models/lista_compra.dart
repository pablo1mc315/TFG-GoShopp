// Clase que representa una lista de la compra

import 'package:goshopp/models/producto.dart';
import 'package:goshopp/models/usuario.dart';

class ListaCompra {
  // ======= ATRIBUTOS =======

  String? nombre;
  String? descripcion;
  String? idPropietario;
  List<Producto>? productosLista;
  List<Producto>? productosComprados;

  // ======= CONSTRUCTOR =======

  ListaCompra(String n, String d) {
    nombre = n;
    descripcion = d;
    idPropietario = null;
    productosLista = [];
    productosComprados = [];
  }
}
