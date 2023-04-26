import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/grupos/cada_grupo.dart';
import 'package:goshopp/screens/grupos/nuevo_grupo.dart';
import 'package:goshopp/services/grupos.dart';

class ListaGrupos extends StatefulWidget {
  const ListaGrupos({super.key});

  @override
  State<ListaGrupos> createState() => _ListaGruposState();
}

class _ListaGruposState extends State<ListaGrupos> {
  final User? usuario = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const NuevoGrupo())).then((value) {
                      setState(() {});
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 40, 76),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.white70,
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Text('Nuevo grupo',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                )),
          ),

          // Mostramos cada una de las listas del usuario
          FutureBuilder(
              future: getGrupos(usuario!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> widgets = [];
                  for (var grupo in snapshot.data!) {
                    widgets.add(CadaGrupoWidget(grupo.id, grupo.nombre,
                        grupo.admin, grupo.listaParticipantes));
                  }
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ListView(shrinkWrap: true, children: widgets),
                  ));
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      )),
    );
  }
}
