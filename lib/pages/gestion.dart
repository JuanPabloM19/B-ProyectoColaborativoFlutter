import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'shop_database.dart'; // Asegúrate de tener la ruta correcta
import '../models/models.dart';

class GestionScreen extends StatefulWidget {
  const GestionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GestionScreenState createState() => _GestionScreenState();
}

class _GestionScreenState extends State<GestionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _pickImage() async {
    await requestPermission();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _addProduct() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final int price = int.tryParse(_priceController.text) ?? 0;

    if (name.isNotEmpty &&
        description.isNotEmpty &&
        price > 0 &&
        _imagePath != null) {
      final product = Product(
          name: name,
          description: description,
          price: price,
          imagePath: _imagePath!);
      await ShopDatabase.instance.insertProduct(
          product); // Asegúrate de que este método esté implementado
      // Limpiar los campos después de agregar
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _imagePath = null; // Resetear la imagen
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Producto agregado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Título',
                prefixIcon: Icon(Icons.shopping_cart_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio',
                prefixIcon: Icon(Icons.price_change),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 100,
                color: Colors.grey[300],
                child: _imagePath == null
                    ? const Center(child: Text('Seleccionar Imagen'))
                    : Image.file(File(_imagePath!), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Agregar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
