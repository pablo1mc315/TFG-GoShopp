import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/models/tipoproducto.dart';
import 'package:goshopp/screens/listas/detalles.dart';
import 'package:goshopp/services/productos.dart';

class CadaProductoWidget extends StatefulWidget {
  final String? listaID;
  final String? productoID;
  final String? nombre;
  final double? precio;
  final TipoProducto? tipo;

  const CadaProductoWidget(
      this.listaID, this.productoID, this.nombre, this.precio, this.tipo,
      {super.key});

  @override
  State<CadaProductoWidget> createState() => _CadaProductoWidgetState();
}

class _CadaProductoWidgetState extends State<CadaProductoWidget> {
  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          SizedBox(
              height: 45,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del producto
                        Text(widget.nombre.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 40, 76),
                            )),

                        // Precio y tipo
                        Row(
                          children: [
                            Text("${widget.precio.toString()} € - ",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 40, 76),
                                )),
                            Text(getNombre(widget.tipo!))
                          ],
                        ),
                      ],
                    ),

                    // Botones
                    Row(
                      children: [
                        // Botón para marcar el producto como comprado
                        IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            bool estaComprado = await estaCompradoUsuario(
                                usuario!.uid,
                                widget.listaID!,
                                widget.productoID!);

                            comprarProductoUsuario(
                                usuario.uid,
                                widget.listaID.toString(),
                                widget.productoID.toString());

                            estaComprado = !estaComprado;
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.payments,
                            color: Color.fromARGB(255, 0, 40, 76),
                            size: 25,
                          ),
                        ),

                        // Botón para borrar el producto de la lista
                        IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            bool borrar = false;

                            borrar = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        "¿Está seguro de que desea eliminar '${widget.nombre}' de la lista?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text("Cancelar",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18))),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text("Sí, estoy seguro",
                                              style: TextStyle(fontSize: 18)))
                                    ],
                                  );
                                });

                            if (borrar) {
                              eliminarProductoUsuario(
                                  usuario!.uid,
                                  widget.listaID.toString(),
                                  widget.productoID.toString());
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 0, 40, 76),
                            size: 25,
                          ),
                        )
                      ],
                    ),
                  ]))
        ],
      ),
    );
  }
}
