import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goshopp/screens/usuarios/auxiliar_login.dart';
import 'package:goshopp/services/imagenes.dart';
import 'package:goshopp/services/usuarios.dart';
import 'package:image_picker/image_picker.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  EditarPerfilState createState() => EditarPerfilState();
}

class EditarPerfilState extends State<EditarPerfil> {
  final TextEditingController _textoController = TextEditingController();
  final User? usuario = FirebaseAuth.instance.currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  File? imagenSubida;

  @override
  void initState() {
    super.initState();
  }

  // Controladores de los campos del formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _textoController.text = usuario!.displayName.toString();

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 0, 100, 190)),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),

                // Mostrar selector de imagen de perfil
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: CircleAvatar(
                            radius: 80,
                            backgroundColor:
                                const Color.fromARGB(255, 0, 100, 190),
                            child: mostrarImagenPerfil()),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final XFile? imagenPerfil = await getImagen();

                        setState(() {
                          if (imagenPerfil != null) {
                            imagenSubida = File(imagenPerfil.path);
                          }
                        });
                      },
                      child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black,
                          child: Icon(Icons.add)),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                // Botón que guarda la imagen de perfil
                SizedBox(
                  height: 50,
                  width: 190,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (imagenSubida != null) {
                        final url = await subirImagen(imagenSubida!);
                        modificarFotoPerfilUsuario(usuario!.uid, url);
                        await usuario!.updatePhotoURL(url).then((_) {
                          mostrarSnackBar(
                              "Imagen de perfil modificada correctamente.",
                              "ok",
                              context);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 0, 40, 76),
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
                      'Guardar imagen',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Campo de texto para modificar el nombre de usuario
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _textoController,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 0, 100, 190),
                    ),
                    decoration: const InputDecoration(
                        labelText: "Nombre de usuario",
                        labelStyle: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 0, 100, 190),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 100, 190),
                              width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 100, 190),
                              width: 3),
                        )),
                  ),
                ),

                const SizedBox(height: 30),

                // Botón que modifica el nombre de usuario
                SizedBox(
                  height: 50,
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_textoController.text.isEmpty) {
                        mostrarSnackBar(
                            'El campo es obligatorio.', "error", context);
                      } else {
                        await modificarNombreUsuario(
                                usuario!.uid, _textoController.text)
                            .then((value) {
                          usuario!.updateDisplayName(_textoController.text);
                          Navigator.pop(context);
                          mostrarSnackBar(
                              'Nombre de usuario modificado correctamente.',
                              "ok",
                              context);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 0, 40, 76),
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
                      'Guardar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mostrarImagenPerfil() {
    Widget devolver;
    bool tieneFoto = false;

    if (usuario!.photoURL != null) {
      tieneFoto = true;
    }

    if (tieneFoto) {
      if (imagenSubida != null) {
        devolver = ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.file(
              File(imagenSubida!.path),
              width: 160,
              height: 160,
            ));
      } else {
        devolver = Image.network(usuario!.photoURL.toString());
      }
    } else {
      if (imagenSubida != null) {
        devolver = ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.file(
              File(imagenSubida!.path),
              width: 160,
              height: 160,
            ));
      } else {
        devolver = Text(
          usuario!.displayName![0].toUpperCase(),
          style: const TextStyle(fontSize: 100, color: Colors.white),
        );
      }
    }

    return devolver;
  }
}
