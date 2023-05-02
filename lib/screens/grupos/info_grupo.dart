import 'package:flutter/material.dart';
import 'package:goshopp/services/grupos.dart';

class InfoGrupo extends StatefulWidget {
  final String? idGrupo;
  final String? nombreGrupo;
  final String? admin;

  const InfoGrupo(this.idGrupo, this.nombreGrupo, this.admin, {super.key});

  @override
  State<InfoGrupo> createState() => _InfoGrupoState();
}

class _InfoGrupoState extends State<InfoGrupo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Info del grupo"),
            backgroundColor: const Color.fromARGB(255, 0, 100, 190),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app))
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
                        .withOpacity(0.2)),
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

            // Participantes
            mostrarParticipantes()
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
                      padding: const EdgeInsets.all(15),
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
