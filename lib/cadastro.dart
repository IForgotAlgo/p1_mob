import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Importando para animações

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Função para registrar o usuário
  void register(
      BuildContext context, String email, String senha, String confirmSenha) {
    if (senha != confirmSenha) {
      _mostrarErro(context, 'As senhas não coincidem!');
      return;
    }

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((userCredential) {
      // Navega para a tela principal após cadastro bem-sucedido
      Navigator.pushReplacementNamed(context, 'principal');
    }).catchError((e) {
      // Exibe erros de cadastro
      _mostrarErro(context, _getErrorMessage(e.code));
    });
  }

  // Função para exibir uma mensagem de erro
  void _mostrarErro(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro de Cadastro'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  // Função para mapear erros para mensagens amigáveis
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Este e-mail já está em uso.';
      case 'invalid-email':
        return 'O formato do e-mail é inválido.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      default:
        return 'Erro desconhecido: $errorCode';
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
              )
                  .animate()
                  .fadeIn(duration: 1200.ms), // Animação de fade-in na logo
            ),
            const SizedBox(height: 50),
            const Text(
              'Cadastro',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 1200.ms), // Animação de fade-in no título
            const Text(
              'Crie uma conta para continuar',
              style: TextStyle(fontSize: 18, color: Colors.white),
            )
                .animate()
                .fadeIn(duration: 1400.ms), // Animação de fade-in no subtítulo
            const SizedBox(height: 30),
            _buildTextField(
              controller: emailController,
              label: 'E-mail',
              icon: Icons.email,
            ).animate().slideX(begin: -1, end: 0).fadeIn(
                duration: 1000.ms), // Animação de slideX e fade-in no campo
            const SizedBox(height: 20),
            _buildTextField(
              controller: passwordController,
              label: 'Senha',
              icon: Icons.lock,
              obscureText: true,
            ).animate().slideX(begin: -1, end: 0).fadeIn(
                duration: 1100.ms), // Animação de slideX e fade-in no campo
            const SizedBox(height: 20),
            _buildTextField(
              controller: confirmPasswordController,
              label: 'Confirmar Senha',
              icon: Icons.lock_outline,
              obscureText: true,
            ).animate().slideX(begin: -1, end: 0).fadeIn(
                duration: 1200.ms), // Animação de slideX e fade-in no campo
            const SizedBox(height: 40),
            _buildElevatedButton('Cadastrar', () {
              register(
                context,
                emailController.text,
                passwordController.text,
                confirmPasswordController.text,
              );
            })
                .animate()
                .fadeIn(duration: 1400.ms), // Animação de fade-in no botão
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: const Text(
                'Já tem uma conta? Faça login.',
                style: TextStyle(color: Colors.white),
              )
                  .animate()
                  .fadeIn(duration: 1500.ms), // Animação de fade-in no link
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir um campo de texto
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
