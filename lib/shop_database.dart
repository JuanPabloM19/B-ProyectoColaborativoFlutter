import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class ShopDatabase {
  static final ShopDatabase instance = ShopDatabase._init();
  static Database? _database;

  ShopDatabase._init();

  final String tableProducts = 'products';
  final String tableCartItems = 'cart_items';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCartItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
  }

  // Insert CartItem into cart_items table
  Future<void> insertCartItem(CartItem item) async {
    final db = await instance.database;
    await db.insert(
      tableCartItems,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all cart items
  Future<List<CartItem>> getAllItems() async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query(tableCartItems);

      return List.generate(maps.length, (i) {
        return CartItem(
          id: maps[i]['id'],
          name: maps[i]['name'],
          price: maps[i]['price'],
          quantity: maps[i]['quantity'],
        );
      });
    } catch (e) {
      print("Error retrieving items: $e");
      return [];
    }
  }

  // Update cart item
  Future<int> updateCartItem(CartItem item) async {
    final db = await instance.database;
    return await db.update(
      tableCartItems,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // Delete cart item
  Future<int> deleteCartItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableCartItems,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

  