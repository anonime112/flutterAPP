class PlannedTrip {
  final String id;
  final String from;
  final String to;
  final DateTime dateTime;

  PlannedTrip({
    required this.id,
    required this.from,
    required this.to,
    required this.dateTime,
  });

  String get formattedDate => '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';

  String get formattedTime => '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}
