import 'package:repair_service_ui/models/plan_models.dart';

/// Stockage en mémoire des voyages planifiés.
class PlanService {
  PlanService._();

  static final List<PlannedTrip> _plannedTrips = [];

  static List<PlannedTrip> get plannedTrips => List.unmodifiable(_plannedTrips);

  static void addTrip(PlannedTrip trip) {
    _plannedTrips.insert(0, trip);
  }

  static void removeTrip(String id) {
    _plannedTrips.removeWhere((trip) => trip.id == id);
  }
}
