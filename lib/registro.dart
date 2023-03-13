import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:goshopp/inicio.dart';
import 'package:goshopp/auxiliar.dart';

class PaginaRegistro extends StatefulWidget {
  const PaginaRegistro({super.key});

  @override
  PaginaRegistroState createState() => PaginaRegistroState();
}

class PaginaRegistroState extends State<PaginaRegistro> {
  bool _contrasenaVisible1 = false;
  bool _contrasenaVisible2 = false;
  static bool visible = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    visible = false;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController1 = TextEditingController();
  final TextEditingController _contrasenaController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.lightBlue[900],
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Column(children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                  Text(
                    'Crea tu cuenta',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'y únete a GoShopp',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 20, bottom: 0),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        labelText: 'Email',
                        hintText: 'Introduzca un correo electrónico válido'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10, bottom: 0),
                  //  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _usuarioController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        labelText: 'Nombre de usuario',
                        hintText: 'Introduzca un nombre de usuario'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _contrasenaController1,
                    obscureText: !_contrasenaVisible1,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(
                              // Según el valor de passwordVisible se elige el icono
                              _contrasenaVisible1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _contrasenaVisible1 = !_contrasenaVisible1;
                              });
                            }),
                        filled: true,
                        fillColor: Colors.black12,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        hintStyle: const TextStyle(color: Colors.white54),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        labelText: 'Contraseña',
                        hintText: 'Debe tener al menos 6 caracteres'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0, bottom: 40.0),
                  child: TextFormField(
                    controller: _contrasenaController2,
                    obscureText: !_contrasenaVisible2,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(
                              _contrasenaVisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _contrasenaVisible2 = !_contrasenaVisible2;
                              });
                            }),
                        filled: true,
                        fillColor: Colors.black12,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        hintStyle: const TextStyle(color: Colors.white54),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        labelText: 'Repetir Contraseña',
                        hintText: 'Introduzca su contraseña de nuevo'),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_usuarioController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _contrasenaController1.text.isEmpty ||
                          _contrasenaController2.text.isEmpty) {
                        mostrarSnackBar(
                            'Debe rellenar todos los campos.', context);
                      } else if (!_emailController.text.contains('@')) {
                        mostrarSnackBar(
                            'El correo introducido no tiene un formato correcto.',
                            context);
                      } else if (_contrasenaController1.text.length < 6) {
                        mostrarSnackBar(
                            'La contraseña debe tener al menos 6 caracteres.',
                            context);
                      } else if (_contrasenaController1.text !=
                          _contrasenaController2.text) {
                        mostrarSnackBar(
                            'Las contraseñas no coinciden.', context);
                      } else {
                        setState(() {
                          cambiarVisibilidadIndicadorProgreso();
                        });
                        registrarNuevoUsuario(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black45,
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
                      'Regístrate',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                          width: 290,
                          margin: const EdgeInsets.only(),
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            backgroundColor: Colors.blueGrey[800],
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _contrasenaController1.dispose();
    _contrasenaController2.dispose();
    _usuarioController.dispose();
    super.dispose();
  }

  Future<void> registrarNuevoUsuario(BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _contrasenaController1.text.trim());
      mostrarSnackBar("Usuario creado correctamente", context);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        mostrarSnackBar(
            "Ya existe un usuario con ese correo electrónico.", context);
      } else {
        mostrarSnackBar("Lo sentimos, hubo un error", context);
      }
    } catch (e) {
      mostrarSnackBar("Lo sentimos, hubo un error", context);
    } finally {
      setState(() {
        cambiarVisibilidadIndicadorProgreso();
      });
    }
  }

  void cambiarVisibilidadIndicadorProgreso() {
    visible = !visible;
  }
}
