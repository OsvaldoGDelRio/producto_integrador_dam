import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> peliculas =
      FirebaseFirestore.instance.collection('movies').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: peliculas,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          final data = snapshot.requireData;

          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                return Container(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        "/detail",
                        arguments: data.docs[index],
                      );
                    },
                    title: Text(data.docs[index]['titulo']),
                    subtitle: Text(data.docs[index]['estreno'].toString() +
                        '|' +
                        data.docs[index]['genero'] +
                        '|' +
                        data.docs[index]['director']),
                    trailing: Container(
                      width: 45,
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(data.docs[index]['imagen']),
                      )),
                    ),
                  ),
                );
              });
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/add");
        },
        tooltip: 'Agregar pelicula',
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 73, 72, 72),
        ),
      ),
    );
  }
}
