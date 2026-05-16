import 'package:flutter/material.dart';
import 'package:repair_service_ui/models/carpool_models.dart';
import 'package:repair_service_ui/pages/driver/driver_active_course_page.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/services/carpool_service.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';
import 'package:repair_service_ui/widgets/input_widget.dart';

/// Accueil conducteur : publier un trajet A→B et gérer les demandes de covoiturage.
class DriverHomeTab extends StatefulWidget {
  const DriverHomeTab({super.key});

  @override
  State<DriverHomeTab> createState() => _DriverHomeTabState();
}

class _DriverHomeTabState extends State<DriverHomeTab> {
  static const Color _headerDark = Color(0xFF1A1C1E);

  final _fromController = TextEditingController(text: 'Marcory — Zone 4');
  final _toController = TextEditingController(text: 'Plateau — Centre');
  int _seats = 3;
  bool _showPublishForm = false;

  int _carouselIndex = 0;
  final PageController _carouselController = PageController(viewportFraction: 0.86);

  final List<Map<String, String>> _carouselItems = [
    {
      'image': 'assets/images/Pont-bouygues.jpg',
      'title': 'Axes à forte demande',
      'subtitle': 'Zone 4 — Plateau, Cocody — Riviera.',
      'tag': 'ABIDJAN',
    },
    {
      'image': 'assets/images/gettyimages-1321204684-2048x2048.jpg',
      'title': 'Remplissez votre véhicule',
      'subtitle': 'Publiez A→B et recevez des demandes en temps réel.',
      'tag': 'COVOITURAGE',
    },
    {
      'image': 'assets/images/0_250303064111.jpg',
      'title': 'Gagnez en visibilité',
      'subtitle': 'Les passagers voient votre trajet sur leur itinéraire.',
      'tag': 'PRO',
    },
  ];

  @override
  void dispose() {
    _carouselController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  String _formatNow() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }

