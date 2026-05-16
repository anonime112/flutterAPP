import 'package:flutter/material.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

/// Historique des trajets + statistiques de performance de l’IA.
class HistoryStatsPage extends StatelessWidget {
  const HistoryStatsPage({super.key});

  static const Color _headerDark = Color(0xFF1A1C1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppSession.isConducteur ? const AppDrawer() : null,
      body: Builder(
        builder: (scaffoldContext) {
          return Column(
            children: [
              _buildHeader(scaffoldContext),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    _buildAiSummaryCard(),
                    const SizedBox(height: 22),
                    Text(
                      'Indicateurs clés',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      children: [
                        _statCard('Temps gagné', '12 h 40', Icons.timer_outlined, Constants.accentLagoon),
                        _statCard('Trajets IA', '47', Icons.auto_awesome, Constants.accentOrange),
                        _statCard('Économies', '18 200 F', Icons.savings_outlined, Constants.accentGreen),
                        _statCard('Trafic évité', '23', Icons.traffic, Constants.primaryColor),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'Historique récent',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _historyTile(
                      'Marcory → Plateau',
                      'Yango • IA recommandé',
                      '24 min • 4 800 F',
                      'Il y a 2 h',
                      Constants.accentOrange,
                    ),
                    _historyTile(
                      'Cocody → Yopougon',
                      'Gbaka + marche',
                      '38 min • 350 F',
                      'Hier',
                      Constants.accentGreen,
                    ),
                    _historyTile(
                      'Riviera → CHU',
                      'Bolt VTC',
                      '18 min • 5 200 F',
                      'Hier',
                      Constants.accentLagoon,
                    ),
                    const SizedBox(height: 20),
                    _buildWeeklyChart(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext scaffoldContext) {
    final top = MediaQuery.paddingOf(scaffoldContext).top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, top + 16, 20, 24),
      decoration: const BoxDecoration(
        color: _headerDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (AppSession.isConducteur)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppSession.isConducteur ? 'Stats & historique conducteur' : 'Historique & Stats',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppSession.isConducteur
                          ? 'Suivi de vos trajets et performances à Abidjan'
                          : 'Performance de l’IA sur vos trajets à Abidjan',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Constants.primaryColor, Constants.accentLagoon],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Résumé IA — ce mois',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'L’IA a réduit votre temps de trajet de 18 % en moyenne en évitant les axes congestionnés (Pont HKB, Carrefour Marcory) et en privilégiant VTC ou Gbaka selon l’heure.',
            style: TextStyle(color: Colors.white, height: 1.45, fontSize: 14),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.82,
              minHeight: 8,
              backgroundColor: Colors.white24,
              color: Constants.accentOrange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Score de satisfaction itinéraires : 82 %',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.greyColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Constants.primaryColor)),
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyTile(String route, String mode, String meta, String when, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.route, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(route, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(mode, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(meta, style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(when, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final bars = [0.6, 0.85, 0.7, 0.9, 0.75, 0.95, 0.8];
    const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Constants.greyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temps gagné par jour (min)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Constants.primaryColor),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: bars[i],
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants.accentOrange,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(days[i], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
