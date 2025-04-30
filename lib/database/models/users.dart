import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int? id;
  final String email;
  final String password;
  final String name;
  final bool isAdmin;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.isAdmin,
  });

  // Convert User to Map (for database operations)
  Map<String, dynamic> toMap() {
    return {
      columnUserId: id,
      columnUserEmail: email,
      columnUserPassword: password,
      columnUserName: name,
      columnUserIsAdmin: isAdmin ? 1 : 0, // Store boolean as 1 or 0
    };
  }

  // Convert Map to User (for reading from the database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[columnUserId],
      email: map[columnUserEmail],
      password: map[columnUserPassword],
      name: map[columnUserName],
      isAdmin: map[columnUserIsAdmin] == 1, // Convert 1 or 0 back to boolean
    );
  }
}

class UserService {
  final DBHelper _dbHelper = DBHelper.instance;
  Future<void> checkAdminUser() async {
    final userService = UserService();
    final adminUser = await userService.getAdminUser();

    if (adminUser != null) {
      print("Admin user found: ${adminUser.email}");
    } else {
      print("No admin user found.");
    }
  }

  // Get Admin User (for login or checking)
  Future<User?> getAdminUser() async {
    final db = await _dbHelper.database;
    var res = await db.query(
      tableUsers,
      where: '$columnUserIsAdmin = ?',
      whereArgs: [1],  // 1 means the user is an admin
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first); // Return the first admin user found
    }
    return null; // Return null if no admin user found
  }

  // Insert User (using plain text password)
  Future<int> insertUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableUsers,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts by replacing
    );
  }

  Future<User?> getUserByEmailPassword(String email, String password) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      tableUsers,
      where: '$columnUserEmail = ?',
      whereArgs: [email],
    );

    if (res.isNotEmpty) {
      // Safely cast the stored password to String
      String storedPassword = res.first[columnUserPassword] as String;

      // Compare the entered password with the stored password (plain text comparison)
      if (password == storedPassword) {
        return User.fromMap(res.first); // Return the user if passwords match
      }
    }
    return null;  // Return null if no user found or password does not match
  }

  // Get User by ID
  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      tableUsers,
      where: '$columnUserId = ?',
      whereArgs: [id],
    );

    if (res.isNotEmpty) {
      return User.fromMap(res.first); // Return the user found
    }
    return null; // Return null if no user found
  }

  // Update User
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableUsers,
      user.toMap(),
      where: '$columnUserId = ?',
      whereArgs: [user.id],
    );
  }

  // Delete User
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableUsers,
      where: '$columnUserId = ?',
      whereArgs: [id],
    );
  }

  // Check if a user exists by email
  Future<bool> checkUserExists(String email) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      tableUsers,
      where: '$columnUserEmail = ?',
      whereArgs: [email],
    );

    return res.isNotEmpty;  // If any user is found, return true
  }

  // Register a new user (without hashing the password)
  Future<int> registerUser(String name, String email, String password) async {
    final db = await _dbHelper.database;

    // Create a new user object with plain text password
    User user = User(
      email: email,
      password: password,  // Store the plain text password (not hashed)
      name: name,
      isAdmin: false, // Default to non-admin
    );

    // Insert the user into the database
    return await db.insert(
      tableUsers,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,  // Replace in case of conflict
    );
  }
}