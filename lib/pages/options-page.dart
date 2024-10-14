import 'package:flutter/material.dart';

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-page');
              },
              child: Text('Agregar Artículo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la lista de productos donde puedes editar
                Navigator.pushNamed(context, '/products-page');
              },
              child: Text('Editar/Eliminar Artículo'),
            ),
          ],
        ),
      ),
    );
  }
}
