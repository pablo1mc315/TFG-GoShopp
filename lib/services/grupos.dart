import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Función que obtiene la lista de grupos de un usuario
getGruposUsuario(String uid) async {
  return db.collection('usuarios').doc(uid).snapshots();
}

// Función que crea un nuevo grupo
Future crearGrupo(String email, String uid, String nombre) async {
  DocumentReference refG = await db.collection('grupos').add({
    "id": "",
    "nombre": nombre,
    "admin": email,
    "participantes": [],
    "ultimoMensaje": "",
    "usuarioUltimoMensaje": ""
  });

  await refG.update({
    "id": refG.id,
    "participantes": FieldValue.arrayUnion([email])
  });

  DocumentReference refU = db.collection('usuarios').doc(uid);

  return await refU.update({
    "grupos": FieldValue.arrayUnion([(refG.id)])
  });
}
