import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';
import '../models/models.dart';

// ignore: must_be_immutable
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
          // Mientras se cargan los productos
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Si hay un error al cargar los productos
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Si no hay productos en la base de datos
          return const Center(child: Text('No hay productos disponibles'));
        } else {
          // Mostrar la lista de productos
          var products = snapshot.data!;
          return ListView.separated(
              itemBuilder: (context, int index) {
                return ProductItem(products[index]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 5),
              itemCount: products.length);
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
    // ignore: avoid_print
    print('Error al agregar el producto al carrito: $e');
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await addToCart(product);
        // Mostrar SnackBar cuando el producto se agrega al carrito
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Producto Agregado!!'),
            duration: Duration(seconds: 3)));
      },
      child: Container(
        color: Colors.blue[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Mostrar la imagen seleccionada si está disponible, de lo contrario, usar la imagen estática
              product.imagePath.isNotEmpty
                  ? Image.file(File(product.imagePath), width: 100)
                  : Image.asset('assets/images/laptop.png', width: 100),
              const Padding(padding: EdgeInsets.only(right: 3, left: 3)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name),
                  Text(product.description),
                  Text(' ${product.price}'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
