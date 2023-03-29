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
        backgroundColor: const Color.fromARGB(255, 0, 100, 190),
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
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            // Mostrar el campo de texto del formulario para el email
            mostrarCampoTextoForm(_emailController, 'Email',
                'Introduzca un correo electrónico válido'),

            const SizedBox(height: 30),

            // Botón para envial el email de reseteo de contraseña
            SizedBox(
              height: 50,
              width: 350,
              child: botonEnviarCorreoResetPassword(context, _emailController),
            )
          ],
        ))));
  }

  // ================ Funciones auxiliares ================ //

  // Botón que envía un correo para restablecer la contraseña
  ElevatedButton botonEnviarCorreoResetPassword(
      BuildContext context, TextEditingController controller) {
    return ElevatedButton(
      onPressed: () {
        if (controller.text.isNotEmpty) {
          FirebaseAuth.instance
              .sendPasswordResetEmail(email: controller.text)
              .then((value) => Navigator.of(context).pop());
          mostrarSnackBar(
              "Se ha enviado un correo a la dirección indicada.", context);
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
