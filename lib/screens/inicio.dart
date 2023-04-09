import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:goshopp/main.dart';
import 'package:goshopp/screens/usuarios/editar.dart';

import 'info.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final User? usuario = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 75,
            iconTheme: const IconThemeData(size: 35, color: Colors.white),
            centerTitle: true,
            title: const Text(
              "GoShopp",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 0, 100, 190),
            bottom: const TabBar(indicatorColor: Colors.white, tabs: <Widget>[
              Tab(text: "Mis Grupos"),
              Tab(text: "Mis Listas")
            ])),

        // Barra lateral
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 0, 40, 76),
          elevation: 50,
          child: Column(children: <Widget>[
            // Imagen de perfil o, en caso de que no exista, la inicial
            Padding(
                padding: const EdgeInsets.only(top: 120, bottom: 30),
                child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: usuario!.photoURL == null
                        ? Text(
                            usuario.displayName![0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 75,
                                color: Color.fromARGB(255, 0, 40, 76)),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.network(
                              usuario.photoURL.toString(),
                              scale: 0.5,
                            )))),

            // Nombre de usuario
            Text(
              "@${usuario.displayName}",
              style: const TextStyle(fontSize: 23, color: Colors.white),
            ),

            const SizedBox(height: 30),

            // Botón de editar perfil
            SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const EditarPerfil()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.white70,
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.edit_note,
                          size: 30,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Editar perfil',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                )))
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: 10),

            // Botón de información
            SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Info()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.white70,
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          size: 30,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Sobre nosotros',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                )))
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: 10),

            // Botón de cerrar sesión
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  _cerrarSesion(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black45,
                  shadowColor: Colors.black45,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                      color: Colors.white70,
                      width: 2,
                    ),
                  ),
                ),
                child: const Text('Cerrar sesión',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    )),
              ),
            ),
          ]),
        ),

        // Body
        body: const TabBarView(children: <Widget>[
          // Pestaña "Mis Grupos"
          Center(child: Text("Mostrar aquí los grupos")),

          // Pestaña "Mis Listas"
          Center(child: Text("Mostrar aquí las listas"))
        ]),
      ),
    );
  }

  void _cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }
}
