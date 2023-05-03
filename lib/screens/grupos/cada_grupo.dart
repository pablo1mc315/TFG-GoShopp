import 'package:flutter/material.dart';
import 'package:goshopp/screens/grupos/chat.dart';

class CadaGrupoWidget extends StatefulWidget {
  final String? idGrupo;
  final String? nombreGrupo;

  const CadaGrupoWidget(this.idGrupo, this.nombreGrupo, {super.key});

  @override
  State<CadaGrupoWidget> createState() => _CadaGrupoWidgetState();
}

class _CadaGrupoWidgetState extends State<CadaGrupoWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    Chat(widget.idGrupo, widget.nombreGrupo)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: const Color.fromARGB(255, 0, 100, 190),
            child: Text(
              widget.nombreGrupo![0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          title: Text(widget.nombreGrupo.toString()),
        ),
      ),
    );
  }
}
