import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add-page.dart';
import 'package:flutter_application_1/pages/cart-page.dart';
import 'package:flutter_application_1/pages/edit-page.dart';
import 'package:flutter_application_1/pages/home-page.dart';
import 'package:flutter_application_1/pages/init-page.dart';
import 'package:flutter_application_1/pages/options-page.dart';

class Routes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const HomePage(),
    '/add-page': (context) => const AddPage(),
    '/options-page': (context) => OptionsPage(),
    '/cart-page': (context) => const MyCart(),
    '/init-page': (context) => const InitPage(
          title: '',
        ),
    '/products-page': (context) => ProductListPage(),
  };
}
