import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

// Seleccionar una imagen de la galería de nuestro dispositivo
Future getImagen() async {
  final ImagePicker imagenController = ImagePicker();
  final XFile? imagen =
      await imagenController.pickImage(source: ImageSource.gallery);

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
