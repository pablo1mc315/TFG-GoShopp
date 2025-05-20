// ============= FUNCIONES AUXILIARES PARA REGISTRO DE USUARIOS ============ //

import 'package:flutter/material.dart';
import 'package:goshopp/services/snackbar.dart';

void mostrarSnackBar(String message, String tipo) {
  SnackbarService.show(message, tipo);
}

// Función que muestra un campo de texto para un formulario.
Padding mostrarCampoTextoForm(TextEditingController controller, String label,
    String hint, IconData icono) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 0),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          prefixIcon: Icon(
            icono,
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
