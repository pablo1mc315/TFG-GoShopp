import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goshopp/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:goshopp/models/usuario.dart';
import 'package:goshopp/services/navigation.dart';
import 'package:goshopp/services/usuarios.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goshopp/screens/usuarios/contr_reset.dart';
import 'package:goshopp/screens/inicio.dart';
import 'package:goshopp/screens/usuarios/registro.dart';
import 'package:goshopp/screens/auxiliar.dart';
import 'package:goshopp/screens/usuarios/verificacion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    ),
  );
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
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Login());
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  static bool _contrasenaVisible = false;
  static bool visible = false;
  static bool googleVisible = false;
  bool checkBoxMarcado = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _cargarCredencialesUsuario();
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
      backgroundColor: const Color.fromARGB(255, 0, 100, 190),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 0),
                child: Image.asset('assets/logos/logo.png',
                    width: 250, height: 250),
              ),

              const SizedBox(height: 30),

              // Introducir correo electrónico
              mostrarCampoTextoForm(
                  _emailController,
                  'Email',
                  'Introduzca su correo electrónico',
                  Icons.mail_outline_rounded),

              // Introducir contraseña
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _contrasenaController,
                  obscureText: !_contrasenaVisible,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white70,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            // Según el valor de passwordVisible se elige el icono
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
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.white, width: 0.5),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      labelText: "Contraseña",
                      hintText: "Introduzca su contraseña"),
                ),
              ),

              const SizedBox(height: 10),

              // Recordar mis credenciales
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                        value: checkBoxMarcado,
                        side: const BorderSide(color: Colors.white, width: 2),
                        activeColor: Colors.black45,
                        onChanged: _recordarCredenciales),
                    const Text("Recordar mis credenciales",
                        style: TextStyle(fontSize: 17, color: Colors.white))
                  ]),

              const SizedBox(height: 10),

              // Botón de inicio de sesión
              SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    if (!EmailValidator.validate(_emailController.text)) {
                      mostrarSnackBar(
                          'El correo introducido no tiene un formato correcto.',
                          "error");
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

              // Barra de progreso del botón de inicio de sesión
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

              // Botón de reseteo de contraseña
              SizedBox(
                height: 30,
                width: 300,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ResetPassword()));
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Botón de inicio de sesión con Google
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
                          image: AssetImage("assets/logos/google_logo.png"),
                          height: 30.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
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

              // Barra de progreso del botón de inicio de sesión con Google
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

              // Botón para acceder a la página de registro
              SizedBox(
                height: 35,
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

  // ================ Funciones auxiliares ================ //

  // Función que inicia sesión en la aplicación mediante email y contraseña.
  Future<void> acceder(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        await auth
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _contrasenaController.text.trim())
            .then((value) {
          if (auth.currentUser!.emailVerified) {
            NavigationService.push(
                MaterialPageRoute(builder: (context) => const Home()));
          } else {
            NavigationService.push(MaterialPageRoute(
                builder: (context) => const VerificacionCorreo()));
          }
        });

        setState(() {
          _cambiarEstadoIndicadorProgreso();
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found" || e.code == "wrong-password") {
          mostrarSnackBar(
              "Los valores introducidos no son correctos.", "error");
        } else {
          mostrarSnackBar("Asegúrese de rellenar todos los campos.", "error");
        }
        setState(() {
          _cambiarEstadoIndicadorProgreso();
        });
      }
    }
  }

  // Función que inicia sesión en la aplicación mediante cuenta de Google.
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

      await auth.signInWithCredential(credential).then((value) async {
        _formKey.currentState!.save();

        // Añadimos también el usuario creado a la base de datos
        Usuario nuevoUsuario = Usuario(
            auth.currentUser!.email.toString(),
            auth.currentUser!.displayName.toString(),
            auth.currentUser!.photoURL);

        await addUsuario(nuevoUsuario, auth.currentUser!.uid).then((_) {
          mostrarSnackBar("Usuario creado correctamente", "ok");

          NavigationService.push(
              MaterialPageRoute(builder: (context) => const Home()));
        });
      });
    } catch (e) {
      mostrarSnackBar("Lo sentimos, se produjo un error", "error");
    } finally {
      setState(() {
        _cambiarEstadoIndicadorProgresoGoogle();
      });
    }
  }

  // Función que hace visible o no la barra de carga de progreso.
  void _cambiarEstadoIndicadorProgreso() {
    visible = !visible;
  }

  // Función que hace visible o no la barra de carga de progreso de Google.
  void _cambiarEstadoIndicadorProgresoGoogle() {
    googleVisible = !googleVisible;
  }

  // Función que controla el recordar o no las credenciales del usuario.
  void _recordarCredenciales(bool? value) {
    checkBoxMarcado = value!;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("recordarCredenciales", value);
        prefs.setString('email', _emailController.text);
        prefs.setString('password', _contrasenaController.text);
      },
    );
    setState(() {
      checkBoxMarcado = value;
    });
  }

  // Función que carga o no los datos del usuario.
  void _cargarCredencialesUsuario() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString("email") ?? "";
      var password = prefs.getString("password") ?? "";
      var recordarCredenciales = prefs.getBool("recordarCredenciales") ?? false;

      if (recordarCredenciales) {
        setState(() {
          checkBoxMarcado = true;
        });

        _emailController.text = email;
        _contrasenaController.text = password;
      }
    } catch (e) {
      mostrarSnackBar("Lo sentimos, se ha producido un error.", "error");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }
}
