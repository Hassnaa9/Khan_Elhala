import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 3) // A unique ID for the Product class
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String flashSaleType;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final List<String> sizes;

  @HiveField(8)
  final List<String> colors;

  @HiveField(9)
  final DateTime createdAt; // Changed from Timestamp to DateTime

  // This field is for local UI state and will not be stored in Hive
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.description,
    required this.sizes,
    required this.colors,
    required this.createdAt,
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
      createdAt: (data['createdAt'] as Timestamp).toDate(), // Convert to DateTime
      sizes: List<String>.from(data['sizes'] ?? []),
      colors: List<String>.from(data['colors'] ?? []),
      description: data['description'] ?? '',
      isFavorite: false,
    );
  }
}