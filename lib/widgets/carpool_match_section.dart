import 'package:flutter/material.dart';
import 'package:repair_service_ui/models/carpool_models.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/services/carpool_service.dart';
import 'package:repair_service_ui/utils/constants.dart';

/// Section « conducteur sur votre trajet » pour les options client (IA).
class CarpoolMatchSection extends StatelessWidget {
  const CarpoolMatchSection({
    super.key,
    required this.from,
    required this.to,
    this.onRequested,
  });

  final String from;
  final String to;
  final VoidCallback? onRequested;

  @override
  Widget build(BuildContext context) {
    final matches = CarpoolService.findMatchesForTrip(from, to);
    if (matches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.people_alt_rounded, color: Constants.accentGreen, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Covoiturage sur votre trajet',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'L’IA a repéré un conducteur qui passe par votre axe — vous pouvez demander une place.',
          style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.35),
        ),
        const SizedBox(height: 14),
        ...matches.map((route) => _DriverMatchCard(
              route: route,
              clientFrom: from,
              clientTo: to,
              onRequested: onRequested,
            )),
      ],
    );
  }
}

class _DriverMatchCard extends StatelessWidget {
  const _DriverMatchCard({
    required this.route,
    required this.clientFrom,
    required this.clientTo,
    this.onRequested,
  });

  final DriverRoute route;
  final String clientFrom;
  final String clientTo;
  final VoidCallback? onRequested;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.accentGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Constants.accentGreen.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Constants.accentGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text('IA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Conducteur disponible',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Constants.accentGreen,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  Text(
                    route.rating.toStringAsFixed(1),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Constants.primaryColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(route.driverName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(route.vehicleInfo, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 10),
          _routeLine(Icons.trip_origin, route.from, Constants.accentGreen),
          const SizedBox(height: 4),
          _routeLine(Icons.location_on, route.to, Constants.accentOrange),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(Icons.event_seat, '${route.seatsAvailable} place(s)'),
              const SizedBox(width: 8),
              _infoChip(Icons.schedule, route.departureLabel),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Prix indicatif partagé : ~1 500 – 2 500 FCFA / pers.',
            style: TextStyle(fontSize: 12, color: Constants.primaryColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: route.seatsAvailable > 0
                  ? () {
                      CarpoolService.requestSeatOnRoute(
                        route: route,
                        passengerName: AppSession.displayName,
                        from: clientFrom,
                        to: clientTo,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Demande envoyée à ${route.driverName}'),
                          backgroundColor: Constants.accentGreen,
                        ),
                      );
                      onRequested?.call();
                    }
                  : null,
              icon: const Icon(Icons.hail, size: 20),
              label: Text(
                route.seatsAvailable > 0 ? 'Demander une place' : 'Complet',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.accentGreen,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeLine(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Constants.primaryColor))),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Constants.primaryColor),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Constants.primaryColor)),
        ],
      ),
    );
  }
}
