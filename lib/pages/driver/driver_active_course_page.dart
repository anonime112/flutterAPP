import 'package:flutter/material.dart';
import 'package:repair_service_ui/models/carpool_models.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/utils/nav_helper.dart';
import 'package:repair_service_ui/widgets/abidjan_map_view.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

/// Écran « course acceptée » — même esprit visuel que [PlanTripPage] (en-tête sombre, bannière, contenu).
class DriverActiveCoursePage extends StatelessWidget {
  const DriverActiveCoursePage({
    super.key,
    required this.request,
    this.routeLabel,
  });

  final PassengerTripRequest request;
  /// Libellé du trajet publié (ex. horaire), optionnel.
  final String? routeLabel;

  static const Color _headerDark = Color(0xFF1A1C1E);
  static const Color _searchFill = Color(0xFF2A2D30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: Builder(
        builder: (scaffoldContext) {
          return Column(
            children: [
              _buildDarkHeader(context, scaffoldContext),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(20, 88, 20, 24),
                      children: [
                        const SizedBox(height: 8),
                        _routeSummaryCard(),
                        const SizedBox(height: 12),
                        mapPreviewCard(),
                        const SizedBox(height: 18),
                        _passengerCard(),
                        const SizedBox(height: 22),
                        Text(
                          'Étapes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _stepTile(Icons.phone_in_talk_outlined, 'Contacter le passager', 'Confirmation prise en charge'),
                        const SizedBox(height: 10),
                        _stepTile(Icons.navigation_outlined, 'Démarrer la navigation', 'Itinéraire vers le point de prise en charge'),
                        const SizedBox(height: 10),
                        _stepTile(Icons.stars_outlined, 'Terminer la course', 'Demandez un avis sur l’app'),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              backgroundColor: Constants.accentGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.map_outlined),
                            label: const Text('Ouvrir la navigation', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => popPage(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Retour à l’accueil'),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: -56,
                      left: 20,
                      right: 20,
                      child: _buildPromoBanner(),
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

  Widget mapPreviewCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 200,
        child: AbidjanMapView(
          pickupLabel: 'Départ',
          pickupSnippet: request.from,
          dropoffLabel: 'Arrivée',
          dropoffSnippet: request.to,
          mapPadding: const EdgeInsets.only(bottom: 40),
        ),
      ),
    );
  }

  Widget _buildDarkHeader(BuildContext context, BuildContext scaffoldContext) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, top + 4, 20, 28),
      decoration: const BoxDecoration(
        color: _headerDark,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => popPage(context),
              ),
              const Expanded(
                child: Text(
                  'Course acceptée',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Passager',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  request.passengerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (routeLabel != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    routeLabel!,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
                  ),
                ],
                const SizedBox(height: 18),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _searchFill,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.grey[500], size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          request.timeLabel,
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Icon(Icons.check_circle, color: Constants.accentGreen, size: 22),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 112,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Constants.primaryColor, Constants.accentLagoon],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -16,
              bottom: -10,
              child: Icon(
                Icons.directions_car_filled,
                size: 96,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Constants.accentOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'EN COURS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Passager ajouté à votre trajet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Même parcours que votre publication — covoiturage',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Constants.greyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trajet demandé', style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.trip_origin, size: 20, color: Constants.accentGreen),
              const SizedBox(width: 10),
              Expanded(child: Text(request.from, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Constants.primaryColor))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Icon(Icons.arrow_downward, size: 18, color: Colors.grey[500]),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: 20, color: Constants.accentOrange),
              const SizedBox(width: 10),
              Expanded(child: Text(request.to, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Constants.primaryColor))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _passengerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Constants.accentLagoon.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Constants.accentLagoon.withValues(alpha: 0.15),
            child: Text(
              request.passengerName.isNotEmpty ? request.passengerName[0].toUpperCase() : '?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Constants.accentLagoon),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.passengerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Demande acceptée', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chat_bubble_outline, color: Constants.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _stepTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Constants.accentLagoon.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Constants.accentLagoon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Constants.primaryColor)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
