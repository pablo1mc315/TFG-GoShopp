import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goshopp/models/lista_compra.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Función que obtiene las listas de la compra de un usuario por su ID
Future<List<ListaCompra>> getListasCompraUsuario(String uid) async {
  List<ListaCompra> listas = [];
  CollectionReference tablaUsuarios = db.collection('usuarios');
  DocumentSnapshot consulta = await tablaUsuarios.doc(uid).get();

  List<dynamic> resultados = consulta.get('listas');
  for (var resultado in resultados) {
    ListaCompra lista =
        ListaCompra(resultado['nombre'], resultado['descripcion']);

    listas.add(lista);
  }

  return listas;
}

// Función que añade una lista de la compra a un usuario
Future<void> addListaCompraUsuario(ListaCompra listaNueva, String uid) async {
  Map<String, dynamic> lista = {
    "nombre": listaNueva.nombre,
    "descripcion": listaNueva.descripcion,
    "idPropietario": uid,
    "productosLista": listaNueva.productosLista,
    "productosComprados": listaNueva.productosComprados
  };

  await db.collection('usuarios').doc(uid).update({
    'listas': FieldValue.arrayUnion([lista])
  });
}
