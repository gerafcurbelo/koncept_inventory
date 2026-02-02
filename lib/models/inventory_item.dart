import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String description;
  final String category;
  final String subcategory;
  final String barcode;
  final int quantity;
  final int minStock;
  final String location;
  final String condition;
  final String? imageUrl;
  final String? serialNumber;
  final double? unitPrice;
  final String? assignedProject;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  InventoryItem({
    required this.id,
    required this.name,
    this.description = '',
    required this.category,
    this.subcategory = '',
    this.barcode = '',
    required this.quantity,
    this.minStock = 1,
    this.location = 'Almacen Principal',
    this.condition = 'Bueno',
    this.imageUrl,
    this.serialNumber,
    this.unitPrice,
    this.assignedProject,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory InventoryItem.fromMap(Map<String, dynamic> map, String docId) {
    return InventoryItem(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      subcategory: map['subcategory'] ?? '',
      barcode: map['barcode'] ?? '',
      quantity: (map['quantity'] ?? 0).toInt(),
      minStock: (map['minStock'] ?? 1).toInt(),
      location: map['location'] ?? 'Almacen Principal',
      condition: map['condition'] ?? 'Bueno',
      imageUrl: map['imageUrl'],
      serialNumber: map['serialNumber'],
      unitPrice: (map['unitPrice'] as num?)?.toDouble(),
      assignedProject: map['assignedProject'],
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
      'quantity': quantity,
      'minStock': minStock,
      'location': location,
      'condition': condition,
      'imageUrl': imageUrl,
      'serialNumber': serialNumber,
      'unitPrice': unitPrice,
      'assignedProject': assignedProject,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
    };
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? subcategory,
    String? barcode,
    int? quantity,
    int? minStock,
    String? location,
    String? condition,
    String? imageUrl,
    String? serialNumber,
    double? unitPrice,
    String? assignedProject,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      barcode: barcode ?? this.barcode,
      quantity: quantity ?? this.quantity,
      minStock: minStock ?? this.minStock,
      location: location ?? this.location,
      condition: condition ?? this.condition,
      imageUrl: imageUrl ?? this.imageUrl,
      serialNumber: serialNumber ?? this.serialNumber,
      unitPrice: unitPrice ?? this.unitPrice,
      assignedProject: assignedProject ?? this.assignedProject,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  bool get isLowStock => quantity <= minStock;
}
