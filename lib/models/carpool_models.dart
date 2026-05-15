/// Modèles covoiturage conducteur ↔ client.

class DriverRoute {
  final String id;
  final String driverName;
  final String from;
  final String to;
  final String departureLabel;
  final int seatsAvailable;
  final int seatsTotal;
  final double rating;
  final String vehicleInfo;

  const DriverRoute({
    required this.id,
    required this.driverName,
    required this.from,
    required this.to,
    required this.departureLabel,
    required this.seatsAvailable,
    required this.seatsTotal,
    this.rating = 4.8,
    this.vehicleInfo = 'Berline • Climatisée',
  });

  DriverRoute copyWith({int? seatsAvailable}) {
    return DriverRoute(
      id: id,
      driverName: driverName,
      from: from,
      to: to,
      departureLabel: departureLabel,
      seatsAvailable: seatsAvailable ?? this.seatsAvailable,
      seatsTotal: seatsTotal,
      rating: rating,
      vehicleInfo: vehicleInfo,
    );
  }
}

enum RequestStatus { pending, accepted, declined }

class PassengerTripRequest {
  final String id;
  final String passengerName;
  final String from;
  final String to;
  final String timeLabel;
  RequestStatus status;

  PassengerTripRequest({
    required this.id,
    required this.passengerName,
    required this.from,
    required this.to,
    required this.timeLabel,
    this.status = RequestStatus.pending,
  });

  PassengerTripRequest copyWith({RequestStatus? status}) {
    return PassengerTripRequest(
      id: id,
      passengerName: passengerName,
      from: from,
      to: to,
      timeLabel: timeLabel,
      status: status ?? this.status,
    );
  }
}
