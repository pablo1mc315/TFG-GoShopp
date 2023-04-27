import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/usuarios/auxiliar_login.dart';
import 'package:goshopp/services/grupos.dart';

class ListaGrupos extends StatefulWidget {
  const ListaGrupos({super.key});

  @override
  State<ListaGrupos> createState() => _ListaGruposState();
}

class _ListaGruposState extends State<ListaGrupos> {
  bool _cargando = false;
  final User? usuario = FirebaseAuth.instance.currentUser;
  String? nombreGrupo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nuevoGrupo(context);
        },
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 40, 76),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Center(
          child: StreamBuilder(
              stream: getGruposUsuario(usuario!.uid),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!["grupos"] != null &&
                      snapshot.data!["grupos"].length != 0) {
                    // TODO: mostrar listado de grupos
                    return const Text("Mostrar listado de grupos");
                  } else {
                    return const Center(
                        child: Text(
                            "No se ha unido a ningún grupo. ¡Pruebe a crear uno!"));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              })),
    );
  }

  nuevoGrupo(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                  title: const Text("Nuevo grupo",
                      style:
                          TextStyle(color: Color.fromARGB(255, 0, 100, 190))),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 20),
                    _cargando
                        ? const Center(child: CircularProgressIndicator())
                        : TextFormField(
                            onChanged: (nombre) {
                              setState(() {
                                nombreGrupo = nombre;
                              });
                            },
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 100, 190)),
                            decoration: const InputDecoration(
                                label: Text("Nombre"),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 0, 100, 190)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 0, 100, 190),
                                        width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 0, 100, 190),
                                        width: 3))),
                          ),
                  ]),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar",
                            style: TextStyle(color: Colors.red, fontSize: 18))),
                    TextButton(
                        onPressed: () async {
                          if (nombreGrupo!.isNotEmpty) {
                            setState(() {
                              _cargando = true;
                            });
                            crearGrupo(usuario!.email.toString(), usuario!.uid,
                                    nombreGrupo!)
                                .whenComplete(() => _cargando = false);
                          }
                          Navigator.pop(context);
                          mostrarSnackBar(
                              "Grupo creado correctamente", "ok", context);
                        },
                        child:
                            const Text("Crear", style: TextStyle(fontSize: 18)))
                  ]);
            }),
          );
        }));
  }
}
