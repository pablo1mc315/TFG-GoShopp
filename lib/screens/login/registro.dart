import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'package:goshopp/screens/login/auxiliar_login.dart';
import 'package:goshopp/screens/login/verificacion.dart';

class PaginaRegistro extends StatefulWidget {
  const PaginaRegistro({super.key});

  @override
  PaginaRegistroState createState() => PaginaRegistroState();
}

class PaginaRegistroState extends State<PaginaRegistro> {
  static bool _contrasenaVisible1 = false;
  static bool _contrasenaVisible2 = false;
  static bool visible = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    visible = false;
  }

  // Controladores de los campos del formulario
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
        backgroundColor: const Color.fromARGB(255, 0, 100, 190),
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

                // Mostrar campo de texto del formulario para el email
                mostrarCampoTextoForm(_emailController, 'Email',
                    'Introduzca un correo electrónico válido'),

                // Mostrar campo de texto del formulario para el nombre de usuario
                mostrarCampoTextoForm(_usuarioController, 'Nombre de usuario',
                    'Introduzca un nombre de usuario'),

                // Introducir contraseña
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
                        labelText: "Contraseña",
                        hintText: "Debe tener al menos 6 caracteres"),
                  ),
                ),

                // Repetir contraseña
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _contrasenaController2,
                    obscureText: !_contrasenaVisible2,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(
                              // Según el valor de passwordVisible se elige el icono
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
                        labelText: "Contraseña",
                        hintText: "Intrduzca su contraseña de nuevo"),
                  ),
                ),

                const SizedBox(height: 30),

                // Botón que registra a un usuario en la aplicación
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
                      } else if (!EmailValidator.validate(
                          _emailController.text)) {
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

                // Barra de progreso del botón de registro
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

  // ================ Funciones auxiliares ================ //

  @override
  void dispose() {
    _emailController.dispose();
    _contrasenaController1.dispose();
    _contrasenaController2.dispose();
    _usuarioController.dispose();
    super.dispose();
  }

  // Función que registra un nuevo usuario mediante email y contraseña.
  Future<void> registrarNuevoUsuario(BuildContext context) async {
    try {
      final credenciales = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _contrasenaController1.text.trim());

      await credenciales.user!
          .updateDisplayName(_usuarioController.text.trim());

      mostrarSnackBar("Usuario creado correctamente", context);
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const VerificacionCorreo()));
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

  // Función que hace visible o no la barra de carga de progreso.
  void cambiarVisibilidadIndicadorProgreso() {
    visible = !visible;
  }
}
