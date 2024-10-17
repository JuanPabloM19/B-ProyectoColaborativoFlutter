import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPage extends StatefulWidget {
  final Product product;

  const EditPage({super.key, required this.product});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  File? _image; // Para almacenar la imagen seleccionada
  final ImagePicker _picker =
      ImagePicker(); // Inicializar el selector de imágenes

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Guardar la nueva imagen
      });
    }
  }

  void _updateProduct() async {
    final updatedProduct = Product(
      id: widget.product.id,
      name: _nameController.text,
      description: _descriptionController.text,
      price: int.parse(_priceController.text),
      imagePath: _image?.path ??
          widget.product.imagePath, // Usar la nueva imagen si existe
    );

    await ShopDatabase.instance.updateProduct(updatedProduct);
    Navigator.pop(context); // Regresar a la lista de productos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image!) // Mostrar la nueva imagen seleccionada
                      : (widget.product.imagePath.isNotEmpty
                          ? FileImage(File(widget.product.imagePath))
                          : null), // Mostrar la imagen del producto si existe
                  child: _image == null && widget.product.imagePath.isEmpty
                      ? const Icon(Icons.image, size: 60, color: Colors.grey)
                      : null, // Mostrar icono si no hay imagen
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: _selectImage,
                    child: const Icon(Icons.camera_alt, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduct,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}