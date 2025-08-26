import 'package:hive_ce/hive.dart';

import 'product.dart'; // Make sure to import your Product model

part 'cart_item.g.dart';

@HiveType(typeId: 2) // Must have a unique typeId
class CartItem extends HiveObject {
  @HiveField(0)
  late Product product;
  @HiveField(1)
  late int quantity;
  @HiveField(2)
  final String? selectedSize;
  @HiveField(3)
  final String? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });
}