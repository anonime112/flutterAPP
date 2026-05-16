import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/register_page.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/pages/plan_trip.dart';
import 'package:repair_service_ui/pages/plan_trip_list.dart';
import 'package:repair_service_ui/pages/carpool_request_page.dart';
import 'package:repair_service_ui/pages/order_vtc.dart';
import 'package:repair_service_ui/pages/request_service_flow.dart';
import 'package:repair_service_ui/pages/watsonx_recommendations_page.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigateToTab(BuildContext context, int index) {
    final shell = MainShell.of(context);
    Navigator.pop(context);
    if (shell != null) {
      shell.switchTab(index);
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _openOverlay(BuildContext context, Widget page) {
    final shell = MainShell.of(context);
    Navigator.pop(context);
    if (shell != null) {
      shell.pushOverlay(page);
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              color: Constants.primaryColor,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.route_rounded, size: 28, color: Constants.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppSession.displayName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(AppSession.isConducteur ? 'Conducteur' : 'Client', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(context, Icons.home_outlined, 'Accueil', () => _navigateToTab(context, 0)),
            _drawerItem(context, Icons.map, 'Planifier', () => _openOverlay(context, PlanTripPage())),
            _drawerItem(context, Icons.schedule, 'Mes voyages planifiés', () {
              Navigator.pop(context);
              final shell = MainShell.of(context);
              if (shell != null) {
                shell.pushOverlay(const PlanTripListPage());
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlanTripListPage()));
              }
            }),
            _drawerItem(context, Icons.group, 'Covoiturage', () {
              Navigator.pop(context);
              final shell = MainShell.of(context);
              if (shell != null) {
                shell.pushOverlay(const CarpoolRequestPage());
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CarpoolRequestPage()));
              }
            }),
            _drawerItem(context, Icons.person_outline, 'Profil', () => _navigateToTab(context, 3)),
            _drawerItem(context, Icons.insights, 'Historique & stats', () => _navigateToTab(context, 1)),
            _drawerItem(context, Icons.local_taxi, 'Commander', () => _openOverlay(context, OrderVtcPage())),
            _drawerItem(context, Icons.pages, 'Introduction', () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => RequestServiceFlow(initialPage: 1)));
            }),
            _drawerItem(context, Icons.auto_awesome, 'Recommandations Watsonx', () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WatsonxRecommendationsPage()),
              );
            }),
            const Spacer(),
            Divider(height: 1, color: Colors.grey[200]),
            ListTile(
              leading: Icon(Icons.logout, color: Constants.primaryColor),
              title: const Text('Déconnexion', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                // Reset session and go back to register/login
                AppSession.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon, color: Constants.primaryColor), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), onTap: onTap);
  }
}
