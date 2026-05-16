import 'package:flutter/material.dart';
import 'package:repair_service_ui/services/carpool_service.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';
import 'package:repair_service_ui/widgets/carpool_match_section.dart';
import 'package:repair_service_ui/utils/constants.dart';

class CarpoolRequestPage extends StatefulWidget {
  const CarpoolRequestPage({super.key});

  @override
  State<CarpoolRequestPage> createState() => _CarpoolRequestPageState();
}

class _CarpoolRequestPageState extends State<CarpoolRequestPage> {
  final _fromController = TextEditingController(text: 'Zone 4, Abidjan');
  final _toController = TextEditingController(text: 'Plateau, Abidjan');
  bool _searched = false;

  void _searchTrips() {
    setState(() {
      _searched = true;
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    final matches = _searched ? CarpoolService.findMatchesForTrip(from, to) : [];

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Covoiturage', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Trouve un conducteur disponible',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Constants.primaryColor)),
            const SizedBox(height: 10),
            Text(
              'Renseigne ton point de départ et ta destination, puis consulte les offres de covoiturage disponibles.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
            ),
            const SizedBox(height: 22),
            _buildTextField(_fromController, 'Départ', Icons.trip_origin),
            const SizedBox(height: 12),
            _buildTextField(_toController, 'Destination', Icons.location_on),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _searchTrips,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.accentGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Chercher des covoitureurs', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            if (!_searched)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Constants.greyColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Remplis le formulaire pour voir des conducteurs disponibles sur ton trajet.',
                  style: TextStyle(color: Colors.grey[700], height: 1.5),
                ),
              ),
            if (_searched && matches.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Text(
                  'Aucun conducteur trouvé pour ce trajet. Essaie une autre combinaison de lieux.',
                  style: TextStyle(color: Colors.amber[900], height: 1.4),
                ),
              ),
            if (_searched && matches.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trajets disponibles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Constants.primaryColor)),
                  const SizedBox(height: 16),
                  CarpoolMatchSection(
                    from: from,
                    to: to,
                    onRequested: () {
                      setState(() {});
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Constants.primaryColor),
        filled: true,
        fillColor: Constants.greyColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }
}
