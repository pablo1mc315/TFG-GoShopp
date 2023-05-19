import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goshopp/models/lista_compra.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Función que obtiene las listas de la compra de un usuario por su ID
Future<List<ListaCompra>> getListasCompraUsuario(String uid) async {
  List<ListaCompra> listas = [];
  CollectionReference tablaUsuarios = db.collection('usuarios');
  QuerySnapshot consulta =
      await tablaUsuarios.doc(uid).collection('listas').get();

  List<dynamic> resultados = consulta.docs;
  for (var resultado in resultados) {
    ListaCompra lista = ListaCompra(
        resultado['id'], resultado['nombre'], resultado['descripcion']);

    listas.add(lista);
  }

  return listas;
}

// Función que obtiene las listas de la compra de un grupo por su ID
Future<List<ListaCompra>> getListasCompraGrupo(String gid) async {
  List<ListaCompra> listas = [];
  CollectionReference tablaUsuarios = db.collection('grupos');
  QuerySnapshot consulta =
      await tablaUsuarios.doc(gid).collection('listas').get();

  List<dynamic> resultados = consulta.docs;
  for (var resultado in resultados) {
    ListaCompra lista = ListaCompra(
        resultado['id'], resultado['nombre'], resultado['descripcion']);

    listas.add(lista);
  }

  return listas;
}

// Función que añade una lista de la compra a un usuario
Future<void> addListaCompraUsuario(ListaCompra listaNueva, String uid) async {
  String idLista = "";

  Map<String, dynamic> lista = {
    "id": listaNueva.id,
    "nombre": listaNueva.nombre,
    "descripcion": listaNueva.descripcion,
    "idPropietario": uid
  };

  // Creamos una lista nueva con los parámetros introducidos por el usuario
  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .add(lista)
      .then((DocumentReference doc) {
    idLista = doc.id;
  });

  // Añadimos la ID de la lista recién creada para poder acceder a ella
  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .doc(idLista)
      .update({'id': idLista});
}

// Función que añade una lista de la compra a un grupo
Future<void> addListaCompraGrupo(ListaCompra listaNueva, String gid) async {
  String idLista = "";

  Map<String, dynamic> lista = {
    "id": listaNueva.id,
    "nombre": listaNueva.nombre,
    "descripcion": listaNueva.descripcion,
    "idPropietario": gid
  };

  // Creamos una lista de grupo con los parámetros introducidos
  await db
      .collection('grupos')
      .doc(gid)
      .collection('listas')
      .add(lista)
      .then((DocumentReference doc) {
    idLista = doc.id;
  });

  // Añadimos la ID de la lista recién creada para poder acceder a ella
  await db
      .collection('grupos')
      .doc(gid)
      .collection('listas')
      .doc(idLista)
      .update({'id': idLista});
}

// Función que elimina una lista de la compra de un usuario
Future<void> eliminarListaCompraUsuario(String uid, String lid) async {
  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .doc(lid)
      .delete();
}

// Función que elimina una lista de la compra de un grupo
Future<void> eliminarListaCompraGrupo(String gid, String lid) async {
  await db.collection('grupos').doc(gid).collection('listas').doc(lid).delete();
}

// Función que edita una lista de la compra de un usuario
Future<void> editarListaCompraUsuario(
    String nuevoTitulo, String nuevaDescr, String lid, String uid) async {
  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .doc(lid)
      .update({"nombre": nuevoTitulo, "descripcion": nuevaDescr});
}

// Función que edita una lista de la compra de un grupo
Future<void> editarListaCompraGrupo(
    String nuevoTitulo, String nuevaDescr, String lid, String gid) async {
  await db
      .collection('grupos')
      .doc(gid)
      .collection('listas')
      .doc(lid)
      .update({"nombre": nuevoTitulo, "descripcion": nuevaDescr});
}
