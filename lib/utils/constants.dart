import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Koncept Inventory';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String inventoryItemsCollection = 'inventory_items';
  static const String partialMaterialsCollection = 'partial_materials';
  static const String movementsCollection = 'movements';
  static const String projectsCollection = 'projects';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleTechnician = 'technician';
  static const String roleViewer = 'viewer';

  // Item Categories
  static const List<String> categories = [
    'Cables',
    'Conectores',
    'Equipos',
    'Consumibles',
  ];

  // Subcategories by Category
  static const Map<String, List<String>> subcategories = {
    'Cables': [
      'HDMI',
      'XLR',
      'Cat6',
      'Cat5e',
      'Coaxial',
      'Speaker Wire',
      'USB',
      'Fiber Optic',
      'Power Cable',
      'Otro',
    ],
    'Conectores': [
      'XLR Male',
      'XLR Female',
      'RJ45',
      'BNC',
      'SMA',
      'Speakon',
      'Banana Plug',
      'Otro',
    ],
    'Equipos': [
      'Q-SYS',
      'Speakers',
      'Amplifiers',
      'Mixers',
      'Microphones',
      'Displays',
      'Projectors',
      'Cameras',
      'DSP',
      'Switches',
      'Otro',
    ],
    'Consumibles': [
      'Tape',
      'Zip Ties',
      'Labels',
      'Batteries',
      'Velcro',
      'Heat Shrink',
      'Otro',
    ],
  };

  // Units of Measurement
  static const List<String> units = [
    'unidades',
    'metros',
    'pies',
    'rollos',
    'cajas',
  ];

  // Locations
  static const List<String> locations = [
    'Almacen Principal',
    'Van/Truck',
    'En Sitio',
  ];

  // Movement Types
  static const String movementCheckout = 'checkout';
  static const String movementCheckin = 'checkin';

  // Item Conditions
  static const List<String> conditions = [
    'Nuevo',
    'Bueno',
    'Regular',
    'Dañado',
  ];
}

class AppColors {
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color accent = Color(0xFF26A69A);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color success = Color(0xFF388E3C);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}
