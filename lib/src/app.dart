import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:producto_integrador_dam/src/screens/add_page.dart';
import 'package:producto_integrador_dam/src/screens/detail_page.dart';
import 'package:producto_integrador_dam/src/screens/edit_page.dart';
import 'package:producto_integrador_dam/src/screens/login_page.dart';
import 'package:producto_integrador_dam/src/screens/home_page.dart';
import 'package:producto_integrador_dam/src/screens/register_page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(255, 151, 149, 149),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return LoginPage();
            case "/login":
              return LoginPage();
            case "/home":
              return HomePage();
            case "/register":
              return RegisterPage();
            case "/detail":
              return DetailPage(
                pelicula: settings.arguments,
              );
            case "/edit":
              return EditPage(
                pelicula: settings.arguments,
              );
            case "/add":
              return AddPage();
            default:
              return LoginPage();
          }
        });
      },
    );
  }
}
