import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  EditarPerfilState createState() => EditarPerfilState();
}

class EditarPerfilState extends State<EditarPerfil> {
  FirebaseAuth auth = FirebaseAuth.instance;
  XFile? imagenPerfil;

  @override
  void initState() {
    super.initState();
  }

  final User? usuario = FirebaseAuth.instance.currentUser;

  // Controladores de los campos del formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagenController = ImagePicker();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 0, 100, 190)),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Column(children: <Widget>[
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
                          imagenPerfil = await _imagenController.pickImage(
                              source: ImageSource.gallery);

                          setState(() {});
                        },
                        child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            child: Icon(Icons.add)),
                      )
                    ],
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  mostrarImagenPerfil() {
    if (imagenPerfil == null) {
      return Text(
        usuario!.displayName![0].toUpperCase(),
        style: const TextStyle(fontSize: 100, color: Colors.white),
      );
    } else if (usuario!.photoURL != null) {
      return Image.network(usuario!.photoURL.toString());
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Image.file(
            File(imagenPerfil!.path),
            width: 160,
            height: 160,
          ));
    }
  }
}
