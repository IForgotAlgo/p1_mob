import 'package:flutter/material.dart';
//import 'menu_page.dart';  // Certifique-se de importar a página MenuPage

class LoginPag extends StatefulWidget {
  const LoginPag({super.key});

  @override
  _LoginPagState createState() => _LoginPagState();
}

class _LoginPagState extends State<LoginPag> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Valores de e-mail e senha predefinidos (simulação)
  final String predefinedEmail = 'gabriela.camolezi@fatec.sp.gov.br';
  final String predefinedPassword = '123456';

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    // Verificação simples
    if (email == predefinedEmail && password == predefinedPassword) {
      // Se o login for bem-sucedido, navega para a tela principal do cardápio
      Navigator.pushNamed(context, 'principal');
    } else {
      // Se falhar, exibe um erro
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro de Login'),
          content: const Text('E-mail ou senha incorretos!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(192, 3, 7, 44),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),

            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 200,
                width: 200,
              ),
            ),

            const SizedBox(height: 50),

            const Text(
              'Olá!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Seja bem-vindo',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color.fromARGB(100, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color.fromARGB(100, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                login(); // Chama a função de login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(192, 3, 7, 44),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'cadastro'); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 70, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Cadastrar',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(192, 3, 7, 44),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
