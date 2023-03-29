// Clase que representa una lista de la compra

import 'package:goshopp/models/producto.dart';
import 'package:goshopp/models/usuario.dart';

class ListaCompra {
  // ======= ATRIBUTOS =======

  String? nombre;
  Usuario? _propietario;
  List<Producto>? _productosLista;
  List<Producto>? _productosComprados;

  // ======= CONSTRUCTOR =======

  ListaCompra(String nombreLista, Usuario propietario) {
    nombre = nombreLista;
    _propietario = propietario;
    _productosLista = [];
  }

  // ======= GETTERS =======

  Usuario? get propietario {
    return _propietario;
  }

  List<Producto>? get productosLista {
    return _productosLista;
  }

  List<Producto>? get productosComprados {
    return _productosComprados;
  }
}
