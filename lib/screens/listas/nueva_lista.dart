import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goshopp/models/lista_compra.dart';
import 'package:goshopp/screens/usuarios/auxiliar_login.dart';
import 'package:goshopp/services/listas.dart';

class NuevaLista extends StatefulWidget {
  const NuevaLista({super.key});

  @override
  State<NuevaLista> createState() => _NuevaListaState();
}

class _NuevaListaState extends State<NuevaLista> {
  // Controladores de los campos del formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

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
                            'El título es un campo obligatorio.', context);
                      } else {
                        // Añadimos una nueva lista con esos valores
                        ListaCompra nuevaLista = ListaCompra(
                            "",
                            _tituloController.text,
                            _descripcionController.text);

                        await addListaCompraUsuario(nuevaLista, usuario!.uid)
                            .then((_) {
                          mostrarSnackBar(
                              "Lista creada correctamente", context);
                          Navigator.pop(context);
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
                      'Crear',
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

  // Función que registra un nuevo usuario mediante email y contraseña.
  // Future<void> crearNuevaLista(BuildContext context, ListaCompra lista) async {
  //   try {
  //     // Guardamos la lista creada en la base de datos
  //     widget.listaCompraDB.guardarLista(lista);

  //     mostrarSnackBar("Lista creada correctamente", context);
  //     Navigator.pop(context);
  //   } catch (e) {
  //     mostrarSnackBar("Lo sentimos, hubo un error", context);
  //   }
  // }
}
