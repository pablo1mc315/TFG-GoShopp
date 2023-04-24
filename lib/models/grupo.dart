// Clase que representa cada grupo de usuarios

import 'package:goshopp/models/lista_compra.dart';
import 'package:goshopp/models/usuario.dart';

class Grupo {
  // ======= ATRIBUTOS =======

  Usuario? admin;
  List<Usuario>? listaParticipantes;
  List<ListaCompra>? listasActivas;

  // ======= CONSTRUCTOR =======

  Grupo(List<Usuario> participantes) {
    listaParticipantes = participantes;
    listasActivas = [];
  }
}
