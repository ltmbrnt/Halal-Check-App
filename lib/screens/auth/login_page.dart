import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:HalalCheck/database/models/users.dart';  // Import UserService
import '../widgets/main_navigation.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Use UserService to authenticate the user (check email and password)
    final userService = UserService();
    final user = await userService.getUserByEmailPassword(email, password);  // Fetch user using UserService

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      // Save login status
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('user_name', user.name);

      // Save the role: admin or not
      await prefs.setBool('user_is_admin', user.isAdmin);

      // Navigate to the main menu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Неверный email или пароль")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Вход"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email input field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите email' : null,
              ),
              const SizedBox(height: 16),

              // Password input field
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите пароль' : null,
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();  // Call loginUser method
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Войти", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),

              // Register Redirect Button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text("Нет аккаунта? Зарегистрироваться"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


