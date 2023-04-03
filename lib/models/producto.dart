// Enumerado que distingue los distintos tipos de productos que puede haber

enum TipoProducto {
  bricolaje,
  bebida,
  belleza,
  comida,
  deporte,
  electrodomestico,
  medicamento,
  mobiliario,
  ocio,
  ropa,
  tecnologia
}

// Clase que representa cada producto de una lista de la compra

class Producto {
  // ======= ATRIBUTOS =======

  String? nombre;
  double? precio;
  int? cantidad;
  String? medida;
  TipoProducto? tipo;
  bool? estaComprado;

  // ======= CONSTRUCTOR =======

  Producto(String nombreProducto, double precioProducto) {
    nombre = nombreProducto;
    precio = precioProducto;
    estaComprado = false;
  }
}
