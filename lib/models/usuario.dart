// Clase que representa el comportamiento de cada usuario de la aplicación

import 'package:goshopp/models/lista_compra.dart';

class Usuario {
  // ======= ATRIBUTOS =======

  String? email;
  String? nombreUsuario;
  String? urlFotoPerfil;
  List<ListaCompra>? listas;
  List<String>? grupos;

  // ======= CONSTRUCTOR =======

  Usuario(String e, String nU, String? url) {
    email = e;
    nombreUsuario = nU;
    urlFotoPerfil = url;
    listas = [];
    grupos = [];
  }
}
