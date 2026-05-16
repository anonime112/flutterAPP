import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/pages/order_vtc.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

/// Onglet commandes / courses en cours.
class OrdersTabPage extends StatelessWidget {
  const OrdersTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppSession.isConducteur ? const AppDrawer() : null,
      body: Builder(
        builder: (scaffoldContext) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  AppSession.isConducteur ? 4 : 20,
                  MediaQuery.paddingOf(scaffoldContext).top + 16,
                  20,
                  24,
                ),
                color: const Color(0xFF1A1C1E),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (AppSession.isConducteur)
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppSession.isConducteur ? 'Trajets & courses' : 'Mes courses',
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                AppSession.isConducteur ? 'Demandes acceptées et historique' : 'VTC, collectif et réservations',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _orderCard(
                      context,
                      status: 'En cours',
                      route: 'Zone 4 → Plateau',
                      detail: 'Yango • Chauffeur à 4 min',
                      color: Constants.accentOrange,
                      icon: Icons.local_taxi,
                    ),
                    const SizedBox(height: 12),
                    _orderCard(
                      context,
                      status: 'Terminé',
                      route: 'Cocody → Treichville',
                      detail: 'Gbaka • Hier, 14:30',
                      color: Constants.accentGreen,
                      icon: Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          MainShell.of(context)?.pushOverlay(
                            OrderVtcPage(),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Nouvelle course'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.accentOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _orderCard(
    BuildContext context, {
    required String status,
    required String route,
    required String detail,
    required Color color,
    required IconData icon,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          MainShell.of(context)?.pushOverlay(OrderVtcPage());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    Text(route, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(detail, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
