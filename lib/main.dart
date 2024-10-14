import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home.dart'; // Importa tu archivo home.dart
import 'package:flutter_application_1/pages/notifier.dart'; // Importa el Notifier
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartNotifier(), // Proveedor para toda la app
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqlite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), // Asegúrate de que HomePage está bien importado
    );
  }
}
