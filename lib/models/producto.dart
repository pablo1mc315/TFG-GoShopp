// Clase que representa cada producto de una lista de la compra

class Producto {
  // ======= ATRIBUTOS =======

  String? _nombre;
  double? _precio;
  // Foto
  final bool _estaComprado = false;

  // ======= CONSTRUCTOR =======

  Producto(String nombre, double precio) {
    _nombre = nombre;
    _precio = precio;
  }

  // ======= GETTERS =======

  String? get nombre {
    return _nombre;
  }

  double? get precio {
    return _precio;
  }

  bool get estaComprado {
    return _estaComprado;
  }
}
