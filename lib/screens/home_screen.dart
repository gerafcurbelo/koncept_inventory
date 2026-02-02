import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/inventory_item.dart';
import '../models/partial_material.dart';
import '../models/movement.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _dbService = DatabaseService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUserModel();
    if (mounted) setState(() => _currentUser = user);
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesion'),
        content: const Text('Estas seguro que deseas cerrar sesion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar Sesion'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_currentUser != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  _currentUser!.displayName,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Cerrar Sesion',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUser,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              _buildStatsSection(),
              const SizedBox(height: 20),
              _buildLowStockSection(),
              const SizedBox(height: 20),
              _buildRecentMovementsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary,
              child: Text(
                _currentUser?.displayName.isNotEmpty == true
                    ? _currentUser!.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido, ${_currentUser?.displayName ?? '...'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentUser?.role.toUpperCase() ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StreamBuilder<List<InventoryItem>>(
                stream: _dbService.getInventoryItems(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  return _buildStatCard(
                    'Equipos',
                    count.toString(),
                    Icons.devices,
                    AppColors.primary,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StreamBuilder<List<PartialMaterial>>(
                stream: _dbService.getPartialMaterials(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  return _buildStatCard(
                    'Materiales',
                    count.toString(),
                    Icons.cable,
                    AppColors.accent,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.warning_amber, color: AppColors.warning, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Stock Bajo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<InventoryItem>>(
          stream: _dbService.getLowStockItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = snapshot.data ?? [];

            return StreamBuilder<List<PartialMaterial>>(
              stream: _dbService.getLowStockMaterials(),
              builder: (context, matSnapshot) {
                final materials = matSnapshot.data ?? [];
                final totalLow = items.length + materials.length;

                if (totalLow == 0) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: AppColors.success),
                          SizedBox(width: 12),
                          Text('Todo el inventario tiene stock suficiente'),
                        ],
                      ),
                    ),
                  );
                }

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...items.map((item) => ListTile(
                            leading: Icon(Icons.inventory_2,
                                color: AppColors.error),
                            title: Text(item.name),
                            subtitle: Text(
                                'Cantidad: ${item.quantity} (min: ${item.minStock})'),
                            dense: true,
                          )),
                      ...materials.map((mat) => ListTile(
                            leading:
                                Icon(Icons.cable, color: AppColors.error),
                            title: Text(mat.name),
                            subtitle: Text(
                                'Disponible: ${mat.quantityDisplay} (min: ${mat.minStock.toStringAsFixed(0)} ${mat.unit})'),
                            dense: true,
                          )),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentMovementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ultimos Movimientos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<Movement>>(
          stream: _dbService.getMovements(limit: 5),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final movements = snapshot.data ?? [];

            if (movements.isEmpty) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: AppColors.textSecondary),
                      SizedBox(width: 12),
                      Text('No hay movimientos recientes'),
                    ],
                  ),
                ),
              );
            }

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movements.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final m = movements[index];
                  final isOut = m.isCheckout;
                  return ListTile(
                    leading: Icon(
                      isOut ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isOut ? AppColors.error : AppColors.success,
                    ),
                    title: Text(m.itemName),
                    subtitle: Text(
                      '${isOut ? "Salida" : "Entrada"} - ${m.userName}'
                      '${m.projectName.isNotEmpty ? " - ${m.projectName}" : ""}',
                    ),
                    trailing: Text(
                      _formatDate(m.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    dense: true,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return 'hace ${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return 'hace ${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return 'hace ${diff.inDays}d';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
