import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        appBar: AppBar(
          backgroundColor: Colors.black45,
        ),
        backgroundColor: Colors.lightBlue[900],
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 30, bottom: 30),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      color: Colors.white70,
                    ),
                    filled: true,
                    fillColor: Colors.black12,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    labelText: 'Email',
                    hintText: 'Introduzca un correo electrónico válido'),
              ),
            ),
            SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
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
              ),
            )
          ],
        ))));
  }
}
