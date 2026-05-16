import 'package:flutter/material.dart';
import 'package:repair_service_ui/services/watsonx_service.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/utils/nav_helper.dart';
import 'package:repair_service_ui/widgets/abidjan_map_view.dart';
import 'package:repair_service_ui/widgets/carpool_match_section.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

class PlanResultPage extends StatefulWidget {
  final String from;
  final String to;
  final DateTime? dateTime;

  const PlanResultPage({
    super.key,
    this.from = 'Marcory — Zone 4',
    this.to = 'Plateau — Centre',
    this.dateTime,
  });

  @override
  _PlanResultPageState createState() => _PlanResultPageState();
}

class _PlanResultPageState extends State<PlanResultPage> {
  int selectedOption = 0;
  bool _watsonLoading = false;
  String _watsonText = '';
  String? _watsonError;
  bool _watsonRequested = false;
  int selectedCarouselIndex = 0;
  late PageController _pageController;

  final List<Map<String, String>> carouselItems = [
    {
      'image': 'assets/images/Pont-bouygues.jpg',
      'title': 'Trajet analysé',
      'subtitle': 'Réservez votre solution immédiatement.',
      'tag': 'RAPIDE',
    },
    {
      'image': 'assets/images/gettyimages-1321204684-2048x2048.jpg',
      'title': 'Options variées',
      'subtitle': 'VTC, bus, covoiturage selon vos préférences.',
      'tag': 'CHOIX',
    },
    {
      'image': 'assets/images/0_250303064111.jpg',
      'title': 'Tarifs clairs',
      'subtitle': 'Pas de surprise, prix affichés davance.',
      'tag': 'TRANSPARENT',
    },
  ];

