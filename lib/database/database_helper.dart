import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_constants.dart';
import 'models/users.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._privateConstructor();
  static Database? _database;

  // Private constructor for Singleton
  DBHelper._privateConstructor();

  // Getter for the instance
  static DBHelper get instance => _instance;

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Create or open the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'halal_check.db');

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }
  Future<void> insertAdminUser(Database db) async {
    User adminUser = User(
      email: 'admin@ex.com',
      password: 'admin123',  // Plain text password for the admin
      name: 'Admin User',
      isAdmin: true,
    );

    // Insert the admin user into the users table
    await db.insert(
      tableUsers,
      adminUser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,  // Replace if any conflict
    );
  }
  // Method to create tables
  Future<void> _onCreate(Database db, int version) async {
    // Create the Users Table
    await db.execute(''' 
    CREATE TABLE $tableUsers (
      $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnUserEmail TEXT NOT NULL UNIQUE,
      $columnUserPassword TEXT NOT NULL,
      $columnUserName TEXT NOT NULL,
      $columnUserIsAdmin INTEGER DEFAULT 0
    )
  ''');
    // Insert the default admin user if the table is empty
    var userCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableUsers'));
    if (userCount == 0) {
      // Insert default admin user manually
      await insertAdminUser(db);
    }

    // Create Brands Table
    await db.execute('''
      CREATE TABLE $tableBrands (
        $columnBrandId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnBrandName TEXT NOT NULL UNIQUE
      )
    ''');

    // Create Countries Table
    await db.execute('''
      CREATE TABLE $tableCountries (
        $columnCountryId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCountryName TEXT NOT NULL UNIQUE
      )
    ''');

    // Create Categories Table
    await db.execute('''
      CREATE TABLE $tableCategories (
        $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCategoryName TEXT NOT NULL UNIQUE
      )
    ''');

    // Create Allergens Table
    await db.execute('''
      CREATE TABLE $tableAllergens (
        $columnAllergenId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnAllergenName TEXT NOT NULL UNIQUE
      )
    ''');

    // Create Ingredients Table
    await db.execute('''
      CREATE TABLE $tableIngredients (
        $columnIngredientId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnIngredientName TEXT NOT NULL UNIQUE,
        $columnECode TEXT,
        $columnIsHaram INTEGER DEFAULT 0,
        $columnIsDoubtful INTEGER DEFAULT 0,
        $columnNotes TEXT
      )
    ''');

    // Create Halal Authorities Table
    await db.execute('''
      CREATE TABLE $tableHalalAuthorities (
        $columnHalalAuthorityId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnHalalAuthorityName TEXT NOT NULL,
        $columnHalalAuthorityCountryId INTEGER,
        $columnHalalAuthorityTrustLevel TEXT DEFAULT 'medium',
        $columnHalalAuthorityNotes TEXT,
        FOREIGN KEY ($columnHalalAuthorityCountryId) REFERENCES $tableCountries($columnCountryId)
      )
    ''');

    // Create Diet Rules Table
    await db.execute('''
      CREATE TABLE $tableDietRules (
        $columnDietRuleId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDietCode TEXT NOT NULL UNIQUE,
        $columnDietDescription TEXT NOT NULL,
        $columnDietSqlCondition TEXT NOT NULL,
        $columnDietAutoAssign INTEGER DEFAULT 1
      )
    ''');

    // Create Products Table
    await db.execute('''
      CREATE TABLE $tableProducts (
        $columnProductId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnProductBarcode TEXT NOT NULL UNIQUE,
        $columnProductBrandId INTEGER,
        $columnProductName TEXT NOT NULL,
        $columnProductWeightG REAL,
        $columnProductFilling TEXT,
        $columnProductCountryId INTEGER,
        $columnProductDescription TEXT,
        $columnProductShelfLifeDays INTEGER,
        $columnProductStorageTempMin REAL,
        $columnProductStorageTempMax REAL,
        FOREIGN KEY ($columnProductBrandId) REFERENCES $tableBrands($columnBrandId),
        FOREIGN KEY ($columnProductCountryId) REFERENCES $tableCountries($columnCountryId)
      )
    ''');

    // Create Nutrition Facts Table
    await db.execute('''
      CREATE TABLE $tableNutritionFacts (
        $columnNutritionProductId INTEGER PRIMARY KEY,
        $columnProteinG REAL,
        $columnFatG REAL,
        $columnCarbG REAL,
        $columnSugarG REAL,
        $columnKcal INTEGER,
        FOREIGN KEY ($columnNutritionProductId) REFERENCES $tableProducts($columnProductId) ON DELETE CASCADE
      )
    ''');

    // Create Product Ingredients Table
    await db.execute('''
      CREATE TABLE $tableProductIngredients (
        $columnProductIngredientProductId INTEGER,
        $columnProductIngredientIngredientId INTEGER,
        $columnProductIngredientPercent REAL,
        PRIMARY KEY ($columnProductIngredientProductId, $columnProductIngredientIngredientId),
        FOREIGN KEY ($columnProductIngredientProductId) REFERENCES $tableProducts($columnProductId) ON DELETE CASCADE,
        FOREIGN KEY ($columnProductIngredientIngredientId) REFERENCES $tableIngredients($columnIngredientId) ON DELETE CASCADE
      )
    ''');

    // Create Product Allergens Table
    await db.execute('''
      CREATE TABLE $tableProductAllergens (
        $columnProductAllergenProductId INTEGER,
        $columnProductAllergenAllergenId INTEGER,
        PRIMARY KEY ($columnProductAllergenProductId, $columnProductAllergenAllergenId),
        FOREIGN KEY ($columnProductAllergenProductId) REFERENCES $tableProducts($columnProductId) ON DELETE CASCADE,
        FOREIGN KEY ($columnProductAllergenAllergenId) REFERENCES $tableAllergens($columnAllergenId) ON DELETE CASCADE
      )
    ''');

    // Create Product Categories Table
    await db.execute('''
      CREATE TABLE $tableProductCategories (
        $columnProductCategoryProductId INTEGER,
        $columnProductCategoryCategoryId INTEGER,
        PRIMARY KEY ($columnProductCategoryProductId, $columnProductCategoryCategoryId),
        FOREIGN KEY ($columnProductCategoryProductId) REFERENCES $tableProducts($columnProductId) ON DELETE CASCADE,
        FOREIGN KEY ($columnProductCategoryCategoryId) REFERENCES $tableCategories($columnCategoryId) ON DELETE CASCADE
      )
    ''');

    // Create Halal Evaluations Table
    await db.execute('''
      CREATE TABLE $tableHalalEvaluations (
        $columnEvalId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnEvalProductId INTEGER,
        $columnEvalStatus TEXT NOT NULL,
        $columnEvalSource TEXT DEFAULT 'auto',
        $columnEvalReasonType TEXT DEFAULT 'ingredient',
        $columnEvalReasonText TEXT,
        $columnEvalEvidenceUrl TEXT,
        $columnEvalUpdatedBy TEXT,
        $columnEvalUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($columnEvalProductId) REFERENCES $tableProducts($columnProductId) ON DELETE CASCADE
      )
    ''');

    // Create Product Diet Tags Table
    await db.execute('''
      CREATE TABLE $tableProductDietTags (
        $columnProductDietTagProductId INTEGER,
        $columnProductDietTagDietCode TEXT,
        $columnProductDietTagSource TEXT DEFAULT 'auto',
        $columnProductDietTagNotes TEXT,
        PRIMARY KEY ($columnProductDietTagProductId, $columnProductDietTagDietCode),
        FOREIGN KEY ($columnProductDietTagProductId) REFERENCES $tableProducts($columnProductId) ON DELETE CASCADE,
        FOREIGN KEY ($columnProductDietTagDietCode) REFERENCES $tableDietRules($columnDietCode) ON DELETE CASCADE
      )
    ''');

    // Create Certificates Table
    await db.execute('''
      CREATE TABLE $tableCertificates (
        $columnCertId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCertAuthorityId INTEGER,
        $columnCertNumber TEXT NOT NULL UNIQUE,
        $columnCertIssueDate TEXT,
        $columnCertExpiryDate TEXT,
        $columnCertImageUrl TEXT,
        $columnCertVerified INTEGER DEFAULT 0,
        $columnCertNotes TEXT,
        FOREIGN KEY ($columnCertAuthorityId) REFERENCES $tableHalalAuthorities($columnHalalAuthorityId)
      )
    ''');

    // Create Product Certificates Table
    await db.execute('''
      CREATE TABLE $tableProductCertificates (
        $columnProductCertProductId INTEGER,
        $columnProductCertCertId INTEGER,
        PRIMARY KEY ($columnProductCertProductId, $columnProductCertCertId),
        FOREIGN KEY ($columnProductCertProductId) REFERENCES $tableProducts($columnProductId) ON DELETE CASCADE,
        FOREIGN KEY ($columnProductCertCertId) REFERENCES $tableCertificates($columnCertId) ON DELETE CASCADE
      )
    ''');

    // Create Halal Evaluation History Table
    await db.execute('''
      CREATE TABLE $tableHalalEvaluationHistory (
        $columnHistoryId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnHistoryEvalId INTEGER,
        $columnHistoryPreviousStatus TEXT,
        $columnHistoryNewStatus TEXT,
        $columnHistoryChangedBy TEXT,
        $columnHistoryChangedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($columnHistoryEvalId) REFERENCES $tableHalalEvaluations($columnEvalId)
      )
    ''');
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
