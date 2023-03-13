import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final User? usuario = FirebaseAuth.instance.currentUser;
    String? email = "";

    if (usuario != null) email = usuario.email;

    return Scaffold(
      appBar: AppBar(
          leading: Container(),
          leadingWidth: 0,
          title: TextButton.icon(
            onPressed: () {
              _cerrarSesion(context);
            },
            label: const Text('Cerrar sesión',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                )),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 25,
            ),
          ),
          backgroundColor: Colors.lightBlue[900]),
      body: Center(
        child: Text(
          'Bienvenido \n $email',
          style: const TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
}
