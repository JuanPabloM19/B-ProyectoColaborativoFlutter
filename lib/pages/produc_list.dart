import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/shop_database.dart';

import '../models/models.dart';
//import 'package:sql3/models.dart';

// ignore: must_be_immutable
class ProductList extends StatelessWidget {
  ProductList({super.key});
  var products = [
    Product(1, "Laptop 1", "Un Lapto muy eficicente", 2000),
    Product(2, "Laptop 2", "Con descuento", 1500),
    Product(3, "Laptop 3", "Equipo  premiun ", 3000)
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
  final item = CartItem(
      id: product.id, name: product.name, price: product.price, quantity: 1);
  await ShopDatabase.instance.insert(item);
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
