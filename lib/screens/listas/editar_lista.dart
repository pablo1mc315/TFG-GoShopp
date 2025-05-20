import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/screens/inicio.dart';
import 'package:goshopp/screens/auxiliar.dart';
import 'package:goshopp/services/listas.dart';
import 'package:goshopp/services/navigation.dart';

class EditarLista extends StatefulWidget {
  final String? listaID;
  final String? nombre;
  final String? descripcion;
  final bool? isGrupal;
  final String? idGrupo;

  const EditarLista(this.listaID, this.nombre, this.descripcion,
      {super.key, this.isGrupal = false, this.idGrupo});

  @override
  State<EditarLista> createState() => _EditarListaState();
}

class _EditarListaState extends State<EditarLista> {
  // Controladores de los campos del formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;
    _tituloController.text = widget.nombre!;
    _descripcionController.text = widget.descripcion!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 100, 190),
      ),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),

                // Introducir título
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextFormField(
                    maxLength: 20,
                    controller: _tituloController,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 0, 100, 190),
                    ),
                    decoration: const InputDecoration(
                        labelText: "Título",
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

                // Introducir descripción
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _descripcionController,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 0, 100, 190),
                    ),
                    minLines: 10,
                    maxLines: 15,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        labelText: "Descripción",
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

                // Botón que registra a un usuario en la aplicación
                SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_tituloController.text.isEmpty) {
                        mostrarSnackBar(
                            "La lista debe tener un título", "error");
                      } else {
                        if (widget.isGrupal!) {
                          await editarListaCompraGrupo(
                                  _tituloController.text,
                                  _descripcionController.text,
                                  widget.listaID.toString(),
                                  widget.idGrupo.toString())
                              .then((_) {
                            mostrarSnackBar(
                                "Lista modificada correctamente", "ok");
                            NavigationService.pop();
                            NavigationService.push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Home()));
                          });
                        } else {
                          await editarListaCompraUsuario(
                                  _tituloController.text,
                                  _descripcionController.text,
                                  widget.listaID.toString(),
                                  usuario!.uid)
                              .then((_) {
                            mostrarSnackBar(
                                "Lista modificada correctamente", "ok");
                            NavigationService.pop();
                            NavigationService.push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Home()));
                          });
                        }
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

  // ================ Funciones auxiliares ================ //

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
}
