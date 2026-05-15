import 'package:flutter/material.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/page_indicator.dart';

/// Onboarding étape 2 — choix du moyen de transport (harmonisé Abidjan Trajet).
class HomePageTwo extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback prevPage;

  const HomePageTwo({required this.nextPage, required this.prevPage, Key? key}) : super(key: key);

  @override
  State<HomePageTwo> createState() => _HomePageTwoState();
}

class _HomePageTwoState extends State<HomePageTwo> {
  static const Color _headerDark = Color(0xFF1A1C1E);

  static final List<Map<String, Object>> _modes = [
    {'name': 'VTC', 'icon': Icons.local_taxi_outlined, 'key': 'vtc', 'sub': 'Yango, Bolt…'},
    {'name': 'Bus / Gbaka', 'icon': Icons.directions_bus_outlined, 'key': 'bus', 'sub': 'Collectif'},
    {'name': 'Taxi communal', 'icon': Icons.airport_shuttle_outlined, 'key': 'taxi', 'sub': 'Woro-woro'},
    {'name': 'À pied', 'icon': Icons.directions_walk_outlined, 'key': 'walk', 'sub': 'Courte distance'},
    {'name': 'Covoiturage', 'icon': Icons.people_outline, 'key': 'carpool', 'sub': 'Partage'},
    {'name': 'Tout comparer', 'icon': Icons.auto_awesome_outlined, 'key': 'ia', 'sub': 'Suggestion IA'},
  ];

  String _active = 'vtc';

  void _select(String key) {
    setState(() => _active = key);
    Future.delayed(const Duration(milliseconds: 220), widget.nextPage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
          height: size.height * 0.34,
          width: double.infinity,
          color: _headerDark,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const PageIndicator(activePage: 2, darkMode: true),
                      const Spacer(),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Constants.accentLagoon.withValues(alpha: 0.2),
                        child: Icon(Icons.route_rounded, color: Constants.accentLagoon, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bonjour, voyageur',
                    style: TextStyle(color: Colors.grey[400], fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choisissez votre\nmoyen de transport',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L’IA comparera les options à Abidjan.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: Constants.accentLagoon.withValues(alpha: 0.15)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _modes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final item = _modes[index];
                  return _ModeCard(
                    label: item['name']! as String,
                    subtitle: item['sub']! as String,
                    icon: item['icon']! as IconData,
                    itemKey: item['key']! as String,
                    activeKey: _active,
                    onSelect: _select,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final String itemKey;
  final String activeKey;
  final void Function(String) onSelect;

  const _ModeCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.itemKey,
    required this.activeKey,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeKey == itemKey;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect(itemKey),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isActive ? Constants.accentOrange.withValues(alpha: 0.08) : Constants.greyColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive ? Constants.accentOrange : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: isActive ? Constants.accentOrange : Constants.primaryColor),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Constants.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
