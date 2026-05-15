import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/register_page.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/pages/plan_trip.dart';
import 'package:repair_service_ui/pages/order_vtc.dart';
import 'package:repair_service_ui/pages/request_service_flow.dart';
import 'package:repair_service_ui/pages/watsonx_recommendations_page.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
            _drawerItem(context, Icons.home_outlined, 'Accueil', () {
              Navigator.pop(context);
              MainShell.of(context)?.switchTab(0);
            }),
            _drawerItem(context, Icons.map, 'Planifier', () {
              Navigator.pop(context);
              MainShell.of(context)?.pushOverlay(PlanTripPage());
            }),
            _drawerItem(context, Icons.insights, 'Historique & stats', () {
              Navigator.pop(context);
              MainShell.of(context)?.switchTab(1);
            }),
            _drawerItem(context, Icons.local_taxi, 'Commander', () {
              Navigator.pop(context);
              MainShell.of(context)?.pushOverlay(OrderVtcPage());
            }),
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
