import 'package:cloud_firestore/cloud_firestore.dart';

class Movement {
  final String id;
  final String itemId;
  final String itemName;
  final String itemType; // 'inventory_item' or 'partial_material'
  final String type; // 'checkout' or 'checkin'
  final double quantity;
  final String? unit;
  final String projectName;
  final String userId;
  final String userName;
  final String notes;
  final DateTime timestamp;

  Movement({
    required this.id,
    required this.itemId,
    required this.itemName,
    this.itemType = 'inventory_item',
    required this.type,
    required this.quantity,
    this.unit,
    this.projectName = '',
    required this.userId,
    required this.userName,
    this.notes = '',
    required this.timestamp,
  });

  factory Movement.fromMap(Map<String, dynamic> map, String docId) {
    return Movement(
      id: docId,
      itemId: map['itemId'] ?? '',
      itemName: map['itemName'] ?? '',
      itemType: map['itemType'] ?? 'inventory_item',
      type: map['type'] ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0,
      unit: map['unit'],
      projectName: map['projectName'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      notes: map['notes'] ?? '',
      timestamp:
          (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'itemType': itemType,
      'type': type,
      'quantity': quantity,
      'unit': unit,
      'projectName': projectName,
      'userId': userId,
      'userName': userName,
      'notes': notes,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  bool get isCheckout => type == 'checkout';
  bool get isCheckin => type == 'checkin';
}
