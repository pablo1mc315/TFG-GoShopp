import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:goshopp/inicio.dart';
import 'package:goshopp/registro.dart';
import 'package:goshopp/auxiliar.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    _estaUsuarioAutenticado();
  }

  void _estaUsuarioAutenticado() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("Usuario no autenticado");
      } else {
        print("Usuario autenticado");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Login());
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static bool _contrasenaVisible = false;
  static bool visible = false;
  static bool googleVisible = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    visible = false;
    googleVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.lightBlue[900],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 200.0, bottom: 0.0),
                child: Text(
                  'GoShopp',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      labelText: 'Email',
                      hintText: 'Introduzca su correo electrónico'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 30.0),
                child: TextFormField(
                  controller: _contrasenaController,
                  obscureText: !_contrasenaVisible,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white70,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _contrasenaVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _contrasenaVisible = !_contrasenaVisible;
                            });
                          }),
                      filled: true,
                      fillColor: Colors.black12,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.white, width: 0.5),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      labelText: 'Contraseña',
                      hintText: 'Introduzca su contraseña'),
                ),
              ),
              SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_emailController.text.contains('@')) {
                      mostrarSnackBar(
                          'El correo introducido no tiene un formato correcto.',
                          context);
                    } else {
                      setState(() {
                        _cambiarEstadoIndicadorProgreso();
                      });
                      acceder(context);
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
                    'Iniciar sesión',
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
                          width: 320,
                          margin: const EdgeInsets.only(),
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            backgroundColor: Colors.blueGrey[800],
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                          )))),
              SizedBox(
                height: 30,
                width: 300,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 350,
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cambiarEstadoIndicadorProgresoGoogle();
                    });
                    accederGoogle(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
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
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Image(
                          image: AssetImage("images/google_logo.png"),
                          height: 30.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 40, right: 30),
                          child: Text(
                            'Iniciar sesión con Google',
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              backgroundColor: Colors.transparent,
                              letterSpacing: 0.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: googleVisible,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                          width: 320,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            backgroundColor: Colors.blueGrey[800],
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                          )))),
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const PaginaRegistro()));
                  },
                  child: const Text(
                    '¿Aún no tienes una cuenta? Regístrate.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> acceder(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential credencial = await auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _contrasenaController.text.trim());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
        setState(() {
          _cambiarEstadoIndicadorProgreso();
        });
      } on FirebaseAuthException catch (e) {
        mostrarSnackBar(
            "El correo y/o la contraseña introducidos no son correctos.",
            context);
        setState(() {
          _cambiarEstadoIndicadorProgreso();
        });
      }
    }
  }

  Future<void> accederGoogle(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await auth.signInWithCredential(credential);
      _formKey.currentState!.save();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      mostrarSnackBar("Lo sentimos, se produjo un error", context);
    } finally {
      setState(() {
        _cambiarEstadoIndicadorProgresoGoogle();
      });
    }
  }

  void _cambiarEstadoIndicadorProgreso() {
    visible = !visible;
  }

  void _cambiarEstadoIndicadorProgresoGoogle() {
    googleVisible = !googleVisible;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }
}
