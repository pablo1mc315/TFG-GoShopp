import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goshopp/models/grupo.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Función que crea un nuevo grupo
Future<void> crearGrupo(Grupo grupoNuevo, String admin) async {
  Map<String, dynamic> grupo = {
    "id": grupoNuevo.id,
    "nombre": grupoNuevo.nombre,
    "admin": admin,
    "listaParticipantes": grupoNuevo.listaParticipantes,
    "listasActivas": grupoNuevo.listasActivas
  };

  // Creamos el grupo nuevo en la base de datos
  await db.collection('grupos').add(grupo);
}

// Función que obtiene los grupos a los que pertenece un usuario por su ID
Future<List<Grupo>> getGrupos(String nombreUsuario) async {
  List<Grupo> grupos = [];
  await db
      .collection('grupos')
      .where("listaParticipantes", arrayContains: nombreUsuario)
      .get()
      .then((value) {
    for (var resultado in value.docs) {
      Grupo grupo = Grupo(resultado['id'], resultado['nombre'],
          resultado['admin'], resultado['listaParticipantes']);
      grupos.add(grupo);
    }
  });

  return grupos;
}

// Función que añade a un usuario a un grupo
Future<void> addUsuario(String nombreUsuario, String gid) async {
  await db.collection('grupos').doc(gid).update({
    "listaParticipantes": FieldValue.arrayUnion([nombreUsuario])
  });
}

// Función que elimina a un usuario de un grupo
Future<void> eliminarUsuario(String nombreUsuario, String gid) async {
  await db.collection('grupos').doc(gid).update({
    "listaParticipantes": FieldValue.arrayRemove([nombreUsuario])
  });
}