  final List<Map<String, dynamic>> solutions = [
    {
      'id': 0,
      'title': 'Economy VTC',
      'icon': Icons.directions_car,
      'duration': '14 min',
      'distance': '6,8 km',
      'price': '13 500 FCFA',
      'details': 'VTC économique avec chauffeur professionnel',
      'color': Constants.accentOrange,
      'isRecommended': true,
      'info': 'Départ immédiat • 4 places'
    },
    {
      'id': 1,
      'title': 'Covoiturage',
      'icon': Icons.people,
      'duration': '18 min',
      'distance': '6,8 km',
      'price': '6 500 FCFA',
      'details': 'Partage de trajet avec d\'autres passagers',
      'color': Constants.accentGreen,
      'isRecommended': false,
      'info': '2 autres passagers • Économique'
    },
    {
      'id': 2,
      'title': 'Transports en commun',
      'icon': Icons.directions_bus,
      'duration': '34 min',
      'distance': '6,8 km',
      'price': '1 800 FCFA',
      'details': 'Bus + marche • 2 changements',
      'color': Color(0xFF1565C0),
      'isRecommended': false,
      'info': '2 arrêts • Très économique'
    },
    {
      'id': 3,
      'title': 'Taxi partage',
      'icon': Icons.local_taxi,
      'duration': '12 min',
      'distance': '6,8 km',
      'price': '8 500 FCFA',
      'details': 'Taxi avec d\'autres passagers connaissant la route',
      'color': Color(0xFFFFA726),
      'isRecommended': false,
      'info': '3 places disponibles • Rapide'
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
    _fetchWatsonRoute();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchWatsonRoute() async {
    setState(() {
      _watsonLoading = true;
      _watsonError = null;
      _watsonText = '';
    });

    final message = 'Propose un itinéraire optimal de ${widget.from} à ${widget.to}. '
        'Considère les options VTC, transports en commun et covoiturage. '
        'Indique les durées estimées, distances et tarifs approximatifs.';

    final result = await WatsonxService.fetchRecommendations(
      message,
      onChunk: (chunk) {
        if (!mounted) return;
        setState(() {
          _watsonText += chunk;
        });
      },
    );

    setState(() {
      _watsonLoading = false;
      _watsonRequested = true;
      if (result['error'] != null) {
        _watsonError = result['error'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => popPage(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Constants.backgroundDark, Constants.primaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, MediaQuery.paddingOf(context).top + kToolbarHeight + 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meilleures solutions',
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Votre trajet', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 0.3)),
                            const SizedBox(height: 12),
                            _trajRow('Départ', widget.from, Icons.trip_origin, Constants.accentGreen),
                            Padding(padding: const EdgeInsets.only(left: 19, top: 6, bottom: 6), child: Container(width: 2, height: 16, color: Colors.grey[300])),
                            _trajRow('Arrivée', widget.to, Icons.location_on_rounded, Constants.accentOrange),
                            const SizedBox(height: 12),
                            if (widget.dateTime != null)
                              Text(
                                'Le ${widget.dateTime!.day}/${widget.dateTime!.month}/${widget.dateTime!.year} à ${widget.dateTime!.hour.toString().padLeft(2, '0')}:${widget.dateTime!.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(color: Colors.grey[700], fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Map preview replaces the carousel here
                  mapPreviewCard(),
                  const SizedBox(height: 12),
                  Text('Options de transport', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Constants.primaryColor)),
                  const SizedBox(height: 16),
                  ...List.generate(solutions.length, (index) => _buildSolutionCard(solutions[index], index)),
                  const SizedBox(height: 28),
                  CarpoolMatchSection(from: widget.from, to: widget.to),
                  const SizedBox(height: 28),
                  _buildWatsonResponseSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trajRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _carouselCard(Map<String, String> item, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 16, top: isActive ? 0 : 12, bottom: isActive ? 0 : 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: const Offset(0, 6))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(item['image']!, fit: BoxFit.cover),
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.4), Colors.black.withValues(alpha: 0.15)]))),
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Constants.accentOrange.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(16)), child: Text(item['tag']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11))),
                  const SizedBox(height: 10),
                  Text(item['title']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item['subtitle']!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
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
          pickupSnippet: widget.from,
          dropoffLabel: 'Arrivée',
          dropoffSnippet: widget.to,
          mapPadding: const EdgeInsets.only(bottom: 40),
        ),
      ),
    );
  }

  Widget _buildSolutionCard(Map<String, dynamic> solution, int index) {
    bool isSelected = selectedOption == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? solution['color'].withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? solution['color'] : Colors.grey[200]!, width: isSelected ? 2 : 1),
        boxShadow: isSelected ? [BoxShadow(color: solution['color'].withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => selectedOption = index),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(color: solution['color'].withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: Icon(solution['icon'], color: solution['color'], size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(solution['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Constants.primaryColor)),
                              ),
                              if (solution['isRecommended'])
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: Constants.accentGreen.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                  child: Text('Top', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Constants.accentGreen)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(solution['info'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(solution['price'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: solution['color'])),
                        Text('${solution['duration']}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
                if (isSelected) ...[
                  const SizedBox(height: 12),
                  Divider(height: 1, color: Colors.grey[200]),
                  const SizedBox(height: 10),
                  Text(solution['details'], style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.4)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${solution['title']} réservé!'), backgroundColor: solution['color'])),
                          style: ElevatedButton.styleFrom(backgroundColor: solution['color'], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 11)),
                          child: const Text('Réserver', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.share, size: 18), onPressed: () {}, splashRadius: 20)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWatsonResponseSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.accentLagoon.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Constants.accentLagoon.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Constants.accentLagoon, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Recommandations Watsonx',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Constants.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_watsonLoading)
            Column(
              children: [
                LinearProgressIndicator(color: Constants.accentOrange),
                const SizedBox(height: 10),
                Text('Watsonx analyse votre trajet...', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
              ],
            ),
          if (_watsonError != null) Text(_watsonError!, style: TextStyle(color: Colors.red[700], fontSize: 12)),
          if (_watsonText.isNotEmpty) Text(_watsonText, style: TextStyle(color: Colors.grey[800], height: 1.5, fontSize: 13)),
        ],
      ),
    );
  }
}

