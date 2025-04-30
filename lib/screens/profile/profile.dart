import 'package:HalalCheck/screens/profile/profile_categories/personal_data_page.dart';
import 'package:HalalCheck/screens/profile/profile_categories/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Ваш аккаунт';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Добрый день!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Аватар и имя
          ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.lightGreen,
              child: const Icon(Icons.tag_faces, color: Colors.white, size: 30),
            ),
            title: Text(
              _userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: const Text("Ваш аккаунт"),
          ),
          const SizedBox(height: 10),

          // Меню
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildTile("Личные данные", Icons.person_outline, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PersonalDataPage()),
                  );
                }),
                _divider(),
                _buildTile("Настройки", Icons.settings, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                }),
                _divider(),
                _buildTile("Выйти", Icons.logout,
                    color: Colors.redAccent, onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    }),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Социальные иконки
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              children: const [
                SocialIcon(icon: Icons.camera_alt),
                SocialIcon(icon: Icons.facebook),
                SocialIcon(icon: Icons.music_note),
                SocialIcon(icon: Icons.send),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text("Версия приложения 3.0.14",
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1);

  Widget _buildTile(String title, IconData icon,
      {Color? color, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.lightGreen),
      title: Text(title, style: TextStyle(color: color ?? Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  const SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 22, color: Colors.lightGreen),
    );
  }
}


