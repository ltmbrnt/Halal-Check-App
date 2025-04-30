// lib/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // Сменить пароль
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.lightGreen),
            title: const Text('Сменить пароль'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Навигация на экран смены пароля
            },
          ),
          const Divider(height: 1),

          // Тёмная тема
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6, color: Colors.lightGreen),
            title: const Text('Тёмная тема'),
            value: false, // TODO: подставить состояние темы
            onChanged: (val) {
              // TODO: Сохранить и применить тему
            },
          ),
          const Divider(height: 1),

          // Уведомления
          SwitchListTile(
            secondary: const Icon(Icons.notifications_none, color: Colors.lightGreen),
            title: const Text('Уведомления'),
            value: true, // TODO: подставить состояние уведомлений
            onChanged: (val) {
              // TODO: Сохранить настройку уведомлений
            },
          ),
        ],
      ),
    );
  }
}
