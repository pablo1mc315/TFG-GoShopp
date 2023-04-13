import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:goshopp/models/lista_compra.dart';
import 'package:goshopp/db/lista_compra_db.dart';
import 'package:goshopp/screens/listas/nueva_lista.dart';
import 'package:goshopp/widgets/cada_lista.dart';

class ListasPersonales extends StatefulWidget {
  ListasPersonales({super.key});

  final listaCompraDB = ListaCompraDB();

  @override
  State<ListasPersonales> createState() => _ListasPersonalesState();
}

class _ListasPersonalesState extends State<ListasPersonales> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              // Botón para crear nuevas listas
              SizedBox(
                  height: 45,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => NuevaLista()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 100, 190),
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

              // Mostramos cada una de las listas del usuario
              _mostrarListas(),
            ],
          )),
    );
  }

  Widget _mostrarListas() {
    return Expanded(
        child: FirebaseAnimatedList(
      query: widget.listaCompraDB.getListas(),
      itemBuilder: (context, snapshot, animation, index) {
        final json = snapshot.value as Map<dynamic, dynamic>;
        final lista = ListaCompra.fromJson(json);

        return CadaListaWidget(lista.nombre, lista.descripcion);
      },
    ));
  }
}
