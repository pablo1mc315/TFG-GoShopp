import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../inicio.dart';

class VerificacionCorreo extends StatefulWidget {
  const VerificacionCorreo({super.key});

  @override
  State<VerificacionCorreo> createState() => _VerificacionCorreoState();
}

class _VerificacionCorreoState extends State<VerificacionCorreo> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? usuario;
  Timer? reloj;

  @override
  void initState() {
    usuario = auth.currentUser;
    usuario?.sendEmailVerification();

    reloj = Timer.periodic(const Duration(seconds: 5), (timer) {
      comprobarSiEmailVerificado();
    });
    super.initState();
  }

  @override
  void dispose() {
    reloj?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.black45,
      ),
      backgroundColor: const Color.fromARGB(255, 0, 100, 190),
      // Body
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Se ha enviado un correo a ${usuario?.email}. Por favor, revise su correo para confirmar su email.',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> comprobarSiEmailVerificado() async {
    usuario = auth.currentUser;
    await usuario?.reload();
    if (usuario!.emailVerified) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()));
    }
  }
}
