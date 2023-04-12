import 'package:firebase_database/firebase_database.dart';
import 'package:goshopp/models/producto.dart';

class ProductoDB {
  final DatabaseReference _productoRef =
      FirebaseDatabase.instance.ref().child('productos');

  // Almacenar un producto en la base de datos
  void guardarProducto(Producto producto) {
    _productoRef.push().set(producto.toJson());
  }

  // Obtener todos los productos de la base de datos
  Query getProductos() {
    return _productoRef;
  }
}
