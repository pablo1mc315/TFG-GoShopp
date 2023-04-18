import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/inicio.dart';
import 'package:goshopp/screens/listas/listas.dart';
import 'package:goshopp/services/listas.dart';

class CadaListaWidget extends StatefulWidget {
  final String? listaID;
  final String? nombre;
  final String? descripcion;

  const CadaListaWidget(this.listaID, this.nombre, this.descripcion,
      {super.key});

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
          onPressed: () {},
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
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.playlist_add_check_circle_outlined,
                        size: 30,
                      ),
                    ),
                    Text(widget.nombre.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 160),
                      child: IconButton(
                        splashRadius: 10,
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const Home()));
                                        },
                                        child: const Text("Sí, estoy seguro",
                                            style: TextStyle(fontSize: 18)))
                                  ],
                                );
                              });

                          if (borrar) {
                            eliminarListaCompraUsuario(
                                usuario!.uid, widget.listaID.toString());
                          }
                        },
                        icon: const Icon(
                          Icons.cancel_presentation,
                          size: 30,
                        ),
                      ),
                    ),
                  ])),
              SizedBox(
                  height: 85,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: null,
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 0, 100, 190)),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        side: MaterialStatePropertyAll(
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
