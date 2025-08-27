// shipping_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../../user_features/checkout&payment/models/shipping_model.dart';

class ShippingProvider extends ChangeNotifier {
  static const String _shippingBoxName = 'shipping_data';
  static const String _selectedAddressKey = 'selected_address';
  static const String _selectedShippingTypeKey = 'selected_shipping_type';
  static const String _customAddressesKey = 'custom_addresses';

  late Box _shippingBox;
  bool _isInitialized = false;

  // Default addresses
  final List<ShippingAddress> _defaultAddresses = [
    ShippingAddress(name: 'Home', address: '1901 Thornridge Cir. Shiloh, Hawaii 81063'),
    ShippingAddress(name: 'Office', address: '4517 Washington Ave. Manchester, Kentucky 39495'),
    ShippingAddress(name: 'Parent\'s House', address: '8502 Preston Rd. Inglewood, Maine 98380'),
    ShippingAddress(name: 'Friend\'s House', address: '2464 Royal Ln. Mesa, New Jersey 45463'),
  ];

  // Default shipping types
  final List<ShippingType> _defaultShippingTypes = [
    ShippingType.withIcon(
      name: 'Economy',
      icon: Icons.local_shipping_outlined,
      date: '25 August 2023',
    ),
    ShippingType.withIcon(
      name: 'Regular',
      icon: Icons.local_shipping_outlined,
      date: '24 August 2023',
    ),
    ShippingType.withIcon(
      name: 'Cargo',
      icon: Icons.local_shipping_outlined,
      date: '22 August 2023',
    ),
  ];

  // Currently selected address and shipping type
  late ShippingAddress _selectedAddress;
  late ShippingType _selectedShippingType;

  // A list to hold custom addresses added by the user
  List<ShippingAddress> _customAddresses = [];

  // Getters
  List<ShippingAddress> get defaultAddresses => _defaultAddresses;
  List<ShippingType> get shippingTypes => _defaultShippingTypes;
  ShippingAddress? get selectedAddress => _selectedAddress;
  ShippingType? get selectedShippingType => _selectedShippingType;
  List<ShippingAddress> get customAddresses => _customAddresses;

  List<ShippingAddress> get allAddresses => [
    ..._defaultAddresses,
    ..._customAddresses,
  ];

  int getSelectedAddressIndex() {
    return allAddresses.indexOf(_selectedAddress);
  }

  int getSelectedShippingTypeIndex() {
    return shippingTypes.indexOf(_selectedShippingType);
  }

  ShippingProvider() {
    _initializeHive();
  }

  // Hive initialization
  Future<void> _initializeHive() async {
    if (_isInitialized) return;

    try {
      _shippingBox = await Hive.openBox(_shippingBoxName);

      // Load selected address from Hive or use default
      final savedAddress = _shippingBox.get(_selectedAddressKey);
      if (savedAddress != null) {
        _selectedAddress = savedAddress;
      } else {
        _selectedAddress = _defaultAddresses.first;
      }

      // Load selected shipping type from Hive or use default
      final savedShippingType = _shippingBox.get(_selectedShippingTypeKey);
      if (savedShippingType != null) {
        _selectedShippingType = savedShippingType;
      } else {
        _selectedShippingType = _defaultShippingTypes.first;
      }

      // Load custom addresses from Hive or use default
      final savedCustomAddresses = _shippingBox.get(_customAddressesKey);
      if (savedCustomAddresses != null) {
        _customAddresses = List.from(savedCustomAddresses);
      } else {
        _customAddresses = [];
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      // Fallback to defaults if Hive fails
      _selectedAddress = _defaultAddresses.first;
      _selectedShippingType = _defaultShippingTypes.first;
      _customAddresses = [];
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Select a new shipping address
  Future<void> selectAddress(ShippingAddress address) async {
    _selectedAddress = address;
    await _shippingBox.put(_selectedAddressKey, address);
    notifyListeners();
  }

  // Add a new custom address and save to Hive
  Future<void> addCustomAddress(ShippingAddress address) async {
    if (!_customAddresses.contains(address)) {
      _customAddresses.add(address);
      await _shippingBox.put(_customAddressesKey, _customAddresses);
      notifyListeners();
    }
  }

  // Select a new shipping type
  Future<void> selectShippingType(ShippingType type) async {
    _selectedShippingType = type;
    await _shippingBox.put(_selectedShippingTypeKey, type);
    notifyListeners();
  }


  // Clear all data (useful for logout)
  Future<void> clearAllData() async {
    try {
      await _shippingBox.clear();
      _selectedAddress = _defaultAddresses.first;
      _selectedShippingType = _defaultShippingTypes.first;
      _customAddresses.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing shipping data: $e');
    }
  }

  @override
  void dispose() {
    _shippingBox.close();
    super.dispose();
  }
}
