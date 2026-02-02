import 'package:cloud_firestore/cloud_firestore.dart';

class PartialMaterial {
  final String id;
  final String name;
  final String description;
  final String category;
  final String subcategory;
  final String barcode;
  final double totalQuantity;
  final double availableQuantity;
  final String unit; // metros, unidades, pies, rollos, cajas
  final double minStock;
  final String location;
  final double? unitPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  PartialMaterial({
    required this.id,
    required this.name,
    this.description = '',
    required this.category,
    this.subcategory = '',
    this.barcode = '',
    required this.totalQuantity,
    required this.availableQuantity,
    required this.unit,
    this.minStock = 1.0,
    this.location = 'Almacen Principal',
    this.unitPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory PartialMaterial.fromMap(Map<String, dynamic> map, String docId) {
    return PartialMaterial(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      subcategory: map['subcategory'] ?? '',
      barcode: map['barcode'] ?? '',
      totalQuantity: (map['totalQuantity'] as num?)?.toDouble() ?? 0.0,
      availableQuantity:
          (map['availableQuantity'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit'] ?? 'unidades',
      minStock: (map['minStock'] as num?)?.toDouble() ?? 1.0,
      location: map['location'] ?? 'Almacen Principal',
      unitPrice: (map['unitPrice'] as num?)?.toDouble(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'subcategory': subcategory,
      'barcode': barcode,
      'totalQuantity': totalQuantity,
      'availableQuantity': availableQuantity,
      'unit': unit,
      'minStock': minStock,
      'location': location,
      'unitPrice': unitPrice,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
    };
  }

  PartialMaterial copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? subcategory,
    String? barcode,
    double? totalQuantity,
    double? availableQuantity,
    String? unit,
    double? minStock,
    String? location,
    double? unitPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return PartialMaterial(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      barcode: barcode ?? this.barcode,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      unit: unit ?? this.unit,
      minStock: minStock ?? this.minStock,
      location: location ?? this.location,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  bool get isLowStock => availableQuantity <= minStock;

  String get quantityDisplay =>
      '${availableQuantity.toStringAsFixed(availableQuantity.truncateToDouble() == availableQuantity ? 0 : 1)} $unit';
}
