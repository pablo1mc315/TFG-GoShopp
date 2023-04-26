import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/inicio.dart';

class CadaGrupoWidget extends StatefulWidget {
  final String? grupoID;
  final String? nombre;
  final String? admin;
  final List<String>? listaParticipantes;

  const CadaGrupoWidget(
      this.grupoID, this.nombre, this.admin, this.listaParticipantes,
      {super.key});

  @override
  State<CadaGrupoWidget> createState() => _CadaGrupoWidgetState();
}

class _CadaGrupoWidgetState extends State<CadaGrupoWidget> {
  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return const Text("Cada grupo");
  }
}
