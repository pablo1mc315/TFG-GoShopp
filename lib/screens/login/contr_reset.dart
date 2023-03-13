import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:goshopp/screens/login/auxiliar_login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // AppBar
        appBar: AppBar(
          backgroundColor: Colors.black45,
        ),
        backgroundColor: Colors.lightBlue[900],
        // Body
        body: SingleChildScrollView(
            child: Form(
                child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Introduzca su correo para restablecer su contraseña.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            // Mostrar el campo de texto del formulario para el email
            mostrarCampoTextoForm(_emailController, 'Email',
                'Introduzca un correo electrónico válido'),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 350,
              child: botonEnviarCorreoResetPassword(context),
            )
          ],
        ))));
  }

  // ================ Funciones auxiliares ================ //

  // Botón que envía un correo para restablecer la contraseña
  ElevatedButton botonEnviarCorreoResetPassword(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_emailController.text.isNotEmpty) {
          FirebaseAuth.instance
              .sendPasswordResetEmail(email: _emailController.text)
              .then((value) => Navigator.of(context).pop());
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black45,
        shadowColor: Colors.black45,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Colors.white70,
            width: 2,
          ),
        ),
      ),
      child: const Text(
        'Enviar',
        style: TextStyle(
          fontSize: 19,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
