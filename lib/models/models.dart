class Product {
  final int? id;
  final String name;
  final String description;
  final int price;
  final String imagePath; // Campo adicional para la imagen

  Product(
      {this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imagePath});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_path': imagePath,
    };
  }
}

class CartItem {
  final int id;
  final String name;
  final int price;
  int quantity;
  final String imagePath;

  CartItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity,
      required this.imagePath});

  get totalPrice {
    return quantity * price;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_path': imagePath,
    };
  }
}
