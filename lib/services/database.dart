import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_1/models/models.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;

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
        price INTEGER NOT NULL,
        image_path TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCartItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        image_path TEXT NOT NULL
      )
    ''');
  }

  // Insertar un producto
  Future<void> insertProduct(Product product) async {
    final db = await instance.database;
    await db.insert(
      tableProducts,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtiene todos los productos
  Future<List<Product>> getAllProducts() async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query(tableProducts);

      return List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'],
          name: maps[i]['name'] ?? 'Nombre no disponible',
          description: maps[i]['description'] ?? 'Descripción no disponible',
          price: maps[i]['price'] ?? 0,
          imagePath: maps[i]['image_path'] ?? '',
        );
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error retrieving products: $e");
      return [];
    }
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

  // Insertar o actualizar CartItem en la tabla cart_items
  Future<void> insertOrUpdateCartItem(CartItem item) async {
    final db = await instance.database;

    // Verificar si el producto ya existe en el carrito
    final List<Map<String, dynamic>> maps = await db.query(
      tableCartItems,
      where: 'id = ?',
      whereArgs: [item.id],
    );

    if (maps.isNotEmpty) {
      // Si el producto ya existe, sumar la cantidad
      final existingItem = CartItem(
        id: maps.first['id'],
        name: maps.first['name'],
        price: maps.first['price'],
        quantity: maps.first['quantity'],
        imagePath: maps.first['image_path'],
      );

      // Actualizar la cantidad sumando la existente con la nueva
      final updatedItem = CartItem(
        id: existingItem.id,
        name: existingItem.name,
        price: existingItem.price,
        quantity: existingItem.quantity + item.quantity,
        imagePath: existingItem.imagePath,
      );

      // Actualizar el producto en la base de datos
      await db.update(
        tableCartItems,
        updatedItem.toMap(),
        where: 'id = ?',
        whereArgs: [updatedItem.id],
      );
    } else {
      // Si el producto no existe, insertarlo como nuevo
      await db.insert(
        tableCartItems,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
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
          imagePath: maps[i]['image_path'],
        );
      });
    } catch (e) {
      // ignore: avoid_print
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

  // Actualizar producto en la tabla de productos
  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(
      tableProducts,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableProducts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
