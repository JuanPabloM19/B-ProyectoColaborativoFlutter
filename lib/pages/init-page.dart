import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/options-page.dart';
import 'package:flutter_application_1/pages/cart-page.dart';
import 'package:flutter_application_1/pages/producs-page.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key, required this.title});

  final String title;

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Shop')),
        automaticallyImplyLeading: false,
      ),
      body: selectIndex == 0
          ? const ProductList()
          : selectIndex == 1
              ? const MyCart()
              : OptionsPage(),
              
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Gestión',
          ),
        ],
        currentIndex: selectIndex,
        onTap: (index) {
          setState(() {
            selectIndex = index;
          });
        },
      ),
    );
  }
}
