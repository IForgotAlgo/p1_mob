import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:plotz/cadastro.dart';
import 'package:plotz/login_pag.dart';
import 'package:plotz/principal.dart';

// Função principal para inicializar o Firebase e rodar o app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(DevicePreview(
    enabled: !kReleaseMode, // Habilita o Device Preview apenas no modo debug
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Navegação',
      initialRoute: 'login', // Define a rota inicial
      routes: {
        'login': (context) => const LoginPage(),
        'principal': (context) => const MenuPage(),
        'cadastro': (context) => const SignUpPage(),
      },
    );
  }
}
