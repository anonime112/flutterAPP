import 'package:flutter/material.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/utils/nav_helper.dart';
import 'package:repair_service_ui/widgets/abidjan_map_view.dart';
import 'package:repair_service_ui/widgets/carpool_match_section.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';
import 'package:repair_service_ui/services/watsonx_service.dart';
/// Page commande : carte plein écran puis écran « options » style dashboard teal.
class OrderVtcPage extends StatefulWidget {
  @override
  State<OrderVtcPage> createState() => _OrderVtcPageState();
}

class _OrderVtcPageState extends State<OrderVtcPage> {
  int currentStep = 0;
  String startLocation = 'Zone 4, Abidjan';
  String endLocation = 'Plateau, Abidjan';
  String selectedRideId = 'yango';
  bool _watsonLoading = false;
  String _watsonText = '';
  String? _watsonError;
  bool _watsonRequested = false;

  /// Points de prise proches (Gbaka, taxi communal…).
  final List<Map<String, Object>> _pickupSpots = [
    {
      'title': 'Gbaka — axe Marcory → Plateau',
      'addr': 'Bd VGE, arrêt face au Super U',
      'walk': '~2 min à pied',
      'color': Constants.accentLagoon,
    },
    {
      'title': 'Taxi communal',
      'addr': 'Carrefour Zone 4, file vers Cocody',
      'walk': '~4 min à pied',
      'color': Constants.accentOrange,
    },
    {
      'title': 'Woro-woro',
      'addr': 'Rue des Jardins, près du marché',
      'walk': '~3 min à pied',
      'color': Constants.primaryColor,
    },
  ];

  /// Tarifs indicatifs VTC à Abidjan (démo UI).
  final List<Map<String, Object>> _vtcPlatforms = [
    {
      'id': 'yango',
      'name': 'Yango',
      'range': '4 500 – 6 200 FCFA',
      'eta': 'Attente ~5–8 min',
      'note': 'Souvent le meilleur compromis prix / temps sur cet axe.',
      'icon': Icons.local_taxi,
      'accent': Constants.accentOrange,
      'best': true,
    },
    {
      'id': 'bolt',
      'name': 'Bolt',
      'range': '5 000 – 7 000 FCFA',
      'eta': 'Attente ~7–12 min',
      'note': 'Utile si peu de conducteurs Yango à proximité.',
      'icon': Icons.directions_car,
      'accent': Constants.accentLagoon,
      'best': false,
    },
    {
      'id': 'uber',
      'name': 'Uber',
      'range': '5 500 – 8 000 FCFA',
      'eta': 'Variable selon la demande',
      'note': 'Prix dynamiques ; à comparer avant de valider.',
      'icon': Icons.shutter_speed,
      'accent': Constants.primaryColor,
      'best': false,
    },
  ];

  final List<Map<String, Object>> _collectifOptions = [
    {
      'title': 'Gbaka (ligne directe)',
      'price': '150 – 250 FCFA',
      'detail': 'Le moins cher ; prévoir la marche jusqu’à l’arrêt ci-dessus.',
      'icon': Icons.directions_bus,
      'iconBg': Constants.accentGreen,
    },
    {
      'title': 'Taxi communal',
      'price': '300 – 500 FCFA / pers.',
      'detail': 'Attente au point indiqué ; durée selon remplissage du véhicule.',
      'icon': Icons.airport_shuttle,
      'iconBg': Constants.accentOrange,
    },
    {
      'title': 'Woro-woro',
      'price': '200 – 400 FCFA',
      'detail': 'Courts trajets ; idéal pour rejoindre un axe Gbaka ou VTC.',
      'icon': Icons.two_wheeler,
      'iconBg': Constants.primaryColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final onMap = currentStep == 0;
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: onMap,
      backgroundColor: onMap ? const Color(0xFF0A1620) : _headerDark,
      appBar: onMap
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => popPage(context),
              ),
              title: const Text(
                'Abidjan Trajet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )
          : null,
      body: currentStep == 0 ? _buildLocationStep() : _buildOptionsDashboard(context),
    );
  }

