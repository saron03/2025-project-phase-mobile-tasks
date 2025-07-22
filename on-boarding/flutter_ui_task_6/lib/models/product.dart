import 'package:flutter/widgets.dart';

enum Category {
  MensShoes,
  WomensShoes,
  Accessories,
  Clothing,
  Bags,
  Shoes,
}

class Product {
  final int id;
  final String name;
  final Category category;
  final double price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
  });

  Image get image => Image.asset('assets/images/$id.jpg');
}
