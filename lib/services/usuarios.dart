import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goshopp/models/usuario.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Función que obtiene los datos de un usuario por su ID
Future<Usuario> getUsuario(String uid) async {
  CollectionReference tablaUsuarios = db.collection('usuarios');
  DocumentSnapshot consulta = await tablaUsuarios.doc(uid).get();

  Usuario usuario = Usuario(consulta.get('email'),
      consulta.get('nombreUsuario'), consulta.get('urlFotoPerfil'));

  return usuario;
}

// Función que añade un usuario a la base de datos
Future<void> addUsuario(Usuario usuario, String id) async {
  Map<String, dynamic> datosUsuario = {
    "email": usuario.email,
    "nombreUsuario": usuario.nombreUsuario,
    "urlFotoPerfil": usuario.urlFotoPerfil,
    "listas": usuario.listas
  };

  await db.collection('usuarios').doc(id).set(datosUsuario);
}

// Actualizar el nombre de usuario
Future<void> modificarNombreUsuario(String uid, String nuevoNombre) async {
  await db
      .collection('usuarios')
      .doc(uid)
      .update({"nombreUsuario": nuevoNombre});
}