  Widget _buildLocationStep() {
    final mq = MediaQuery.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        AbidjanMapView(
          pickupSnippet: startLocation,
          dropoffSnippet: endLocation,
          mapPadding: EdgeInsets.only(
            top: mq.padding.top + kToolbarHeight,
            bottom: mq.padding.bottom + 220,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, mq.padding.bottom + 16),
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Votre trajet',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _mapSheetLocationRow(
                      label: 'Départ',
                      value: startLocation,
                      icon: Icons.trip_origin,
                      color: Constants.accentGreen,
                      onTap: () => _showLocationPicker('start'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 19, top: 6, bottom: 6),
                      child: Container(width: 2, height: 16, color: Colors.grey[300]),
                    ),
                    _mapSheetLocationRow(
                      label: 'Arrivée',
                      value: endLocation,
                      icon: Icons.location_on_rounded,
                      color: Constants.accentOrange,
                      onTap: () => _showLocationPicker('end'),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _mapSheetChip('~24 min'),
                        const SizedBox(width: 8),
                        _mapSheetChip('12,4 km'),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Constants.accentOrange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bolt, size: 14, color: Constants.accentOrange),
                              const SizedBox(width: 4),
                              Text(
                                'Trafic',
                                style: TextStyle(
                                  color: Constants.accentOrange,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _prepareWatsonRoute,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.accentOrange,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Voir les options',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mapSheetLocationRow({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Constants.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
          ],
        ),
      ),
    );
  }

  Widget _mapSheetChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Constants.greyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Constants.primaryColor,
        ),
      ),
    );
  }

  Widget _buildOptionsDashboard(BuildContext context) {
    return Column(
      children: [
        _buildOptionsDarkHeader(context),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                children: [
                  _aiRecommendationBlock(),
                  const SizedBox(height: 22),
                  CarpoolMatchSection(
                    from: startLocation,
                    to: endLocation,
                    onRequested: () => setState(() {}),
                  ),
                  const SizedBox(height: 22),
                  _sectionRow('Points de prise proches', null),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 132,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _pickupSpots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) => _pickupCard(_pickupSpots[i]),
                    ),
                  ),
                  const SizedBox(height: 26),
                  _sectionRow('Tarifs VTC (indicatifs)', null),
                  const SizedBox(height: 12),
                  ..._vtcPlatforms.map((p) => _vtcOptionTile(p)),
                  const SizedBox(height: 22),
                  _sectionRow('Collectif & Gbaka', null),
                  const SizedBox(height: 12),
                  ..._collectifOptions.map((c) => _collectifTile(c)),
                  const SizedBox(height: 22),
                  _buildWatsonResponseSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static const Color _headerDark = Color(0xFF1A1C1E);

  Widget _buildOptionsDarkHeader(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4, top + 4, 20, 24),
      color: _headerDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => setState(() => currentStep = 0),
              ),
              const Expanded(
                child: Text(
                  'Vos options',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _routeLocationRow(
                  label: 'Départ',
                  value: startLocation,
                  icon: Icons.trip_origin,
                  iconColor: Constants.accentGreen,
                  onTap: () => _showLocationPicker('start'),
                ),
                const SizedBox(height: 14),
                _routeConnector(),
                const SizedBox(height: 14),
                _routeLocationRow(
                  label: 'Arrivée',
                  value: endLocation,
                  icon: Icons.location_on_rounded,
                  iconColor: Constants.accentOrange,
                  onTap: () => _showLocationPicker('end'),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _routeStatChip(Icons.schedule, '~24 min'),
                    _routeStatChip(Icons.straighten, '12,4 km'),
                    _routeStatChip(Icons.auto_awesome, 'IA active', accent: Constants.accentLagoon),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeLocationRow({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF2A2D30),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _routeConnector() {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Row(
        children: [
          Container(
            width: 2,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeStatChip(IconData icon, String text, {Color? accent}) {
    final c = accent ?? Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _aiRecommendationBlock() {
    final best = _vtcPlatforms.firstWhere((e) => e['best'] == true, orElse: () => _vtcPlatforms.first);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.greyColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Constants.accentLagoon.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 20, color: Constants.accentLagoon),
              const SizedBox(width: 8),
              Text(
                'Meilleure option (IA)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Constants.primaryColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.grey[800], height: 1.45, fontSize: 14),
              children: [
                const TextSpan(text: 'Selon le trafic actuel vers '),
                TextSpan(text: endLocation, style: const TextStyle(fontWeight: FontWeight.w600)),
                const TextSpan(
                  text: ', nous recommandons un ',
                ),
                TextSpan(
                  text: 'VTC ${best['name']}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Constants.accentLagoon),
                ),
                const TextSpan(
                  text: ' pour gagner du temps tout en restant dans une fourchette de prix raisonnable. ',
                ),
                const TextSpan(
                  text: 'Si vous préférez le collectif, un Gbaka sur l’axe principal reste le moins cher : rapprochez-vous des points ci-dessous.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Fourchette ${best['name']} : ${best['range']} • ${best['eta']}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Constants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionRow(String title, VoidCallback? onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Constants.primaryColor,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'Voir tout',
              style: TextStyle(
                color: Constants.accentOrange,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _pickupCard(Map<String, Object> spot) {
    final color = spot['color']! as Color;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spot['title']! as String,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            spot['addr']! as String,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontSize: 12, height: 1.3),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.directions_walk, size: 14, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(width: 4),
              Text(
                spot['walk']! as String,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vtcOptionTile(Map<String, Object> p) {
    final id = p['id']! as String;
    final selected = selectedRideId == id;
    final accent = p['accent']! as Color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => setState(() => selectedRideId = id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: selected ? Constants.accentLagoon : Colors.grey.shade200, width: selected ? 2 : 1),
              color: selected ? Constants.accentLagoon.withValues(alpha: 0.08) : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(p['icon'] as IconData, color: accent, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                p['name']! as String,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              if (p['best'] == true) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Constants.accentGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Recommandé',
                                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p['note']! as String,
                            style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _miniLabel('Prix estimé', p['range']! as String),
                    const SizedBox(width: 16),
                    _miniLabel('Délai', p['eta']! as String),
                  ],
                ),
                if (selected) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${p['name']} — réservation (démo)'),
                            backgroundColor: Constants.accentGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.accentOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Continuer avec cette option', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniLabel(String k, String v) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _collectifTile(Map<String, Object> c) {
    final bg = c['iconBg']! as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: bg.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
            child: Icon(c['icon'] as IconData, color: bg, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['title']! as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(c['detail']! as String, style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.35)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(c['price']! as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text('collectif', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(String type) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(type == 'start' ? 'Lieu de départ' : 'Destination'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Domicile'),
              onTap: () {
                setState(() {
                  if (type == 'start') {
                    startLocation = 'Domicile, Cocody';
                  } else {
                    endLocation = 'Domicile, Cocody';
                  }
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('Travail'),
              onTap: () {
                setState(() {
                  if (type == 'start') {
                    startLocation = 'Plateau, tour C';
                  } else {
                    endLocation = 'Plateau, tour C';
                  }
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Zone 4, Marcory'),
              onTap: () {
                setState(() {
                  if (type == 'start') {
                    startLocation = 'Zone 4, Abidjan';
                  } else {
                    endLocation = 'Zone 4, Abidjan';
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _prepareWatsonRoute() {
    setState(() {
      currentStep = 1;
      _watsonRequested = true;
      _watsonLoading = true;
      _watsonText = '';
      _watsonError = null;
    });
    _fetchWatsonRoute();
  }

  Future<void> _fetchWatsonRoute() async {
    final prompt =
        'Je cherche le meilleur trajet d\'un passager à Abidjan de $startLocation à $endLocation. '
        'Propose un itinéraire VTC optimal et indique une alternative covoiturage ou transport collectif si cela est plus rapide ou moins cher. '
        'Donne une réponse claire et concise pour l\'utilisateur.';

    final result = await WatsonxService.fetchRecommendations(
      prompt,
      onChunk: (chunk) {
        if (!mounted) return;
        setState(() {
          _watsonText += chunk;
        });
      },
    );

    if (!mounted) return;
    if (result['success'] == true) {
      setState(() {
        _watsonLoading = false;
        if (_watsonText.isEmpty) {
          _watsonText = result['body']?.toString() ?? 'Watsonx a renvoyé une réponse vide.';
        }
      });
    } else {
      setState(() {
        _watsonLoading = false;
        _watsonError = result['error']?.toString() ?? 'Erreur Watsonx inconnue.';
        if (_watsonText.isEmpty) {
          _watsonText = result['body']?.toString() ?? '';
        }
      });
    }
  }

  Widget _buildWatsonResponseSection() {
    if (!_watsonRequested) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Constants.accentLagoon.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Constants.accentLagoon.withOpacity(0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Constants.accentLagoon),
                  const SizedBox(width: 10),
                  Text(
                    'Réponse Watsonx',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_watsonLoading)
                Column(
                  children: [
                    LinearProgressIndicator(color: Constants.accentOrange),
                    const SizedBox(height: 12),
                    Text(
                      'Watsonx recherche le meilleur trajet...',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              if (_watsonError != null)
                Text(
                  _watsonError!,
                  style: TextStyle(color: Colors.red[700], fontSize: 13),
                ),
              if (_watsonText.isNotEmpty) ...[
                Text(
                  _watsonText,
                  style: TextStyle(color: Colors.grey[800], height: 1.5),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
