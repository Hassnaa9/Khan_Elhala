// dart format width=80
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/image_strings.dart';

import '../../features/home/models/category.dart';
import '../../features/home/models/product.dart';

// Placeholder model for a cart item
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class HomeProvider with ChangeNotifier {
  // Existing data...
  final List<String> _flashSaleFilters = [
    'All',
    'Newest',
    'Popular',
    'Man',
    'Woman'
  ];
  final List<Category> _categories = [
    Category(name: 'T-Shirt', icon: ImagesUrl.tshirtIcon),
    Category(name: 'Pant', icon: ImagesUrl.pantsIcon),
    Category(name: 'Dress', icon: ImagesUrl.dressIcon),
    Category(name: 'Jacket', icon: ImagesUrl.jacketIcon),
  ];
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Black suit',
      imageUrl: ImagesUrl.prod1Img,
      price: 83.9,
      isFavorite: true,
    ),
    Product(
      id: '2',
      name: 'Beige suit',
      imageUrl: ImagesUrl.prod2Img,
      price: 83.9,
      isFavorite: false,
    ),
    Product(
      id: '3',
      name: 'Blue suit',
      imageUrl: ImagesUrl.prod3Img,
      price: 83.9,
      isFavorite: false,
    ),
    Product(
      id: '4',
      name: 'White sweater',
      imageUrl: ImagesUrl.prod4Img,
      price: 83.9,
      isFavorite: false,
    ),
    Product(
      id: '5',
      name: 'black suit',
      imageUrl: ImagesUrl.prod5Img,
      price: 83.9,
      isFavorite: false,
    ),
  ];

  // Cart Management
  final List<CartItem> _cartItems = [];

  // Getters
  List<String> get flashSaleFilters => _flashSaleFilters;
  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;
  List<Product> get products => _products;
  List<Category> get categories => _categories;
  List<CartItem> get cartItems => _cartItems;

  void selectFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    final productIndex =
    _products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _products[productIndex].isFavorite =
      !_products[productIndex].isFavorite;
      notifyListeners();
    }
  }

  // Method to add a product to the cart
  void addToCart(Product product) {
    // Check if the item is already in the cart
    final existingItem = _cartItems
        .firstWhereOrNull((item) => item.product.id == product.id);

    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }
}

// Helper extension to find the first element or return null
extension _FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}