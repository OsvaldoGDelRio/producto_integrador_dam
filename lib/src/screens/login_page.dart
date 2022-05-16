import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<User?> loginUsingEmailPass(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found");
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Scaffold(
        body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 170, 170, 172),
                        Color.fromARGB(228, 240, 242, 245)
                      ])),
                      child: Icon(
                        Icons.ondemand_video,
                        size: 200,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -80),
                      child: Center(
                          child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 200),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Iniciar sesión",
                                      style: TextStyle(fontSize: 30)),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Correo:',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      labelText: 'Contraseña:',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 30),
                                  ElevatedButton(
                                      style: raisedButtonStyle,
                                      onPressed: () async {
                                        User? user = await loginUsingEmailPass(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            context: context);
                                        print(user);
                                        if (user != null) {
                                          Navigator.of(context).pushNamed(
                                            "/home",
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text("Entrar"),
                                          if (_loading)
                                            Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.only(
                                                  left: 20),
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                        ],
                                      )),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text("No tienes cuenta?"),
                                      TextButton(
                                        child: const Text("Registrate"),
                                        onPressed: () {
                                          _showRegister(context);
                                        },
                                      )
                                    ],
                                  )
                                ]),
                          ),
                        ),
                      )),
                    )
                  ],
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  void _login(BuildContext context) {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
    }
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/register",
    );
  }
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(100, 45),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
