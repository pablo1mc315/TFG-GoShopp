import 'package:flutter/material.dart';

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message, String tipo) {
    final colorFondo = (tipo == 'ok')
        ? Colors.green
        : (tipo == 'error')
            ? const Color.fromARGB(255, 160, 10, 0)
            : Colors.grey;

    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 17)),
        duration: const Duration(milliseconds: 2500),
        backgroundColor: colorFondo,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }
}
