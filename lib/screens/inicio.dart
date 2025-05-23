import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:goshopp/main.dart';
import 'package:goshopp/screens/grupos/grupos.dart';
import 'package:goshopp/screens/listas/listas.dart';
import 'package:goshopp/screens/usuarios/editar_usuario.dart';
import 'package:goshopp/services/navigation.dart';
import 'package:goshopp/services/usuarios.dart';
import 'package:goshopp/screens/info.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              Tab(text: "Mis Listas"),
              Tab(text: "Mis Grupos")
            ])),

        // Barra lateral
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 0, 40, 76),
          elevation: 50,
          child: FutureBuilder(
              future: getUsuario(usuario!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: <Widget>[
                    // Imagen de perfil o, en caso de que no exista, la inicial
                    Padding(
                        padding: const EdgeInsets.only(top: 120, bottom: 30),
                        child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: snapshot.data!.urlFotoPerfil == '' ||
                                    snapshot.data!.urlFotoPerfil == null
                                ? Text(
                                    snapshot.data!.nombreUsuario![0]
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 75,
                                        color: Color.fromARGB(255, 0, 40, 76)),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Image.network(
                                      snapshot.data!.urlFotoPerfil.toString(),
                                      scale: 0.5,
                                    )))),

                    // Nombre de usuario
                    Text(
                      "@${snapshot.data!.nombreUsuario}",
                      style: const TextStyle(fontSize: 23, color: Colors.white),
                    ),

                    const SizedBox(height: 30),

                    // Botón de editar perfil
                    SizedBox(
                        height: 50,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const EditarPerfil())).then((value) {
                              setState(() {});
                            });
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Info()));
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
                  ]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),

        // Body
        body: const TabBarView(children: <Widget>[
          // Pestaña "Mis Listas"
          Center(child: ListasPersonales()),

          // Pestaña "Mis Grupos"
          Center(child: ListaGrupos())
        ]),
      ),
    );
  }

  // ================ Funciones auxiliares ================ //

  // Cerrar la sesión del usuario actual en la aplicación
  void _cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      NavigationService.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainPage()),
          (route) => false);
    });
  }
}
