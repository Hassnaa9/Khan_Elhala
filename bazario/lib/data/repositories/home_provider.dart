// dart format width=80
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import '../../user_features/home/models/cart_item.dart';
import '../../user_features/home/models/category.dart';
import '../../user_features/home/models/product.dart';

// Placeholder model for a cart item

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
  final List<String> _wishlistFilters = [
    'All',
    'Jacket',
    'Shirt',
    'Pant',
    'T-Shirt'
  ];

  List<Product> _products = [];
  int _selectedFilterIndex = 0;
  int _selectedWishlistFilterIndex = 0;
  String _searchQuery = '';

  // Getters
  List<String> get flashSaleFilters => _flashSaleFilters;
  List<String> get wishlistFilters => _wishlistFilters;
  int get selectedFilterIndex => _selectedFilterIndex;
  int get selectedWishlistFilterIndex => _selectedWishlistFilterIndex;
  List<Category> get categories => _categories;
  List<Product> get products => _products;

  // Cart Management
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  List<Product> get filteredProducts {
    List<Product> tempProducts = List.from(_products);

    // Apply search filter first
    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Then apply category filter
    final selectedFilter = _flashSaleFilters[_selectedFilterIndex];
    if (selectedFilter == 'All') {
      return tempProducts;
    } else if (selectedFilter == 'Newest') {
      tempProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return tempProducts;
    } else if (selectedFilter == 'Popular') {
      return tempProducts; // Assuming popularity is a field or logic is applied elsewhere
    } else {
      return tempProducts
          .where((p) => p.flashSaleType == selectedFilter)
          .toList();
    }
  }

  List<Product> get wishlistProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  HomeProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('products').get();
      _products =
          snapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void selectFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  void updateWishlistFilters(int index) {
    _selectedWishlistFilterIndex = index;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    final productIndex =
    _products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _products[productIndex].isFavorite = !_products[productIndex].isFavorite;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Modified method to add a product to the cart with size and color
  void addToCart(Product product, String? selectedSize, String? selectedColor) {
    final existingItem = IterableExtension(_cartItems).firstWhereOrNull((item) =>
    item.product.id == product.id &&
        item.selectedSize == selectedSize &&
        item.selectedColor == selectedColor);

    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      _cartItems.add(CartItem(
        product: product,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ));
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