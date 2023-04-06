import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:goshopp/main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final User? usuario = FirebaseAuth.instance.currentUser;

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
          backgroundColor: const Color.fromARGB(255, 0, 100, 190)),
      body: Center(
        child: Text(
          'Bienvenido \n ${usuario!.displayName}',
          style: const TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }
}
