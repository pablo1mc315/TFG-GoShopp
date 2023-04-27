// Clase que representa cada grupo de usuarios

import 'package:goshopp/models/lista_compra.dart';

class Grupo {
  // ======= ATRIBUTOS =======

  String? id;
  String? nombre;
  String? admin;
  List<String>? participantes;
  List<ListaCompra>? listasActivas;
  String? ultimoMensaje;
  String? usuarioUltimoMensaje;
  String? horaUltimoMensaje;

  // ======= CONSTRUCTOR =======

  Grupo(String idGrupo, String n, String a, List<String> p) {
    id = idGrupo;
    nombre = n;
    admin = a;
    participantes = p;
    listasActivas = [];
    ultimoMensaje = "";
    usuarioUltimoMensaje = "";
    horaUltimoMensaje = "";
  }
}
