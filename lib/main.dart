import 'dart:io';
import 'package:HalalCheck/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/database_helper.dart';
import 'screens/auth/login_page.dart';
import 'screens/widgets/main_navigation.dart';
import 'screens/chatbot/chatbot_page.dart'; // 👈 подключаем чат
import 'utils/custom_http_override.dart'; // 👈 для SSL

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure the admin user is inserted if the database is empty
  await DBHelper.instance.insertAdminUser(await DBHelper.instance.database);

  HttpOverrides.global = MyHttpOverrides();  // Custom HTTP override for SSL

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halal App',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()), // Loading screen while checking login status
            );
          } else if (snapshot.data == true) {
            return const MainNavigationScreen(); // If logged in, navigate to Main Navigation Screen
          } else {
            return const LoginPage(); // If not logged in, show the LoginPage
          }
        },
      ),
    );
  }
}