import 'package:flutter/material.dart';
import 'package:repair_service_ui/models/plan_models.dart';
import 'package:repair_service_ui/pages/plan_result.dart';
import 'package:repair_service_ui/pages/plan_trip_list.dart';
import 'package:repair_service_ui/services/plan_service.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/utils/nav_helper.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

/// Écran planifier — style catalogue (en-tête sombre, recherche, promo, chips, grille).
class PlanTripPage extends StatefulWidget {
  @override
  State<PlanTripPage> createState() => _PlanTripPageState();
}

class _PlanTripPageState extends State<PlanTripPage> {
  static const Color _headerDark = Color(0xFF1A1C1E);
  static const Color _searchFill = Color(0xFF2A2D30);

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedCity = 'Abidjan, Cocody';
  int selectedCategory = 0;
  final TextEditingController _originController = TextEditingController(text: 'Zone 4, Abidjan');
  final TextEditingController _searchController = TextEditingController();
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 30);

  final List<String> _categories = ['Tous', 'VTC', 'Bus', 'Collectif'];

  final List<Map<String, String>> _savedPlaces = [
    {
      'name': 'Plateau — Centre',
      'detail': '12 min • VTC conseillé',
      'image': 'assets/images/0_250303064111.jpg',
      'price': '4 500 F',
    },
    {
      'name': 'Marcory Zone 4',
      'detail': 'Gbaka direct',
      'image': 'assets/images/Pont-bouygues.jpg',
      'price': '250 F',
    },
    {
      'name': 'Yopougon — Sogefiha',
      'detail': 'Trafic modéré',
      'image': 'assets/images/gettyimages-1321204684-2048x2048.jpg',
      'price': '6 800 F',
    },
    {
      'name': 'Riviera 2',
      'detail': 'Woro-woro + bus',
      'image': 'assets/images/gettyimages-1324743456-2048x2048.jpg',
      'price': '1 200 F',
    },
  ];

  @override
  void dispose() {
    _originController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildDarkHeader(context),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(20, 88, 20, 24),
                  children: [
                    const SizedBox(height: 8),
                    _buildPlanningForm(),
                    const SizedBox(height: 18),
                    _buildCategoryChips(),
                    const SizedBox(height: 22),
                    Text(
                      'Lieux fréquents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildPlacesGrid(),
                    const SizedBox(height: 24),
                    _buildDateRow(),
                    const SizedBox(height: 20),
                    _buildAnalyzeButton(),
                  ],
                ),
                Positioned(
                  top: -56,
                  left: 20,
                  right: 20,
                  child: _buildPromoBanner(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkHeader(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, top + 4, 20, 28),
      decoration: const BoxDecoration(
        color: _headerDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => popPage(context),
              ),
              const Expanded(
                child: Text(
                  'Planifier',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Localisation',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: _pickCity,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedCity,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[400]),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: _searchFill,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey[500], size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: 'Où allez-vous ?',
                                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Material(
                      color: Constants.accentOrange,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(16),
                        child: const SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(Icons.tune_rounded, color: Colors.white, size: 24),
                        ),
                      ),
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

  Widget _buildPromoBanner() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 112,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Constants.primaryColor,
                Constants.accentLagoon,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -10,
                child: Icon(
                  Icons.auto_awesome,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'IA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Meilleur itinéraire du moment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Comparez VTC, Gbaka et taxi en un tap',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final selected = selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? Constants.accentOrange : Constants.greyColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                _categories[i],
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlacesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: _savedPlaces.length,
      itemBuilder: (context, index) => _placeCard(_savedPlaces[index]),
    );
  }

  Widget _placeCard(Map<String, String> place) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: () {
          _searchController.text = place['name']!;
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      place['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Constants.greyColor,
                        child: Icon(Icons.map, color: Constants.accentLagoon, size: 40),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '4.8',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Constants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place['detail']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        place['price']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Constants.primaryColor,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Constants.accentOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.greyColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: Constants.accentOrange, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date du trajet', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[500]),
        ],
      ),
    );
  }

  Widget _buildPlanningForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Planifiez votre voyage',
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 14),
          _buildTextField(_originController, 'Point de départ', Icons.trip_origin),
          const SizedBox(height: 12),
          _buildTextField(_searchController, 'Destination', Icons.location_on),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDatePickerField()),
              const SizedBox(width: 12),
              Expanded(child: _buildTimePickerField()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _savePlannedTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.accentOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: _viewPlannedTrips,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Constants.primaryColor,
                    side: BorderSide(color: Constants.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Mes voyages'),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Constants.greyColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerField() {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Constants.greyColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedTime.format(context),
                style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _savePlannedTrip() {
    final from = _originController.text.trim();
    final to = _searchController.text.trim();
    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez renseigner le départ et la destination.')),
      );
      return;
    }

    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    PlanService.addTrip(PlannedTrip(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      from: from,
      to: to,
      dateTime: dateTime,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voyage planifié enregistré.')), 
    );
  }

  void _viewPlannedTrips() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlanTripListPage()));
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Constants.accentOrange),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PlanResultPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.accentOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: const Text(
          'Analyser l’itinéraire',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _pickCity() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Abidjan, Cocody'),
              onTap: () {
                setState(() => selectedCity = 'Abidjan, Cocody');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Abidjan, Plateau'),
              onTap: () {
                setState(() => selectedCity = 'Abidjan, Plateau');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Abidjan, Yopougon'),
              onTap: () {
                setState(() => selectedCity = 'Abidjan, Yopougon');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Constants.accentOrange),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }
}
