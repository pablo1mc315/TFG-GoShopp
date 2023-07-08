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
      .orderBy("hora")
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

// Función que comprueba si un usuario ya pertenece o no a un grupo
Future<bool> yaPerteneceGrupo(
    String nombreGrupo, String gid, String uid) async {
  DocumentSnapshot snapshot = await db.collection("usuarios").doc(uid).get();
  List<dynamic> grupos = await snapshot["grupos"];

  if (grupos.contains("${nombreGrupo}_$gid")) {
    return true;
  } else {
    return false;
  }
}

// Función que elimina a un usuario de un grupo
Future salirGrupo(
    String gid, String nombreGrupo, String correo, String uid) async {
  DocumentReference refU = db.collection("usuarios").doc(uid);
  DocumentReference refG = db.collection("grupos").doc(gid);

  DocumentSnapshot snapshotU = await refU.get();
  List<dynamic> grupos = await snapshotU['grupos'];

  DocumentSnapshot snapshotG = await refG.get();
  List<dynamic> participantes = await snapshotG['participantes'];

  // Modificamos el admin al primer participante del grupo (más antiguo)
  await refG.update({"admin": participantes[0]});

  // Si el grupo existe en el usuario, lo eliminamos
  if (grupos.contains("${nombreGrupo}_$gid")) {
    await refU.update({
      "grupos": FieldValue.arrayRemove(["${nombreGrupo}_$gid"])
    });
    await refG.update({
      "participantes": FieldValue.arrayRemove([correo])
    });
  }

  snapshotG = await refG.get();
  participantes = await snapshotG['participantes'];

  // Si el grupo ha quedado vacío, lo eliminamos definitivamente
  if (participantes.isEmpty) {
    eliminarGrupo(gid, nombreGrupo);
  }
  // Si no, modificamos el admin al primer participante del grupo (más antiguo)
  else {
    await refG.update({"admin": participantes[0]});
  }
}

// Función que añade un usuario a un grupo
Future entrarGrupo(
    String gid, String nombreGrupo, String correo, String uid) async {
  DocumentReference refU = db.collection("usuarios").doc(uid);
  DocumentReference refG = db.collection("grupos").doc(gid);

  DocumentSnapshot snapshot = await refU.get();
  List<dynamic> grupos = await snapshot['grupos'];

  // Si el grupo no existe para el usuario, lo añadimos
  if (!grupos.contains("${nombreGrupo}_$gid")) {
    await refU.update({
      "grupos": FieldValue.arrayUnion(["${nombreGrupo}_$gid"])
    });
    await refG.update({
      "participantes": FieldValue.arrayUnion([correo])
    });
  }
}

// Función que realiza el envío de un mensaje
enviarMensaje(String gid, Map<String, dynamic> mensaje) {
  db.collection("grupos").doc(gid).collection("mensajes").add(mensaje);
  db.collection("grupos").doc(gid).update({
    "ultimoMensaje": mensaje["mensaje"],
    "usuarioUltimoMensaje": mensaje["emisor"],
    "horaUltimoMensaje": mensaje["hora"].toString()
  });
}

// Función que elimina un grupo por completo
Future eliminarGrupo(String gid, String nombreGrupo) async {
  // Obtenemos todos los usuarios que pertenecen al grupo
  final snapshotU = await db
      .collection('usuarios')
      .where('grupos', arrayContains: "${nombreGrupo}_$gid")
      .get();

  // Eliminamos el grupo de cada uno de los usuarios que pertenecían a él
  for (final docU in snapshotU.docs) {
    List<String> listaGrupos = [];
    final gruposUsuario = docU['grupos'];

    // Realizamos un casting de 'dynamic' a 'String'
    for (var grupo in gruposUsuario) {
      if (grupo is String) {
        listaGrupos.add(grupo);
      }
    }

    listaGrupos.remove("${nombreGrupo}_$gid");
    docU.reference.update({'grupos': listaGrupos});
  }

  // Eliminamos el grupo de la base de datos
  DocumentReference refG = db.collection("grupos").doc(gid);
  refG.delete();
}
