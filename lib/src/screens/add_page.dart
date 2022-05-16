import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  AddPage({Key? key}) : super(key: key);

  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _estrenoController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _sinopsisController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar pelicula'),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
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
                ),
                Transform.translate(
                    offset: Offset(0, -15),
                    child: Container(
                        child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _tituloController,
                              validator: _requireValidator,
                              decoration: InputDecoration(
                                labelText: 'Título',
                              ),
                            ),
                            TextFormField(
                              controller: _directorController,
                              validator: _requireValidator,
                              decoration: InputDecoration(
                                labelText: 'Director',
                              ),
                            ),
                            TextFormField(
                              controller: _estrenoController,
                              validator: _requireValidator,
                              decoration: InputDecoration(
                                labelText: 'Año de estreno',
                              ),
                            ),
                            TextFormField(
                              controller: _generoController,
                              validator: _requireValidator,
                              decoration: InputDecoration(
                                labelText: 'Género',
                              ),
                            ),
                            TextFormField(
                              controller: _sinopsisController,
                              validator: _requireValidator,
                              decoration: InputDecoration(
                                labelText: 'Sinopsis',
                              ),
                            ),
                            TextFormField(
                              controller: _imagenController,
                              validator: _requireValidator,
                              decoration: InputDecoration(
                                labelText: 'Enlace de imágen',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: raisedButtonStyle,
                                onPressed: () {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    _add_movie(context);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text("Registrar"),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ))),
              ],
            )));
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

  Future _add_movie(context) async {
    try {
      await FirebaseFirestore.instance.collection('movies').add({
        'titulo': _tituloController.text,
        'director': _directorController.text,
        'estreno': _estrenoController.text,
        'genero': _generoController.text,
        'sinopsis': _sinopsisController.text,
        'imagen': _imagenController.text,
      });

      Navigator.of(context).pushNamed(
        "/home",
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  String? _requireValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }
}
