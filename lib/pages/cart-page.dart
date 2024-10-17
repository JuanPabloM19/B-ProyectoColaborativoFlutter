import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/notifier.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CartNotifier>(
        builder: (context, cart, child) {
          return FutureBuilder(
              future: ShopDatabase.instance.getAllItems(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CartItem>> snapshot) {
                if (snapshot.hasData) {
                  List<CartItem> cartItems = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: cartItems.isEmpty
                            ? const Center(
                                child: Text(
                                  "No hay productos en tu carrito",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(10.0),
                                itemCount: cartItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _CartItem(cartItems[index]);
                                },
                              ),
                      ),
                      _CartSummary(
                          total: cartItems.fold(
                              0, (sum, item) => sum + item.totalPrice))
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        },
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItem cartItem;

  const _CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            cartItem.imagePath.isNotEmpty
                ? Image.file(File(cartItem.imagePath), width: 60, height: 60)
                : Image.asset('assets/images/laptop.png',
                    width: 60, height: 60),
            const SizedBox(width: 15),

            // Nombre del producto y cantidad
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto
                  Text(
                    cartItem.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Botones de cantidad
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          cartItem.quantity++;
                          await ShopDatabase.instance.updateCartItem(cartItem);
                          Provider.of<CartNotifier>(context, listen: false)
                              .shoulRefresf();
                        },
                        icon: const Icon(Icons.add_circle),
                      ),
                      Text(
                        "${cartItem.quantity}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () async {
                          cartItem.quantity--;
                          if (cartItem.quantity == 0) {
                            await ShopDatabase.instance
                                .deleteCartItem(cartItem.id);
                          } else {
                            await ShopDatabase.instance
                                .updateCartItem(cartItem);
                          }
                          Provider.of<CartNotifier>(context, listen: false)
                              .shoulRefresf();
                        },
                        icon: const Icon(Icons.remove_circle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),

            // Precio y botón de eliminar
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    // Eliminar el producto del carrito
                    await ShopDatabase.instance.deleteCartItem(cartItem.id);
                    Provider.of<CartNotifier>(context, listen: false)
                        .shoulRefresf();
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
                // Precio del producto
                Text(
                  '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double total;

  const _CartSummary({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
        color: Colors.white, // Color del fondo del contenedor
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black26, // Color de la sombra (ligeramente transparente)
            blurRadius: 8, // Desenfoque de la sombra
            spreadRadius:
                -4, // Hacer que la sombra se aplique solo cerca del borde
            offset: Offset(0, 2), // Desplazamiento de la sombra en x e y
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Funcionalidad de continuar compra
            },
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
            ),
            child:
                const Text("Continuar compra", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
