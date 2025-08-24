import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final Timestamp createdAt; // Added this field
  final String category;
  final String flashSaleType; // Changed from bool to String
  late final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
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
      isFavorite: false, // The isFavorite field won't be in Firestore
    );
  }
}