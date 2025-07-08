// lib/models/product.dart
import 'dart:convert';

class Product {
  final String id;
  String name;
  String description;
  double price;
  int quantity;
  String? imagePath; // ruta local de la imagen

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.imagePath,
  });

  // Para guardar en localstore
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'imagePath': imagePath,
      };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        price: (map['price'] as num).toDouble(),
        quantity: map['quantity'],
        imagePath: map['imagePath'],
      );

  String toJson() => json.encode(toMap());
  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));
}
