import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/grupos/info_grupo.dart';
import 'package:goshopp/services/grupos.dart';

class Chat extends StatefulWidget {
  final String? idGrupo;
  final String? nombreGrupo;

  const Chat(this.idGrupo, this.nombreGrupo, {super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
    final User? usuario = FirebaseAuth.instance.currentUser;

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
    );
  }
}
