import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/listas/cada_lista.dart';
import 'package:goshopp/screens/listas/nueva_lista.dart';
import 'package:goshopp/services/listas.dart';

class ListasPersonales extends StatefulWidget {
  const ListasPersonales({super.key});

  @override
  State<ListasPersonales> createState() => _ListasPersonalesState();
}

class _ListasPersonalesState extends State<ListasPersonales> {
  final User? usuario = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          // Botón para crear nuevas listas
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
                                const NuevaLista())).then((value) {
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
                  child: const Text('Nueva lista',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                )),
          ),

          // Mostramos cada una de las listas del usuario
          FutureBuilder(
              future: getListasCompraUsuario(usuario!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> widgets = [];
                  for (var lista in snapshot.data!) {
                    widgets.add(CadaListaWidget(
                        lista.id, lista.nombre, lista.descripcion));
                  }
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ListView(shrinkWrap: true, children: widgets),
                  ));
                } else {
                  return const Text(
                    "Aún no has creado ninguna lista.",
                    style: TextStyle(fontSize: 16),
                  );
                }
              })
        ],
      )),
    );
  }
}
