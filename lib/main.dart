import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:flutter_application_1/services/notifier.dart'; // Importa el Notifier
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
      debugShowCheckedModeBanner: false,
      title: 'Shop',
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6A9C89),          // ···
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      routes: Routes.routes, // Asegúrate de que HomePage está bien importado
    );
  }
}
