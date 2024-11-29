import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Página de Login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Função de login
  void login(String email, String senha) {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha)
      .then((userCredential) {
        Navigator.pushReplacementNamed(context, 'principal');
      }).catchError((e) {
        _mostrarErro(e.message);
      });
  }

  // Função para exibir um erro
  void _mostrarErro(String erro) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro de Login'),
        content: Text(erro),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(192, 3, 7, 44),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 200,
                width: 200,
              ).animate().fadeIn(duration: 1000.ms),  // Logo com animação de fade-in
            ),
            const SizedBox(height: 30),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Entre na sua conta',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 40),
            // Campo de E-mail com animação
            _buildTextField(
              controller: emailController,
              label: 'E-mail',
              icon: Icons.email,
            ),
            const SizedBox(height: 20),
            // Campo de Senha com animação
            _buildTextField(
              controller: passwordController,
              label: 'Senha',
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 40),
            // Botão de login com animação
            _buildElevatedButton('Entrar', () {
              login(emailController.text, passwordController.text);
            }).animate().fadeIn(duration: 1000.ms).scale(duration: 500.ms),  // Animação de fade-in e scale
            const SizedBox(height: 20),
            // Link para cadastro
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'cadastro');
              },
              child: const Text(
                'Ainda não tem conta? Cadastre-se.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir o campo de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color.fromARGB(100, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  // Método auxiliar para construir um botão
  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          color: Color.fromARGB(192, 3, 7, 44),
        ),
      ),
    );
  }
}
