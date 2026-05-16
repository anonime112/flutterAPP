import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/pages/order_vtc.dart';
import 'package:repair_service_ui/pages/plan_trip.dart';
import 'package:repair_service_ui/pages/request_service_flow.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/input_widget.dart';

/// Contenu onglet Accueil (ex-app_home).
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedCarouselIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.86);

  final List<Map<String, String>> carouselItems = [
    {
      'image': 'assets/images/Pont-bouygues.jpg',
      'title': 'Pont Henri Konan Bédié',
      'subtitle': 'Raccourci Riviera — Marcory aux heures de pointe.',
      'tag': 'AXE CLÉ',
    },
    {
      'image': 'assets/images/gettyimages-1321204684-2048x2048.jpg',
      'title': 'Itinéraires IA',
      'subtitle': 'Comparez VTC, bus et collectif selon le trafic.',
      'tag': 'IA',
    },
    {
      'image': 'assets/images/0_250303064111.jpg',
      'title': 'Trafic en direct',
      'subtitle': 'Conseils Plateau, Cocody, Yopougon.',
      'tag': 'LIVE',
    },
  ];

  void _openOverlay(Widget page) {
    MainShell.of(context)?.pushOverlay(page);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Abidjan Trajet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Constants.accentGreen,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: MediaQuery.paddingOf(context).top + kToolbarHeight + 8,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Constants.accentGreen),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Abidjan, Côte d’Ivoire',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Icon(Icons.notifications_none, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Trouvez le meilleur trajet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Planifiez, comparez et partez sereinement.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => _openOverlay(PlanTripPage()),
                      child: AbsorbPointer(child: InputWidget(hintText: 'Où allez-vous ?', suffixIcon: Icons.search)),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: carouselItems.length,
                        onPageChanged: (i) => setState(() => selectedCarouselIndex = i),
                        itemBuilder: (context, index) {
                          final item = carouselItems[index];
                          return _carouselCard(item, index == selectedCarouselIndex);
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        carouselItems.length,
                        (index) => Container(
                          width: index == selectedCarouselIndex ? 20 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index == selectedCarouselIndex ? Constants.accentOrange : Colors.white30,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Actions rapides',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Constants.primaryColor,
                        ),
                      ),
                      Text(
                        'Voir tout',
                        style: TextStyle(color: Constants.accentOrange, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(
                          'Planifier',
                          Icons.map_outlined,
                          Constants.accentOrange,
                          onTap: () => _openOverlay(PlanTripPage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(
                          'Stats IA',
                          Icons.insights,
                          Constants.accentLagoon,
                          onTap: () => MainShell.of(context)?.switchTab(1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(
                          'Commander',
                          Icons.local_taxi,
                          const Color(0xFFFB8C00),
                          onTap: () => _openOverlay(OrderVtcPage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(
                          'Covoiturage',
                          Icons.people,
                          Constants.accentGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Promotions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Constants.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  _promoCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              color: Constants.primaryColor,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.route_rounded, size: 28, color: Constants.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Abidjan Trajet',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text('Mobilité & IA', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(Icons.home_outlined, 'Accueil', () {
              Navigator.pop(context);
              MainShell.of(context)?.switchTab(0);
            }),
            _drawerItem(Icons.map, 'Planifier', () {
              Navigator.pop(context);
              _openOverlay(PlanTripPage());
            }),
            _drawerItem(Icons.insights, 'Historique & stats', () {
              Navigator.pop(context);
              MainShell.of(context)?.switchTab(1);
            }),
            _drawerItem(Icons.local_taxi, 'Commander', () {
              Navigator.pop(context);
              _openOverlay(OrderVtcPage());
            }),
            _drawerItem(Icons.pages, 'Introduction', () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => RequestServiceFlow(initialPage: 1)),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Constants.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
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

  Widget _actionCard(String title, IconData icon, Color color, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 18),
              Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Constants.primaryColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _promoCard() {
    return Container(
      decoration: BoxDecoration(color: Constants.greyColor, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.asset('assets/images/gettyimages-1324743456-2048x2048.jpg', fit: BoxFit.cover, height: 160),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Offre mobilité', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                const SizedBox(height: 10),
                Text('Réductions trajets vers le Plateau — partenaires VTC Abidjan.', style: TextStyle(color: Colors.grey[700], height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
