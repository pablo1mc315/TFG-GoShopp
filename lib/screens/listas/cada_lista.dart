import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/grupos/listas_grupos.dart';
import 'package:goshopp/screens/inicio.dart';
import 'package:goshopp/screens/listas/detalles.dart';
import 'package:goshopp/screens/listas/editar_lista.dart';
import 'package:goshopp/services/listas.dart';
import 'package:goshopp/services/navigation.dart';

class CadaListaWidget extends StatefulWidget {
  final String listaID;
  final String nombre;
  final String descripcion;
  final bool? isGrupal;
  final String? idGrupo;

  const CadaListaWidget(this.listaID, this.nombre, this.descripcion,
      {super.key, this.isGrupal = false, this.idGrupo});

  @override
  State<CadaListaWidget> createState() => _CadaListaWidgetState();
}

class _CadaListaWidgetState extends State<CadaListaWidget> {
  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: 150,
        width: 350,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ListaDetalles(
                        widget.listaID, widget.nombre, widget.descripcion,
                        isGrupal: widget.isGrupal,
                        idGrupo: widget.idGrupo.toString())));
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 0, 40, 76),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Título de la lista
                          Text(widget.nombre.toString(),
                              style: const TextStyle(
                                fontSize: 22,
                              )),

                          // Botón para editar la lista
                          Row(
                            children: [
                              IconButton(
                                splashRadius: 20,
                                onPressed: () async {
                                  await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EditarLista(
                                                      widget.listaID,
                                                      widget.nombre,
                                                      widget.descripcion,
                                                      isGrupal: widget.isGrupal,
                                                      idGrupo: widget.idGrupo
                                                          .toString())))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 25,
                                ),
                              ),

                              // Botón para borrar la lista
                              IconButton(
                                splashRadius: 20,
                                onPressed: () async {
                                  bool borrar = false;

                                  borrar = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "¿Está seguro de que desea borrar por completo la lista seleccionada?"),
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
                                                child: const Text(
                                                    "Sí, estoy seguro",
                                                    style: TextStyle(
                                                        fontSize: 18)))
                                          ],
                                        );
                                      });

                                  if (borrar) {
                                    if (widget.isGrupal!) {
                                      await eliminarListaCompraGrupo(
                                              widget.idGrupo.toString(),
                                              widget.listaID.toString())
                                          .then((_) {
                                        NavigationService.pop();
                                        NavigationService.push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ListasGrupales(widget
                                                            .idGrupo
                                                            .toString())));
                                      });
                                    } else {
                                      eliminarListaCompraUsuario(usuario!.uid,
                                              widget.listaID.toString())
                                          .then((_) {
                                        NavigationService.pop();
                                        NavigationService.push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Home()));
                                      });
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 25,
                                ),
                              )
                            ],
                          ),
                        ]),
                  )),
              SizedBox(
                  height: 85,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: null,
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 0, 100, 190)),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        side: WidgetStatePropertyAll(
                            BorderSide(width: 1, color: Colors.white))),
                    child: Text(widget.descripcion.toString(),
                        style: const TextStyle(fontSize: 18)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
