import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:plotz/cadastro.dart';
import 'package:plotz/login_pag.dart';
import 'package:plotz/principal.dart';
// *import 'package:plotz/principal.dart';

void main() {
  runApp(DevicePreview(
    builder: (context) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      title: 'Navegação',

      //Rotas de navegação

      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPag(),
        'principal': (context) => MenuPage(),
        'cadastro': (context) => SignUpPage(),
      }
    );
  }
}

