// Clase que representa una lista de la compra

import 'package:goshopp/models/producto.dart';
import 'package:goshopp/models/usuario.dart';

class ListaCompra {
  // ======= ATRIBUTOS =======

  String? nombre;
  Usuario? propietario;
  List<Producto>? productosLista;
  List<Producto>? productosComprados;

  // ======= CONSTRUCTOR =======

  ListaCompra(String nombreLista, Usuario propietarioLista) {
    nombre = nombreLista;
    propietario = propietario;
    productosLista = [];
    productosComprados = [];
  }
}
