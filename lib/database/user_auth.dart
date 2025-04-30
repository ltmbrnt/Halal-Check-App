// lib/user_auth.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class UserAuth {
  static const String tableUsers = 'users';
  static const String columnUserId = 'id';
  static const String columnUserName = 'name';
  static const String columnUserEmail = 'email';
  static const String columnUserPassword = 'password';
  static const String columnUserIsAdmin = 'is_admin';

  Future<int> registerUser(Database db, String name, String email, String password, {bool isAdmin = false}) async {
    return await db.insert(
      tableUsers,
      {
        columnUserName: name,
        columnUserEmail: email,
        columnUserPassword: password,
        columnUserIsAdmin: isAdmin ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> loginUser(Database db, String email, String password) async {
    final result = await db.query(
      tableUsers,
      where: '$columnUserEmail = ? AND $columnUserPassword = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> checkUserExists(Database db, String email) async {
    final result = await db.query(
      tableUsers,
      where: '$columnUserEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }
}