  void _publishRoute() {
    CarpoolService.publishMyRoute(
      from: _fromController.text.trim(),
      to: _toController.text.trim(),
      seats: _seats,
      departureLabel: 'Aujourd’hui • ${_formatNow()}',
    );
    setState(() {
      _showPublishForm = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Trajet publié — les passagers peuvent vous rejoindre'),
        backgroundColor: Constants.accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = CarpoolService.myActiveRoute;
    final requests = CarpoolService.passengerRequests;
    final pending = CarpoolService.pendingRequestCount;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: Builder(
        builder: (scaffoldContext) {
          return RefreshIndicator(
            onRefresh: () async {
              _refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeroWithCarousel(scaffoldContext, pending),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (active != null) ...[
                          _activeRouteCard(active),
                          const SizedBox(height: 20),
                        ] else if (_showPublishForm) ...[
                          _publishFormCard(),
                          const SizedBox(height: 20),
                        ] else ...[
                          _publishCtaCard(),
                          const SizedBox(height: 20),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Demandes de trajet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Constants.primaryColor,
                              ),
                            ),
                            if (pending > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Constants.accentOrange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$pending nouvelle${pending > 1 ? 's' : ''}',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Passagers de l’app souhaitant rejoindre votre axe',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 14),
                        if (requests.isEmpty)
                          _emptyRequests()
                        else
                          ...requests.map(_requestCard),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroWithCarousel(BuildContext scaffoldContext, int pending) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_headerDark, Constants.primaryColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 16, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                ),
                Icon(Icons.location_on, color: Constants.accentGreen),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Abidjan, Côte d’Ivoire',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                Badge(
                  isLabelVisible: pending > 0,
                  label: Text('$pending'),
                  backgroundColor: Constants.accentOrange,
                  child: const Icon(Icons.notifications_none, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Constants.accentOrange.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.local_taxi, color: Constants.accentOrange, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Espace conducteur',
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.1),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppSession.displayName,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Publiez votre trajet (A → B) et acceptez les demandes de covoiturage.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.86), fontSize: 14, height: 1.45),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () => setState(() => _showPublishForm = true),
              child: AbsorbPointer(
                child: InputWidget(
                  hintText: 'Publier ou modifier un trajet…',
                  suffixIcon: Icons.edit_road,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _carouselController,
                itemCount: _carouselItems.length,
                onPageChanged: (i) => setState(() => _carouselIndex = i),
                itemBuilder: (context, index) {
                  final item = _carouselItems[index];
                  return _carouselCard(item, index == _carouselIndex);
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _carouselItems.length,
                (index) => Container(
                  width: index == _carouselIndex ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == _carouselIndex ? Constants.accentOrange : Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _carouselCard(Map<String, String> item, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 16, top: isActive ? 0 : 12, bottom: isActive ? 0 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(item['image']!, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.42), Colors.black.withValues(alpha: 0.12)],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Constants.accentOrange.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(item['tag']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 12),
                  Text(item['title']!, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(item['subtitle']!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _publishCtaCard() {
    return Material(
      color: Constants.accentLagoon.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => setState(() => _showPublishForm = true),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Constants.accentLagoon,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.add_road, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Publier mon trajet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Constants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'De A à B — places disponibles pour passagers',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Constants.accentLagoon),
            ],
          ),
        ),
      ),
    );
  }

  Widget _publishFormCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Constants.accentLagoon.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Nouveau trajet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Constants.primaryColor)),
          const SizedBox(height: 14),
          _locationField('Point A — Départ', _fromController, Icons.trip_origin, Constants.accentGreen),
          const SizedBox(height: 12),
          _locationField('Point B — Arrivée', _toController, Icons.location_on, Constants.accentOrange),
          const SizedBox(height: 14),
          Text('Places disponibles', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Row(
            children: [1, 2, 3, 4].map((n) {
              final sel = _seats == n;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: n < 4 ? 8 : 0),
                  child: ChoiceChip(
                    label: Text('$n'),
                    selected: sel,
                    onSelected: (_) => setState(() => _seats = n),
                    selectedColor: Constants.accentOrange.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sel ? Constants.accentOrange : Constants.primaryColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _showPublishForm = false),
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _publishRoute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.accentOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Publier', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationField(String label, TextEditingController c, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: color, size: 22),
            filled: true,
            fillColor: Constants.greyColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _activeRouteCard(DriverRoute route) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Constants.primaryColor, Constants.accentLagoon],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              const Text('Trajet en ligne', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  CarpoolService.cancelMyRoute();
                  _refresh();
                },
                child: const Text('Arrêter', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(route.from, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Icon(Icons.arrow_downward, color: Colors.white54, size: 18),
          ),
          Text(route.to, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              _whiteChip(Icons.event_seat, '${route.seatsAvailable}/${route.seatsTotal} places'),
              const SizedBox(width: 8),
              _whiteChip(Icons.schedule, route.departureLabel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _whiteChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _requestCard(PassengerTripRequest req) {
    final pending = req.status == RequestStatus.pending;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: pending ? Constants.accentOrange.withValues(alpha: 0.4) : Colors.grey.shade200,
          width: pending ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Constants.accentLagoon.withValues(alpha: 0.15),
                child: Text(
                  req.passengerName.isNotEmpty ? req.passengerName[0].toUpperCase() : '?',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Constants.accentLagoon),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(req.passengerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(req.timeLabel, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              _statusBadge(req.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.trip_origin, size: 16, color: Constants.accentGreen),
              const SizedBox(width: 6),
              Expanded(child: Text(req.from, style: TextStyle(fontSize: 13, color: Constants.primaryColor))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: 16, color: Constants.accentOrange),
              const SizedBox(width: 6),
              Expanded(child: Text(req.to, style: TextStyle(fontSize: 13, color: Constants.primaryColor))),
            ],
          ),
          if (pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      CarpoolService.declineRequest(req.id);
                      _refresh();
                    },
                    child: const Text('Refuser'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      CarpoolService.acceptRequest(req.id);
                      _refresh();
                      final route = CarpoolService.myActiveRoute;
                      MainShell.of(context)?.pushOverlay(
                        DriverActiveCoursePage(
                          request: req,
                          routeLabel: route?.departureLabel,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.accentGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accepter'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(RequestStatus status) {
    Color bg;
    String label;
    switch (status) {
      case RequestStatus.accepted:
        bg = Constants.accentGreen;
        label = 'Accepté';
        break;
      case RequestStatus.declined:
        bg = Colors.grey;
        label = 'Refusé';
        break;
      default:
        bg = Constants.accentOrange;
        label = 'En attente';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: bg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _emptyRequests() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Aucune demande pour le moment',
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Publiez un trajet pour recevoir des passagers',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
