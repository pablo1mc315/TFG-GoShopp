import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Función que obtiene la lista de grupos de un usuario
getGruposUsuario(String uid) {
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
    "grupos": FieldValue.arrayUnion([("${nombre}_${refG.id}")])
  });
}

// Función que devuelve el ID de un grupo
String getIdGrupo(String nombreCompleto) {
  return nombreCompleto.substring(nombreCompleto.indexOf("_") + 1);
}

// Función que devuelve el nombre de un grupo
String getNombreGrupo(String nombreCompleto) {
  return nombreCompleto.substring(0, nombreCompleto.indexOf("_"));
}

// Función que devuelve los mensajes de un grupo
getChats(String gid) async {
  return db
      .collection('grupos')
      .doc(gid)
      .collection("mensajes")
      .orderBy("time")
      .snapshots();
}

// Función que devuelve el nombre del administrador de un grupo
getAdmin(String gid) async {
  DocumentSnapshot snapshot = await db.collection('grupos').doc(gid).get();

  return snapshot["admin"];
}

// Función que devuelve los participantes de un grupo
getParticipantes(String gid) {
  return db.collection("grupos").doc(gid).snapshots();
}

// Función que devuelve un lista de grupos por su nombre
buscarGruposPorNombre(String nombreGrupo) {
  return db.collection("grupos").where("nombre", isEqualTo: nombreGrupo).get();
}
