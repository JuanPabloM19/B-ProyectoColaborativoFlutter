import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';
import '../models/models.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  // Método para obtener productos de la base de datos
  Future<List<Product>> _fetchProducts() async {
    return await ShopDatabase.instance.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay productos disponibles'));
        } else {
          var products = snapshot.data!;
          // Mostrar los productos en una cuadrícula de 2 columnas
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos columnas
              childAspectRatio: 2 / 3, // Proporción del tamaño del producto
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductItem(products[index]);
            },
          );
        }
      },
    );
  }
}

// Método para agregar un producto al carrito
Future<void> addToCart(Product product) async {
  try {
    final item = CartItem(
        id: product.id ?? 0,
        name: product.name,
        price: product.price,
        imagePath: product.imagePath,
        quantity: 1);
    await ShopDatabase.instance.insertOrUpdateCartItem(item);
  } catch (e) {
    print('Error al agregar el producto al carrito: $e');
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mostrar la imagen si está disponible, de lo contrario, usar imagen por defecto
          product.imagePath.isNotEmpty
              ? Image.file(File(product.imagePath), width: 100, height: 100)
              : Image.asset('assets/images/laptop.png', width: 100, height: 100),
          const SizedBox(height: 10),
          Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(product.description, textAlign: TextAlign.center),
          const SizedBox(height: 5),
          Text('\$${product.price}', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          ElevatedButton(
            
            onPressed: () async {
              await addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Producto agregado al carrito!'),
                  duration: Duration(seconds: 2)));
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}

