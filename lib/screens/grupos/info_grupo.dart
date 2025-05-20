import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/grupos/listas_grupos.dart';
import 'package:goshopp/screens/inicio.dart';
import 'package:goshopp/services/grupos.dart';
import 'package:goshopp/services/navigation.dart';

class InfoGrupo extends StatefulWidget {
  final String idGrupo;
  final String nombreGrupo;
  final String admin;

  const InfoGrupo(this.idGrupo, this.nombreGrupo, this.admin, {super.key});

  @override
  State<InfoGrupo> createState() => _InfoGrupoState();
}

class _InfoGrupoState extends State<InfoGrupo> {
  bool _cargarParticipantes = true;

  @override
  void initState() {
    super.initState();
    _cargarParticipantes = true;
  }

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Info del grupo"),
            backgroundColor: const Color.fromARGB(255, 0, 100, 190),
            actions: [
              IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Abandonar grupo"),
                            content: const Text(
                                "¿Estás seguro de que deseas abandonar el grupo?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancelar",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18))),
                              TextButton(
                                  onPressed: () async {
                                    await salirGrupo(
                                            widget.idGrupo.toString(),
                                            widget.nombreGrupo.toString(),
                                            usuario!.email.toString(),
                                            usuario.uid)
                                        .then((_) {
                                      NavigationService.pop();
                                      setState(() {
                                        _cargarParticipantes = false;
                                      });
                                      NavigationService.push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const Home()));
                                    });
                                  },
                                  child: const Text("Sí, estoy seguro",
                                      style: TextStyle(fontSize: 18)))
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.exit_to_app)),

              // Si el usuario es el administrador, permitimos borrar el grupo
              if (usuario!.email == widget.admin)
                IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Borrar grupo"),
                              content: const Text(
                                  "¿Estás seguro de que deseas borrar el grupo definitivamente?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancelar",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 18))),
                                TextButton(
                                    onPressed: () async {
                                      await eliminarGrupo(
                                              widget.idGrupo.toString(),
                                              widget.nombreGrupo.toString())
                                          .then((_) {
                                        NavigationService.pop();
                                        setState(() {
                                          _cargarParticipantes = false;
                                        });
                                        NavigationService.push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Home()));
                                      });
                                    },
                                    child: const Text("Sí, estoy seguro",
                                        style: TextStyle(fontSize: 18)))
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.delete))
            ]),
        body: Column(
          children: [
            // Información del grupo
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: const Border(
                        bottom: BorderSide(
                            width: 2, color: Color.fromARGB(255, 0, 100, 190))),
                    color: const Color.fromARGB(255, 0, 100, 190)
                        .withValues(alpha: 0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Nombre del grupo
                        Text(
                          "Grupo: ${widget.nombreGrupo}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 100, 190),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),

                        const SizedBox(height: 7),

                        // Admin del grupo
                        Text(
                          "Admin: ${widget.admin}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 100, 190),
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Mostrar listas
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 0, left: 20, right: 20),
              child: TextButton(
                onPressed: () async {
                  await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ListasGrupales(widget.idGrupo.toString())))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: const Text('Ver listas...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 100, 190),
                    )),
              ),
            ),

            // Participantes
            _cargarParticipantes ? mostrarParticipantes() : Container()
          ],
        ));
  }

  // Widget que muestra cada uno de los participantes de un grupo
  mostrarParticipantes() {
    return StreamBuilder(
        stream: getParticipantes(widget.idGrupo.toString()),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["participantes"] != null &&
                snapshot.data["participantes"].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["participantes"].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: ListTile(
                          leading: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 100, 190),
                              child: Text(
                                snapshot.data["participantes"][index][0]
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white),
                              )),
                          title: Text(snapshot.data["participantes"][index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 100, 190),
                              ))));
                },
              );
            } else {
              return const Center(
                  child: Text(
                "Aún no hay participantes en este grupo.",
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
        });
  }
}
