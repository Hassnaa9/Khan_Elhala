import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final Timestamp createdAt; // Added this field
  final String category;
  final String flashSaleType; // Changed from bool to String
  bool isFavorite;
  final String description; // Added this field
  final List<String> sizes; // Added this field
  final List<String> colors; // Added this field

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.description,
    required this.sizes,
    required this.colors,
    required this.createdAt, // And this field in the constructor
    required this.flashSaleType,
    this.isFavorite = false,
  });

  // Factory constructor to create a Product from a Firestore document
  factory Product.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      flashSaleType: data['flashSaleType'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      sizes: List<String>.from(data['sizes'] ?? []), // Parse list of sizes
      colors: List<String>.from(data['colors'] ?? []),
      description: data['description'] ?? '',
      isFavorite: false, // The isFavorite field won't be in Firestore
    );
  }
}