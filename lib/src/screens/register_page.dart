import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Stack(
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
              margin: const EdgeInsets.only(left: 10, right: 10, top: 200),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text("Registro", style: TextStyle(fontSize: 30)),
                    TextFormField(
                      controller: _emailController,
                      validator: _requireValidator,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo:',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordController,
                      validator: _requireValidator,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña:',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordRepeatController,
                      validator: _confirmPasswordValidator,
                      decoration: const InputDecoration(
                        labelText: 'Repetir contraseña:',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            _sign_up();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Registrar"),
                          ],
                        )),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Ya tienes cuenta?"),
                        TextButton(
                          child: const Text("Iniciar sesión"),
                          onPressed: () {
                            _showLogin(context);
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
      ),
    ));
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

  void _showLogin(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/login",
    );
  }

  String? _requireValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  Future _sign_up() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      Navigator.of(context).pushNamed(
        "/home",
      );
    } on FirebaseAuthException catch (e) {
      _handleSignUpError(e);
    }
  }

  void _handleSignUpError(FirebaseAuthException e) {
    String messageToDisplay;
    switch (e.code) {
      case 'email-already-in-use':
        messageToDisplay = 'El correo ya está en uso';
        break;
      case 'invalid-email':
        messageToDisplay = 'El correo es inválido';
        break;
      case 'weak-password':
        messageToDisplay = 'La contraseña es muy débil';
        break;
      case 'operation-not-allowed':
        messageToDisplay = 'No se puede realizar esta operación';
        break;
      default:
        messageToDisplay = 'Error desconocido';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error al registrarse'),
            content: Text(messageToDisplay),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
