import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inventory_item.dart';
import '../models/partial_material.dart';
import '../models/movement.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Users ---

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .orderBy('displayName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update({'role': role});
  }

  // --- Inventory Items ---

  Stream<List<InventoryItem>> getInventoryItems() {
    return _firestore
        .collection(AppConstants.inventoryItemsCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryItem.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<InventoryItem>> getInventoryItemsByCategory(String category) {
    return _firestore
        .collection(AppConstants.inventoryItemsCollection)
        .where('category', isEqualTo: category)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryItem.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<InventoryItem?> getInventoryItemByBarcode(String barcode) async {
    final snapshot = await _firestore
        .collection(AppConstants.inventoryItemsCollection)
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return InventoryItem.fromMap(doc.data(), doc.id);
  }

  Future<String> addInventoryItem(InventoryItem item) async {
    final docRef = await _firestore
        .collection(AppConstants.inventoryItemsCollection)
        .add(item.toMap());
    return docRef.id;
  }

  Future<void> updateInventoryItem(InventoryItem item) async {
    await _firestore
        .collection(AppConstants.inventoryItemsCollection)
        .doc(item.id)
        .update(item.toMap());
  }

  Future<void> deleteInventoryItem(String id) async {
    await _firestore
        .collection(AppConstants.inventoryItemsCollection)
        .doc(id)
        .delete();
  }

  // --- Partial Materials ---

  Stream<List<PartialMaterial>> getPartialMaterials() {
    return _firestore
        .collection(AppConstants.partialMaterialsCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PartialMaterial.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<PartialMaterial>> getPartialMaterialsByCategory(
      String category) {
    return _firestore
        .collection(AppConstants.partialMaterialsCollection)
        .where('category', isEqualTo: category)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PartialMaterial.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<PartialMaterial?> getPartialMaterialByBarcode(String barcode) async {
    final snapshot = await _firestore
        .collection(AppConstants.partialMaterialsCollection)
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return PartialMaterial.fromMap(doc.data(), doc.id);
  }

  Future<String> addPartialMaterial(PartialMaterial material) async {
    final docRef = await _firestore
        .collection(AppConstants.partialMaterialsCollection)
        .add(material.toMap());
    return docRef.id;
  }

  Future<void> updatePartialMaterial(PartialMaterial material) async {
    await _firestore
        .collection(AppConstants.partialMaterialsCollection)
        .doc(material.id)
        .update(material.toMap());
  }

  Future<void> deletePartialMaterial(String id) async {
    await _firestore
        .collection(AppConstants.partialMaterialsCollection)
        .doc(id)
        .delete();
  }

  // --- Movements ---

  Stream<List<Movement>> getMovements({int limit = 50}) {
    return _firestore
        .collection(AppConstants.movementsCollection)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Movement.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<Movement>> getMovementsByItem(String itemId) {
    return _firestore
        .collection(AppConstants.movementsCollection)
        .where('itemId', isEqualTo: itemId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Movement.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addMovement(Movement movement) async {
    await _firestore
        .collection(AppConstants.movementsCollection)
        .add(movement.toMap());
  }

  // --- Low Stock Queries ---

  Stream<List<InventoryItem>> getLowStockItems() {
    return _firestore
        .collection(AppConstants.inventoryItemsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryItem.fromMap(doc.data(), doc.id))
            .where((item) => item.isLowStock)
            .toList());
  }

  Stream<List<PartialMaterial>> getLowStockMaterials() {
    return _firestore
        .collection(AppConstants.partialMaterialsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PartialMaterial.fromMap(doc.data(), doc.id))
            .where((m) => m.isLowStock)
            .toList());
  }
}
