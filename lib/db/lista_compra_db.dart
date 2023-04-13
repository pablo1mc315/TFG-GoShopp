import 'package:firebase_database/firebase_database.dart';
import 'package:goshopp/models/lista_compra.dart';

class ListaCompraDB {
  final DatabaseReference _listaRef =
      FirebaseDatabase.instance.ref().child('listas');

  // Almacenar una lista en la base de datos
  void guardarLista(ListaCompra lista) {
    _listaRef.push().set(lista.toJson());
  }

  // Obtener todas las listas de la base de datos
  Query getListas() {
    return _listaRef;
  }
}
