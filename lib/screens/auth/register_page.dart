import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:HalalCheck/database/models/users.dart';  // Import UserService
import 'login_page.dart';  // Import LoginPage for navigation

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Register user function
  Future<void> registerUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Use UserService to check if the user already exists
    final userService = UserService();
    if (await userService.checkUserExists(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Пользователь уже зарегистрирован")),
      );
      return;
    }

    // Use UserService to register the user
    await userService.registerUser(name, email, password);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Успешная регистрация!")),
    );

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Регистрация"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name input field
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (value) => value!.isEmpty ? 'Введите имя' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Введите email' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) => value!.length < 4 ? 'Минимум 4 символа' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    registerUser(); // Call registerUser when the button is pressed
                  }
                },
                child: const Text("Зарегистрироваться"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text("Уже есть аккаунт? Войти"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


