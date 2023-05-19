import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/grupos/chat.dart';
import 'package:goshopp/screens/auxiliar.dart';
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
  bool perteneceAlGrupo = false;

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

  // ================ Funciones auxiliares ================ //

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

  // Función que comprueba si un usuario pertenece o no a un grupo
  perteneceGrupo(String nombreUsuario, String gid, String nombreGrupo) async {
    final User? usuario = FirebaseAuth.instance.currentUser;

    await yaPerteneceGrupo(nombreGrupo, gid, usuario!.uid.toString())
        .then((value) {
      setState(() {
        perteneceAlGrupo = value;
      });
    });
  }

  // Widget que muestra cada uno de los grupos disponibles para el usuario
  Widget listadoGrupos(
      String nombreUsuario, String gid, String nombreGrupo, String admin) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    perteneceGrupo(nombreUsuario, gid, nombreGrupo);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: const Color.fromARGB(255, 0, 100, 190),
        child: Text(
          nombreGrupo[0].toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      title: Text(nombreGrupo,
          style: const TextStyle(
              color: Color.fromARGB(255, 0, 100, 190),
              fontWeight: FontWeight.bold)),
      subtitle: perteneceAlGrupo
          ? const Text("Ya perteneces a este grupo.",
              style: TextStyle(color: Color.fromARGB(255, 0, 100, 190)))
          : Text("Admin: $admin",
              style: const TextStyle(color: Color.fromARGB(255, 0, 100, 190))),
      trailing: perteneceAlGrupo
          ? const Text("")
          : IconButton(
              onPressed: () async {
                await entrarGrupo(gid, nombreGrupo, usuario!.email.toString(),
                        usuario.uid.toString())
                    .then((_) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Chat(gid, nombreGrupo)));
                  mostrarSnackBar("Te has unido a $nombreGrupo", "ok", context);
                });
                setState(() {
                  perteneceAlGrupo = true;
                });
              },
              icon: const Icon(Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 0, 100, 190))),
    );
  }
}
