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

  List<ShippingAddress> _customAddresses = [];
  ShippingAddress? _selectedAddress;
  ShippingType? _selectedShippingType;

  // Getters
  List<ShippingAddress> get allAddresses => [..._defaultAddresses, ..._customAddresses];
  List<ShippingType> get shippingTypes => _defaultShippingTypes;
  ShippingAddress? get selectedAddress => _selectedAddress;
  ShippingType? get selectedShippingType => _selectedShippingType;
  bool get isInitialized => _isInitialized;
  List<ShippingAddress> get customAddresses => _customAddresses;

  ShippingProvider() {
    _initializeHive();
  }

  // Initialize Hive and load saved data
  Future<void> _initializeHive() async {
    try {
      // Open the box
      _shippingBox = await Hive.openBox(_shippingBoxName);

      // Load saved data
      await _loadSavedData();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing ShippingProvider: $e');
      // Set defaults if initialization fails
      _selectedAddress = _defaultAddresses.first;
      _selectedShippingType = _defaultShippingTypes.first;
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Load saved data from Hive
  Future<void> _loadSavedData() async {
    try {
      // Load selected address
      final savedAddress = _shippingBox.get(_selectedAddressKey);
      if (savedAddress is ShippingAddress) {
        _selectedAddress = savedAddress;
      } else {
        // Set default to first address if none selected
        _selectedAddress = _defaultAddresses.first;
      }

      // Load selected shipping type
      final savedShippingType = _shippingBox.get(_selectedShippingTypeKey);
      if (savedShippingType is ShippingType) {
        _selectedShippingType = savedShippingType;
      } else {
        // Set default to first shipping type if none selected
        _selectedShippingType = _defaultShippingTypes.first;
      }

      // Load custom addresses
      final savedCustomAddresses = _shippingBox.get(_customAddressesKey);
      if (savedCustomAddresses is List) {
        _customAddresses = savedCustomAddresses.cast<ShippingAddress>();
      }
    } catch (e) {
      debugPrint('Error loading saved data: $e');
      // Set defaults if loading fails
      _selectedAddress = _defaultAddresses.first;
      _selectedShippingType = _defaultShippingTypes.first;
      _customAddresses = [];
    }
  }

  // Save selected address
  Future<void> selectAddress(ShippingAddress address) async {
    _selectedAddress = address;
    try {
      await _shippingBox.put(_selectedAddressKey, address);
    } catch (e) {
      debugPrint('Error saving selected address: $e');
    }
    notifyListeners();
  }

  // Save selected shipping type
  Future<void> selectShippingType(ShippingType shippingType) async {
    _selectedShippingType = shippingType;
    try {
      await _shippingBox.put(_selectedShippingTypeKey, shippingType);
    } catch (e) {
      debugPrint('Error saving selected shipping type: $e');
    }
    notifyListeners();
  }

  // Add custom address
  Future<void> addCustomAddress(String name, String address) async {
    final newAddress = ShippingAddress(name: name, address: address);
    _customAddresses.add(newAddress);

    try {
      await _shippingBox.put(_customAddressesKey, _customAddresses);
    } catch (e) {
      debugPrint('Error saving custom addresses: $e');
      // Rollback on error
      _customAddresses.remove(newAddress);
    }

    notifyListeners();
  }

  // Remove custom address
  Future<void> removeCustomAddress(ShippingAddress address) async {
    final removedAddress = address;
    _customAddresses.remove(address);

    try {
      await _shippingBox.put(_customAddressesKey, _customAddresses);

      // If the removed address was selected, select the first default address
      if (_selectedAddress == removedAddress) {
        await selectAddress(_defaultAddresses.first);
      }
    } catch (e) {
      debugPrint('Error removing custom address: $e');
      // Rollback on error
      _customAddresses.add(removedAddress);
    }

    notifyListeners();
  }

  // Get index of selected address in all addresses list
  int getSelectedAddressIndex() {
    if (_selectedAddress == null) return 0;
    return allAddresses.indexWhere((address) =>
    address.name == _selectedAddress!.name &&
        address.address == _selectedAddress!.address);
  }

  // Get index of selected shipping type
  int getSelectedShippingTypeIndex() {
    if (_selectedShippingType == null) return 0;
    return _defaultShippingTypes.indexWhere((type) =>
    type.name == _selectedShippingType!.name);
  }

  // Firebase sync methods (for cloud backup)

  // Upload current selections to Firebase
  Future<void> syncToFirebase(String userId) async {
    try {
      // Example Firebase sync - uncomment and modify as needed
      /*
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({
            'shipping_preferences': {
              'selected_address': _selectedAddress?.toMap(),
              'selected_shipping_type': _selectedShippingType?.toMap(),
              'custom_addresses': _customAddresses.map((addr) => addr.toMap()).toList(),
              'last_updated': FieldValue.serverTimestamp(),
            }
          }, SetOptions(merge: true));
      */

      debugPrint('Shipping preferences synced to Firebase');
    } catch (e) {
      debugPrint('Error syncing to Firebase: $e');
    }
  }

  // Download selections from Firebase
  Future<void> syncFromFirebase(String userId) async {
    try {
      // Example Firebase sync - uncomment and modify as needed
      /*
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        final preferences = doc.data()!['shipping_preferences'] as Map<String, dynamic>?;

        if (preferences != null) {
          // Update selected address
          if (preferences['selected_address'] != null) {
            final addressData = preferences['selected_address'] as Map<String, dynamic>;
            await selectAddress(ShippingAddress.fromMap(addressData));
          }

          // Update selected shipping type
          if (preferences['selected_shipping_type'] != null) {
            final shippingTypeData = preferences['selected_shipping_type'] as Map<String, dynamic>;
            await selectShippingType(ShippingType.fromMap(shippingTypeData));
          }

          // Update custom addresses
          if (preferences['custom_addresses'] != null) {
            final customAddressList = preferences['custom_addresses'] as List;
            _customAddresses = customAddressList
                .map((addr) => ShippingAddress.fromMap(addr as Map<String, dynamic>))
                .toList();
            await _shippingBox.put(_customAddressesKey, _customAddresses);
          }

          notifyListeners();
        }
      }
      */

      debugPrint('Shipping preferences synced from Firebase');
    } catch (e) {
      debugPrint('Error syncing from Firebase: $e');
    }
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