// Clase que representa cada grupo de usuarios

import 'package:goshopp/models/lista_compra.dart';
import 'package:goshopp/models/usuario.dart';

class Grupo {
  // ======= ATRIBUTOS =======

  Usuario? _admin;
  List<Usuario>? _listaParticipantes;
  List<ListaCompra>? _listasActivas;

  // ======= CONSTRUCTOR =======

  Grupo(List<Usuario> participantes) {
    _listaParticipantes = participantes;
    _listasActivas = [];
  }

  // ======= GETTERS =======

  Usuario? get admin {
    return _admin;
  }

  List<Usuario>? get listaParticipantes {
    return _listaParticipantes;
  }

  List<ListaCompra>? get listasActivas {
    return _listasActivas;
  }
}
