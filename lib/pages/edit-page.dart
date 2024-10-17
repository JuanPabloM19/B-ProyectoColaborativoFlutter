import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/pages/reEdit-page.dart';
import 'package:flutter_application_1/services/database.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    products = await ShopDatabase.instance.getAllProducts();
    setState(
        () {}); // Llamar a setState para actualizar la UI después de obtener los productos.
  }

  Future<void> _deleteProduct(int id) async {
    await ShopDatabase.instance.deleteProduct(id);
    _fetchProducts(); // Actualiza la lista después de eliminar.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
      ),
      body: products.isEmpty // Verifica si la lista de productos está vacía.
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning,
                        size: 60, color: Colors.grey), // Icono de advertencia.
                    SizedBox(height: 16),
                    Text(
                      'No hay productos disponibles.',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Agrega nuevos productos para empezar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Precio: \$${product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navegar a la página de edición con el producto seleccionado
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPage(
                                  product:
                                      product), // Pasando el producto a editar
                            ),
                          ).then((_) {
                            // Volver a cargar la lista de productos al regresar
                            _fetchProducts();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteProduct(product.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
