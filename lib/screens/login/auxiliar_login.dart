// ============= FUNCIONES AUXILIARES PARA REGISTRO DE USUARIOS ============ //

import 'package:flutter/material.dart';

// Función que muestra un SnackBar con información
void mostrarSnackBar(String message, BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(milliseconds: 2000),
  ));
}

// Función que muestra un campo de texto para un formulario.
Padding mostrarCampoTextoForm(
    TextEditingController controller, String label, String hint) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 0),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.mail_outline_rounded,
            color: Colors.white70,
          ),
          filled: true,
          fillColor: Colors.black12,
          labelStyle: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          hintStyle: const TextStyle(color: Colors.white54),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
          labelText: label,
          hintText: hint),
    ),
  );
}
