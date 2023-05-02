import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/services/grupos.dart';

class BuscarGrupos extends StatefulWidget {
  const BuscarGrupos({super.key});

  @override
  State<BuscarGrupos> createState() => _BuscarGruposState();
}

class _BuscarGruposState extends State<BuscarGrupos> {
  final TextEditingController _textoBusqueda = TextEditingController();
  bool _cargando = false;
  QuerySnapshot? busquedaSnapshot;
  bool haBuscado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 0, 100, 190)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      controller: _textoBusqueda,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 100, 190),
                      ),
                      decoration: InputDecoration(
                          labelText: "Buscar grupo...",
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 100, 190),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                iniciarBusquedaGrupos();
                              },
                              icon: const Icon(Icons.search),
                              color: const Color.fromARGB(255, 0, 100, 190),
                              splashRadius: 20),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 100, 190),
                                width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 100, 190),
                                width: 3),
                          ))),
                )
              ],
            ),
          ),
          _cargando
              ? const CircularProgressIndicator()
              : mostrarGruposDisponibles()
        ],
      ),
    );
  }

  // Función que realiza una búsqueda de los grupos que corresponden a un nombre
  iniciarBusquedaGrupos() async {
    if (_textoBusqueda.text.isNotEmpty) {
      setState(() {
        _cargando = true;
      });

      await buscarGruposPorNombre(_textoBusqueda.text).then((snapshot) {
        setState(() {
          busquedaSnapshot = snapshot;
          _cargando = false;
          haBuscado = true;
        });
      });
    }
  }

  // Función que muestra los resultados de la búsqueda
  mostrarGruposDisponibles() {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return haBuscado
        ? ListView.builder(
            itemCount: busquedaSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return listadoGrupos(
                usuario!.displayName.toString(),
                busquedaSnapshot!.docs[index]["id"],
                busquedaSnapshot!.docs[index]["nombre"],
                busquedaSnapshot!.docs[index]["admin"],
              );
            })
        : Container();
  }

  // Widget que muestra cada uno de los grupos disponibles para el usuario
  Widget listadoGrupos(
      String nombreUsuario, String gid, String nombreGrupo, String admin) {
    return const Text("Hola");
  }
}
