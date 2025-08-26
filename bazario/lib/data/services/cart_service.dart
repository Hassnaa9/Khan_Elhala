// cart_service.dart
import 'package:hive_ce/hive.dart';

import '../../user_features/home/models/cart_item.dart';

class CartService {
  // Use a static final instance and a private constructor
  // to create a true singleton.
  static final CartService _instance = CartService._internal();

  // A private constructor to prevent direct instantiation.
  CartService._internal();

  // The public factory constructor returns the single instance.
  factory CartService() {
    return _instance;
  }

  // Use a simple getter to access the box.
  // This avoids trying to open the box in the constructor.
  Box<CartItem> get _cartBox => Hive.box<CartItem>('cartBox');

  // All your methods remain the same as they access the box via the getter.
  List<CartItem> getCartItems() {
    return _cartBox.values.toList();
  }

  Future<void> addItemToCart(CartItem newItem) async {
    final existingItem = _cartBox.get(newItem.product.id);
    if (existingItem != null) {
      existingItem.quantity = existingItem.quantity + newItem.quantity;
      await existingItem.save();
    } else {
      await _cartBox.put(newItem.product.id, newItem);
    }
  }

  Future<void> removeItemFromCart(String productId) async {
    await _cartBox.delete(productId);
  }

  Future<void> updateItemQuantity(String productId, int newQuantity) async {
    final item = _cartBox.get(productId);
    if (item != null) {
      if (newQuantity > 0) {
        item.quantity = newQuantity;
        await item.save();
      } else {
        await _cartBox.delete(productId);
      }
    }
  }

  Future<void> clearCart() async {
    await _cartBox.clear();
  }
}