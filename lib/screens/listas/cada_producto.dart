import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/models/tipoproducto.dart';
import 'package:goshopp/screens/listas/detalles.dart';
import 'package:goshopp/services/productos.dart';

// ignore: must_be_immutable
class CadaProductoWidget extends StatefulWidget {
  final String? listaID;
  final String? productoID;
  final String? nombre;
  final double? precio;
  final TipoProducto? tipo;
  bool? estaComprado;
  final bool isGrupal;
  final String? idGrupo;

  CadaProductoWidget(this.listaID, this.productoID, this.nombre, this.precio,
      this.tipo, this.estaComprado, this.isGrupal, this.idGrupo,
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
                            Text(getNombre(widget.tipo!)),

                            // Mostrar le precio cuando se compre toda la lista
                            // Text(" - ${widget.precio.toString()} €",
                            //     style: const TextStyle(
                            //       fontSize: 15,
                            //       color: Color.fromARGB(255, 0, 40, 76),
                            //     ))
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
                            if (widget.isGrupal) {
                              comprarProductoGrupo(
                                  widget.idGrupo.toString(),
                                  widget.listaID.toString(),
                                  widget.productoID.toString());
                            } else {
                              comprarProductoUsuario(
                                  usuario!.uid,
                                  widget.listaID.toString(),
                                  widget.productoID.toString());
                            }

                            widget.estaComprado = !widget.estaComprado!;
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
                              if (widget.isGrupal) {
                                eliminarProductoGrupo(
                                    widget.idGrupo.toString(),
                                    widget.listaID.toString(),
                                    widget.productoID.toString());
                              } else {
                                eliminarProductoUsuario(
                                    usuario!.uid,
                                    widget.listaID.toString(),
                                    widget.productoID.toString());
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 0, 40, 76),
                            size: 25,
                          ),
                        ),

                        Icon(widget.estaComprado! ? Icons.done : Icons.close,
                            color: widget.estaComprado!
                                ? Colors.green
                                : Colors.red)
                      ],
                    ),
                  ]))
        ],
      ),
    );
  }
}
