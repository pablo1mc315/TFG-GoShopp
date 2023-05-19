import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

// Seleccionar una imagen de la galería de nuestro dispositivo
Future getImagen() async {
  final imagen = await ImagePicker().pickImage(source: ImageSource.gallery);

  return imagen;
}

// Subir la imagen a Firebase Storage
Future<String> subirImagen(File imagen) async {
  final nombreImagen = imagen.path.split("/").last;

  Reference ref = storage.ref().child('imagenesPerfil').child(nombreImagen);

  final UploadTask subirImagen = ref.putFile(imagen);
  final TaskSnapshot snapshot = await subirImagen.whenComplete(() => true);
  final String url = await snapshot.ref.getDownloadURL();

  if (snapshot.state == TaskState.success) {
    return url;
  } else {
    return "";
  }
}

// Mostrar modal para abrir la cámara o la galería
Future<ImageSource?> abrirModalObtenerImagen(BuildContext context) async {
  return showModalBottomSheet(
      context: context,
      builder: ((context) => Container(
            height: 160,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              // Galeria
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Seleccionar de la galería"),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),

              // Cámara
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Tomar una foto"),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              )
            ]),
          )));
}
