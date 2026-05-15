import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/pages/register_page.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/utils/helper.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

/// Onglet profil utilisateur.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Constants.greyColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 20, 20, 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Constants.backgroundDark, Constants.primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/dp.png',
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.person, size: 48, color: Constants.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  AppSession.displayName,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (AppSession.isConducteur ? Constants.accentOrange : Constants.accentLagoon)
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppSession.isConducteur ? 'Conducteur' : 'Client',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _menuTile(Icons.person_outline, 'Modifier le profil'),
                _menuTile(Icons.notifications_outlined, 'Notifications'),
                _menuTile(Icons.security, 'Sécurité'),
                _menuTile(Icons.help_outline, 'Aide & support'),
                if (AppSession.isConducteur) ...[
                  _menuTile(Icons.local_taxi, 'Espace conducteur (actif)'),
                  _menuTile(
                    Icons.swap_horiz,
                    'Revenir en mode client (démo)',
                    onTap: () {
                      AppSession.setFromRegistration(UserType.client);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                        (route) => false,
                      );
                    },
                  ),
                ] else
                  _menuTile(
                    Icons.swap_horiz,
                    'Passer en mode conducteur (démo)',
                    onTap: () {
                      AppSession.setFromRegistration(UserType.conducteur);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                        (route) => false,
                      );
                    },
                  ),
                const SizedBox(height: 16),
                _menuTile(
                  Icons.person_add_outlined,
                  'Créer un compte',
                  onTap: () => Helper.nextPage(context, const RegisterPage()),
                ),
                const SizedBox(height: 8),
                _menuTile(Icons.logout, 'Déconnexion', color: Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, {VoidCallback? onTap, Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Constants.primaryColor),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color ?? Constants.primaryColor)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
