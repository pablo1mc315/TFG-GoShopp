import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/grupos/info_grupo.dart';
import 'package:goshopp/screens/grupos/mensajes.dart';
import 'package:goshopp/services/grupos.dart';

class Chat extends StatefulWidget {
  final String? idGrupo;
  final String? nombreGrupo;

  const Chat(this.idGrupo, this.nombreGrupo, {super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _mensajeController = TextEditingController();
  Stream<QuerySnapshot>? chats;
  String admin = "";

  @override
  void initState() {
    getInfoGrupo();
    super.initState();
  }

  getInfoGrupo() {
    // Recuperamos los chats del grupo
    getChats(widget.idGrupo.toString()).then((val) {
      setState(() {
        chats = val;
      });
    });

    // Recuperamos el admin del grupo
    getAdmin(widget.idGrupo.toString()).then((administrador) {
      setState(() {
        admin = administrador;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.nombreGrupo.toString()),
          backgroundColor: const Color.fromARGB(255, 0, 100, 190),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => InfoGrupo(
                              widget.idGrupo, widget.nombreGrupo, admin)));
                },
                icon: const Icon(Icons.info))
          ],
        ),
        body: Stack(
          children: <Widget>[
            mostrarMensajesChat(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: const Color.fromARGB(255, 0, 40, 76),
                child: Row(children: [
                  // Mensaje a enviar
                  Expanded(
                      child: TextFormField(
                    controller: _mensajeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enviar un mensaje...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),

                  const SizedBox(
                    width: 12,
                  ),

                  // Botón de enviar mensaje
                  GestureDetector(
                    onTap: () {
                      enviar();
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.send,
                        size: 20,
                        color: Color.fromARGB(255, 0, 40, 76),
                      )),
                    ),
                  )
                ]),
              ),
            )
          ],
        ));
  }

  // Widget que muestra todos los mensajes de la conversación de un grupo
  mostrarMensajesChat() {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Mensajes(
                      snapshot.data.docs[index]['mensaje'],
                      snapshot.data.docs[index]['emisor'],
                      usuario!.displayName ==
                          snapshot.data.docs[index]['emisor']);
                },
              )
            : Container();
      },
    );
  }

  // Función que realiza el envío de un mensaje
  enviar() {
    final User? usuario = FirebaseAuth.instance.currentUser;

    if (_mensajeController.text.isNotEmpty) {
      Map<String, dynamic> mensaje = {
        "mensaje": _mensajeController.text,
        "emisor": usuario!.displayName,
        "hora": DateTime.now().millisecondsSinceEpoch,
      };

      enviarMensaje(widget.idGrupo.toString(), mensaje);

      setState(() {
        _mensajeController.clear();
      });
    }
  }
}
