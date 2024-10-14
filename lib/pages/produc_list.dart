import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/shop_database.dart';

import '../models/models.dart';
//import 'package:sql3/models.dart';

// ignore: must_be_immutable
class ProductList extends StatelessWidget {
  ProductList({super.key});
  var products = [
    Product(id:1, name:"Laptop 1", description: "Un Lapto muy eficicente", price: 2000),
    Product(id: 2, name: "Laptop 2", description:  "Con descuento", price: 1500),
    Product(id: 3, name: "Laptop 3", description: "Equipo  premiun ", price: 3000)
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, int index) {
          return ProducItem(products[index]);
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 5),
        itemCount: products.length);
  }
}

Future<void> addToCart(Product product) async {
  try {
    final item = CartItem(
        id: product.id, name: product.name, price: product.price, quantity: 1);
    await ShopDatabase.instance.insertCartItem(item);
  } catch (e) {
    print('Error al agregar el producto al carrito: $e');
  }
}

class ProducItem extends StatelessWidget {
  final Product product;
  const ProducItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await addToCart(product);
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
              Image.asset(
                'assets/images/laptop.png',
                width: 100,
              ),
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
