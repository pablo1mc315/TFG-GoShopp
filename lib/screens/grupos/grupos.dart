import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/grupos/buscar_grupos.dart';
import 'package:goshopp/screens/grupos/cada_grupo.dart';
import 'package:goshopp/services/grupos.dart';

class ListaGrupos extends StatefulWidget {
  const ListaGrupos({super.key});

  @override
  State<ListaGrupos> createState() => _ListaGruposState();
}

class _ListaGruposState extends State<ListaGrupos> {
  bool _cargando = false;
  String? nombreGrupo;
  final User? usuario = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botón para buscar un grupo al que unirse
          FloatingActionButton(
            heroTag: "Buscar grupo",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const BuscarGrupos()));
            },
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 0, 40, 76),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 10),

          // Botón para crear un nuevo grupo
          FloatingActionButton(
            heroTag: "Crear grupo",
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
          )
        ],
      ),
      body: Center(
          child: StreamBuilder(
              stream: getGruposUsuario(usuario!.uid),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data["grupos"] != null &&
                      snapshot.data["grupos"].length != 0) {
                    return ListView.builder(
                      itemCount: snapshot.data["grupos"].length,
                      itemBuilder: (context, index) {
                        int i = snapshot.data["grupos"].length - index - 1;
                        return CadaGrupoWidget(
                            getIdGrupo(snapshot.data["grupos"][i]),
                            getNombreGrupo(snapshot.data["grupos"][i]));
                      },
                    );
                  } else {
                    return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Aún no se ha unido a ningún grupo. ¡Pruebe a crear uno!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 40, 76),
                          ),
                          textAlign: TextAlign.center,
                        ));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              })),
    );
  }

  // ================ Funciones auxiliares ================ //

  // Widget que muestra un diálogo para crear un nuevo grupo
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
                        },
                        child:
                            const Text("Crear", style: TextStyle(fontSize: 18)))
                  ]);
            }),
          );
        }));
  }
}
