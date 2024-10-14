import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add-page.dart';
import 'package:flutter_application_1/pages/cart-page.dart';
import 'package:flutter_application_1/pages/edit-page.dart';
import 'package:flutter_application_1/pages/home-page.dart';
import 'package:flutter_application_1/pages/init-page.dart';
import 'package:flutter_application_1/pages/options-page.dart';

class Routes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => HomePage(),
    '/add-page': (context) => AddPage(),
    '/options-page': (context) => OptionsPage(),
    '/cart-page': (context) => MyCart(),
    '/init-page': (context) => InitPage(
          title: '',
        ),
    '/products-page': (context) => ProductListPage(),
  };
}
