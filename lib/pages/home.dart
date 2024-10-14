import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/init.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí colocas la imagen
            Center(
              child: Image.asset(
                'assets/images/carrito.jpg', // Reemplaza con tu imagen
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
            // Botón de "Iniciar Sesión"
            ElevatedButton(
              onPressed: () {
                // Navegar a InitPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InitPage(
                            title: 'Carrito de Compras',
                          )), // Redirige a InitPage
                );
              },
              child: Text('Iniciar Sesión'),
            )
          ],
        ),
      ),
    );
  }
}
