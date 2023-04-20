import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/models/tipoproducto.dart';

class ListaDetalles extends StatefulWidget {
  final String? listaID;
  final String? nombre;
  final String? descripcion;

  const ListaDetalles(this.listaID, this.nombre, this.descripcion, {super.key});

  @override
  State<ListaDetalles> createState() => _ListaDetallesState();
}

class _ListaDetallesState extends State<ListaDetalles> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  TipoProducto _tipoProducto = TipoProducto.comida;

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 100, 190),
        title: Text(widget.nombre.toString()),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 22),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(children: [
          // Descripción de la lista
          Text(
            widget.descripcion.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 100, 190),
            ),
          ),

          const SizedBox(height: 35),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Nombre del producto
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                controller: _nombreController,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 0, 100, 190)),
                decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Añadir nuevo producto",
                    labelStyle: TextStyle(
                        fontSize: 22, color: Color.fromARGB(255, 0, 100, 190)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 100, 190), width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 100, 190),
                            width: 3))),
              ),
            ),

            // Precio del producto
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: TextFormField(
                  controller: _precioController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 100, 190),
                  ),
                  decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixText: "€",
                      suffixStyle: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 0, 100, 190)),
                      labelText: "Precio",
                      labelStyle: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 0, 100, 190)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 100, 190),
                              width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 100, 190),
                              width: 3))),
                ))
          ]),

          const SizedBox(height: 10),

          // Botón que registra el nuevo producto en la lista
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Selector de tipo de producto
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 0, 100, 190)),
                    fixedSize:
                        MaterialStateProperty.all(const Size.fromHeight(20))),
                child: Row(
                  children: [
                    Text("Tipo: ${getNombre(_tipoProducto)}"),
                    PopupMenuButton<TipoProducto>(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.expand_more),
                        iconSize: 22,
                        splashRadius: 20,
                        tooltip: "Seleccionar tipo de producto",
                        onSelected: (value) {
                          _tipoProducto = value;
                          setState(() {});
                        },
                        itemBuilder: ((context) => mostrarTiposProducto)),
                  ],
                ),
              ),

              // Botón que registra el nuevo producto en la lista
              SizedBox(
                  height: 40,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 40, 76),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.white70,
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text('Añadir',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )),
            ],
          ),
        ]),
      ),
    );
  }

  // Función que muestra los distintos tipo de producto seleccionables
  List<PopupMenuEntry<TipoProducto>> get mostrarTiposProducto {
    return <PopupMenuEntry<TipoProducto>>[
      const PopupMenuItem(
          value: TipoProducto.bricolaje, child: Text("Bricolaje")),
      const PopupMenuItem(value: TipoProducto.bebida, child: Text("Bebida")),
      const PopupMenuItem(value: TipoProducto.belleza, child: Text("Belleza")),
      const PopupMenuItem(value: TipoProducto.comida, child: Text("Comida")),
      const PopupMenuItem(value: TipoProducto.deporte, child: Text("Deporte")),
      const PopupMenuItem(
          value: TipoProducto.electrodomestico,
          child: Text("Electrodoméstico")),
      const PopupMenuItem(
          value: TipoProducto.medicamento, child: Text("Medicamento")),
      const PopupMenuItem(
          value: TipoProducto.mobiliario, child: Text("Mobiliario")),
      const PopupMenuItem(value: TipoProducto.ocio, child: Text("Ocio")),
      const PopupMenuItem(value: TipoProducto.ropa, child: Text("Ropa")),
      const PopupMenuItem(
          value: TipoProducto.tecnologia, child: Text("Tecnología"))
    ];
  }
}

// ================ Funciones auxiliares ================ //

// Función que devuelve el nombre del tipo de producto seleccionado
String getNombre(TipoProducto tipo) {
  var nombre = "";

  switch (tipo) {
    case TipoProducto.bebida:
      nombre = "Bebida";
      break;
    case TipoProducto.bricolaje:
      nombre = "Bricolaje";
      break;
    case TipoProducto.belleza:
      nombre = "Belleza";
      break;
    case TipoProducto.comida:
      nombre = "Comida";
      break;
    case TipoProducto.deporte:
      nombre = "Deporte";
      break;
    case TipoProducto.electrodomestico:
      nombre = "Electrodoméstico";
      break;
    case TipoProducto.medicamento:
      nombre = "Medicamento";
      break;
    case TipoProducto.mobiliario:
      nombre = "Mobiliario";
      break;
    case TipoProducto.ocio:
      nombre = "Ocio";
      break;
    case TipoProducto.ropa:
      nombre = "Ropa";
      break;
    case TipoProducto.tecnologia:
      nombre = "Tecnología";
      break;
  }

  return nombre;
}
