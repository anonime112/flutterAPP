import 'package:flutter/material.dart';
import 'package:repair_service_ui/widgets/abidjan_map_view.dart';
import 'package:repair_service_ui/config/maps_config.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/services/watsonx_service.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

class OptionDetailMap extends StatefulWidget {
  final String optionTitle;

  const OptionDetailMap({super.key, required this.optionTitle});

  @override
  State<OptionDetailMap> createState() => _OptionDetailMapState();
}

class _OptionDetailMapState extends State<OptionDetailMap> {
  bool? _useOsm;

  @override
  void initState() {
    super.initState();
    // Default to the global preference (allows running without Google API key).
    _useOsm = kMapsPreferOpenStreetMap;
    _watsonResults = [];
    _loadingWatson = false;
  }

  List<Map<String, dynamic>> _watsonResults = [];
  bool _loadingWatson = false;

  Future<void> _fetchWatson() async {
    setState(() => _loadingWatson = true);
    final res = await WatsonxService.fetchRouteSuggestions('Votre position', 'Destination');
    setState(() {
      _watsonResults = res;
      _loadingWatson = false;
    });
  }

  Future<void> _askMapType() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Type d’affichage'),
          content: const Text('Quel mode de carte souhaitez-vous utiliser ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Google Maps'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OpenStreetMap'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() => _useOsm = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(widget.optionTitle, style: TextStyle(color: Constants.primaryColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Constants.primaryColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: _useOsm == null
                  ? Container(
                      color: Constants.greyColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Choisissez votre type d’affichage pour la carte.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _askMapType,
                                style: ElevatedButton.styleFrom(backgroundColor: Constants.accentOrange),
                                child: const Text('Sélectionner le mode de carte'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : AbidjanMapView(
                      pickupLabel: 'Départ',
                      pickupSnippet: 'Votre position',
                      dropoffLabel: 'Arrivée',
                      dropoffSnippet: 'Destination',
                      mapPadding: const EdgeInsets.only(bottom: 120),
                      preferOpenStreetMap: _useOsm,
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Instructions IA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Constants.primaryColor)),
                const SizedBox(height: 8),
                Text(
                  _sampleInstructions(),
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                if (_loadingWatson) Center(child: CircularProgressIndicator()),
                if (!_loadingWatson && _watsonResults.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Résultats Watsonx', style: TextStyle(fontWeight: FontWeight.bold, color: Constants.primaryColor)),
                  const SizedBox(height: 8),
                  ..._watsonResults.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Constants.greyColor, borderRadius: BorderRadius.circular(10)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(s['title'] ?? s['mode'] ?? 'Option', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${s['duration'] ?? s['eta'] ?? ''} • ${s['distance'] ?? ''}', style: TextStyle(color: Colors.grey[700])),
                          ]),
                        ),
                      ))
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Retour'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Instructions IA activées pour ${widget.optionTitle}')),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Constants.accentOrange),
                        child: const Text('Suivre les instructions'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _fetchWatson,
                        style: ElevatedButton.styleFrom(backgroundColor: Constants.accentLagoon),
                        child: const Text('Voir suggestions Watsonx'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _askMapType,
                      style: ElevatedButton.styleFrom(backgroundColor: Constants.accentLagoon),
                      child: const Text('Changer le type de carte'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _sampleInstructions() {
    return 'Pour ${widget.optionTitle} :\n• Validez votre position de départ.\n• Activez le suivi GPS.\n• Suivez l’itinéraire affiché sur la carte.\n• Prévenez le passager via l’application lorsque vous êtes proche.';
  }
}
