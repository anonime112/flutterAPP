import 'package:repair_service_ui/models/carpool_models.dart';

/// Données covoiturage partagées (démo) entre conducteurs et clients.
class CarpoolService {
  CarpoolService._();

  static final List<DriverRoute> _publishedRoutes = [
    const DriverRoute(
      id: 'd1',
      driverName: 'Kouadio M.',
      from: 'Marcory — Zone 4',
      to: 'Plateau — Centre',
      departureLabel: 'Aujourd’hui • 15:30',
      seatsAvailable: 2,
      seatsTotal: 3,
      rating: 4.9,
      vehicleInfo: 'Toyota Corolla • Blanc',
    ),
    const DriverRoute(
      id: 'd2',
      driverName: 'Aya K.',
      from: 'Cocody — 2 Plateaux',
      to: 'Yopougon — Sogefiha',
      departureLabel: 'Aujourd’hui • 17:00',
      seatsAvailable: 1,
      seatsTotal: 3,
      rating: 4.7,
      vehicleInfo: 'Suzuki Swift • Gris',
    ),
  ];

  static DriverRoute? _myActiveRoute;
  static final List<PassengerTripRequest> _passengerRequests = [
    PassengerTripRequest(
      id: 'r1',
      passengerName: 'Jean-Paul',
      from: 'Marcory Zone 4',
      to: 'Plateau',
      timeLabel: 'Il y a 12 min',
    ),
    PassengerTripRequest(
      id: 'r2',
      passengerName: 'Fatou',
      from: 'Riviera 2',
      to: 'Plateau — Cathédrale',
      timeLabel: 'Il y a 25 min',
    ),
  ];

  static DriverRoute? get myActiveRoute => _myActiveRoute;

  static List<DriverRoute> get allPublishedRoutes {
    final list = List<DriverRoute>.from(_publishedRoutes);
    if (_myActiveRoute != null && !list.any((r) => r.id == _myActiveRoute!.id)) {
      list.insert(0, _myActiveRoute!);
    }
    return list;
  }

  static List<PassengerTripRequest> get passengerRequests =>
      List.unmodifiable(_passengerRequests);

  static int get pendingRequestCount =>
      _passengerRequests.where((r) => r.status == RequestStatus.pending).length;

  /// Conducteur : publie un trajet A → B.
  static void publishMyRoute({
    required String from,
    required String to,
    required int seats,
    String? departureLabel,
  }) {
    _myActiveRoute = DriverRoute(
      id: 'my_${DateTime.now().millisecondsSinceEpoch}',
      driverName: 'Vous',
      from: from,
      to: to,
      departureLabel: departureLabel ?? 'Départ prévu bientôt',
      seatsAvailable: seats,
      seatsTotal: seats,
    );
    _publishedRoutes.removeWhere((r) => r.driverName == 'Vous');
    _publishedRoutes.insert(0, _myActiveRoute!);
  }

  static void cancelMyRoute() {
    if (_myActiveRoute != null) {
      _publishedRoutes.removeWhere((r) => r.id == _myActiveRoute!.id);
    }
    _myActiveRoute = null;
  }

  /// Clients : conducteurs sur un axe proche.
  static List<DriverRoute> findMatchesForTrip(String from, String to) {
    final f = from.toLowerCase();
    final t = to.toLowerCase();
    return allPublishedRoutes.where((route) {
      return _routeMatches(route.from, f) ||
          _routeMatches(route.to, t) ||
          (_routeMatches(route.from, f) && _routeMatches(route.to, t)) ||
          (f.contains('marcory') && route.from.toLowerCase().contains('marcory')) ||
          (t.contains('plateau') && route.to.toLowerCase().contains('plateau'));
    }).where((r) => r.seatsAvailable > 0).toList();
  }

  static bool _routeMatches(String routeLoc, String query) {
    final r = routeLoc.toLowerCase();
    for (final part in query.split(RegExp(r'[,\s—]+'))) {
      if (part.length > 3 && r.contains(part)) return true;
    }
    return r.contains(query) || query.contains(r.split('—').first.trim());
  }

  /// Client : demande une place chez un conducteur.
  static void requestSeatOnRoute({
    required DriverRoute route,
    required String passengerName,
    required String from,
    required String to,
  }) {
    final idx = _publishedRoutes.indexWhere((r) => r.id == route.id);
    if (idx >= 0 && _publishedRoutes[idx].seatsAvailable > 0) {
      _publishedRoutes[idx] = _publishedRoutes[idx].copyWith(
        seatsAvailable: _publishedRoutes[idx].seatsAvailable - 1,
      );
      if (_myActiveRoute?.id == route.id) {
        _myActiveRoute = _publishedRoutes[idx];
      }
    }

    _passengerRequests.insert(
      0,
      PassengerTripRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        passengerName: passengerName,
        from: from,
        to: to,
        timeLabel: 'À l’instant',
      ),
    );
  }

  static void acceptRequest(String requestId) {
    _updateRequestStatus(requestId, RequestStatus.accepted);
  }

  static void declineRequest(String requestId) {
    _updateRequestStatus(requestId, RequestStatus.declined);
  }

  static void _updateRequestStatus(String id, RequestStatus status) {
    final i = _passengerRequests.indexWhere((r) => r.id == id);
    if (i >= 0) {
      _passengerRequests[i] = _passengerRequests[i].copyWith(status: status);
    }
  }
}
