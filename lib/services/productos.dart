import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goshopp/models/producto.dart';
import 'package:goshopp/models/tipoproducto.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Función que obtiene los producto de una lista de un usuario por su ID
Future<List<Producto>> getProductosUsuario(String uid, String lid) async {
  List<Producto> productos = [];
  CollectionReference tablaUsuarios = db.collection('usuarios');
  QuerySnapshot consulta = await tablaUsuarios
      .doc(uid)
      .collection('listas')
      .doc(lid)
      .collection('productosLista')
      .get();

  List<dynamic> resultados = consulta.docs;
  for (var resultado in resultados) {
    TipoProducto tipo = obtenerTipoProducto(resultado["tipo"]);

    Producto producto = Producto(resultado['id'], resultado['nombre'], tipo);

    productos.add(producto);
  }

  return productos;
}

// Función que añade un producto a una lista de la compra de un usuario
Future<void> addProductoUsuario(
    Producto nuevoProducto, String lid, String uid) async {
  String idProducto = "";

  Map<String, dynamic> producto = {
    "id": nuevoProducto.id,
    "nombre": nuevoProducto.nombre,
    "precio": nuevoProducto.precio,
    "tipo": nuevoProducto.tipo.toString(),
    "estaComprado": nuevoProducto.estaComprado
  };

  // Creamos un nuevo producto con los parámetros introducidos
  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .doc(lid)
      .collection('productosLista')
      .add(producto)
      .then((DocumentReference doc) {
    idProducto = doc.id;
  });

  // Añadimos la ID del producto recién creado para poder acceder a ella
  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .doc(lid)
      .collection('productosLista')
      .doc(idProducto)
      .update({'id': idProducto});
}

// Función que elimina un producto de la lista de la compra de un usuario
Future<void> eliminarProductoUsuario(String uid, String lid, String pid) async {
  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .doc(lid)
      .collection('productosLista')
      .doc(pid)
      .delete();
}

// Función que marca un producto de un usuario como comprado o no según su valor
Future<void> comprarProductoUsuario(String uid, String lid, String pid) async {
  bool estaComprado = await estaCompradoUsuario(uid, lid, pid);

  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .doc(lid)
      .collection('productosLista')
      .doc(pid)
      .update({"estaComprado": !estaComprado});
}

// Función que comprueba si un producto de un usuario está comprado o no
Future<bool> estaCompradoUsuario(String uid, String lid, String pid) async {
  bool estaComprado = false;

  // Obtenemos el valor actual de la variable
  await db
      .collection('usuarios')
      .doc(uid)
      .collection('listas')
      .doc(lid)
      .collection('productosLista')
      .doc(pid)
      .get()
      .then((doc) {
    estaComprado = doc.data()!['estaComprado'];
  });

  return estaComprado;
}

// Función auxiliar que transforma un string a TipoProducto
TipoProducto obtenerTipoProducto(String tipoString) {
  TipoProducto tipo = TipoProducto.comida;

  switch (tipoString) {
    case "TipoProducto.bebida":
      tipo = TipoProducto.bebida;
      break;
    case "TipoProducto.bricolaje":
      tipo = TipoProducto.bricolaje;
      break;
    case "TipoProducto.belleza":
      tipo = TipoProducto.belleza;
      break;
    case "TipoProducto.comida":
      tipo = TipoProducto.comida;
      break;
    case "TipoProducto.deporte":
      tipo = TipoProducto.deporte;
      break;
    case "TipoProducto.electrodoméstico":
      tipo = TipoProducto.electrodomestico;
      break;
    case "TipoProducto.medicamento":
      tipo = TipoProducto.medicamento;
      break;
    case "TipoProducto.mobiliario":
      tipo = TipoProducto.mobiliario;
      break;
    case "TipoProducto.ocio":
      tipo = TipoProducto.ocio;
      break;
    case "TipoProducto.ropa":
      tipo = TipoProducto.ropa;
      break;
    case "TipoProducto.tecnología":
      tipo = TipoProducto.tecnologia;
      break;
  }

  return tipo;
}
