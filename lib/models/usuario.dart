// Clase que representa el comportamiento de cada usuario de la aplicación

import 'package:goshopp/models/lista_compra.dart';

class Usuario {
  // ======= ATRIBUTOS =======

  String? email;
  String? nombreUsuario;
  String? urlFotoPerfil;
  List<ListaCompra>? listas;

  // ======= CONSTRUCTOR =======

  Usuario(String e, String nU, String? url) {
    email = email;
    nombreUsuario = nU;
    urlFotoPerfil = url;
    listas = [];
  }
}
