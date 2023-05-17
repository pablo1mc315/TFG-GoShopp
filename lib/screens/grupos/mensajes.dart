import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Mensajes extends StatefulWidget {
  final String mensaje;
  final Timestamp hora;
  final String emisor;
  final bool enviadoPorMi;

  const Mensajes(this.mensaje, this.hora, this.emisor, this.enviadoPorMi,
      {super.key});

  @override
  State<Mensajes> createState() => _MensajesState();
}

class _MensajesState extends State<Mensajes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: widget.enviadoPorMi ? 0 : 20,
          right: widget.enviadoPorMi ? 20 : 0),
      alignment:
          widget.enviadoPorMi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.enviadoPorMi
            ? const EdgeInsets.only(left: 20)
            : const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: widget.enviadoPorMi
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.enviadoPorMi
                ? const Color.fromARGB(255, 0, 40, 76)
                : const Color.fromARGB(255, 0, 100, 190)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.emisor} - ${widget.hora.toDate().toLocal().hour}:${widget.hora.toDate().minute}",
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.mensaje,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 17, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
