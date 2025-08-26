// shipping_models.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

part 'shipping_model.g.dart'; // This will be generated

@HiveType(typeId: 0)
class ShippingAddress extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String address;

  ShippingAddress({required this.name, required this.address});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShippingAddress &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              address == other.address;

  @override
  int get hashCode => name.hashCode ^ address.hashCode;

  // For Firebase conversion (optional)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
    };
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
    );
  }
}

@HiveType(typeId: 1)
class ShippingType extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int iconCodePoint;

  @HiveField(2)
  final String date;

  ShippingType({
    required this.name,
    required this.iconCodePoint,
    required this.date,
  });

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  // Factory constructor for creating ShippingType with IconData
  factory ShippingType.withIcon({
    required String name,
    required IconData icon,
    required String date,
  }) {
    return ShippingType(
      name: name,
      iconCodePoint: icon.codePoint,
      date: date,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShippingType &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  // For Firebase conversion (optional)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconCodePoint': iconCodePoint,
      'date': date,
    };
  }

  factory ShippingType.fromMap(Map<String, dynamic> map) {
    return ShippingType(
      name: map['name'] ?? '',
      iconCodePoint: map['iconCodePoint'] ?? Icons.local_shipping_outlined.codePoint,
      date: map['date'] ?? '',
    );
  }
}