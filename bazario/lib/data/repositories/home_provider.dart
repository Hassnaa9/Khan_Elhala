// dart format width=80
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../user_features/home/models/category.dart';
import '../../user_features/home/models/product.dart';

// Placeholder model for a cart item
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class HomeProvider with ChangeNotifier {
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

  List<Product> _products = [];
  int _selectedFilterIndex = 0;

  // Getters
  List<String> get flashSaleFilters => _flashSaleFilters;
  int get selectedFilterIndex => _selectedFilterIndex;
  List<Category> get categories => _categories;
  List<Product> get products => _products;

  // Cart Management
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  // New Getter: Returns filtered products based on selected filter
  List<Product> get filteredProducts {
    final selectedFilter = _flashSaleFilters[_selectedFilterIndex];
    if (selectedFilter == 'All') {
      return _products;
    } else if (selectedFilter == 'Newest') {
      // Assuming you have a 'createdAt' field in your product model
      // to sort by newest first.
      final sortedProducts = List<Product>.from(_products);
      sortedProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return sortedProducts;
    } else if (selectedFilter == 'Popular') {
      // Placeholder for popularity filtering logic
      return _products;
    } else {
      return _products.where((p) => p.flashSaleType == selectedFilter).toList();
    }
  }

  HomeProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('products').get();
      _products = snapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

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

  void addToCart(Product product) {
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