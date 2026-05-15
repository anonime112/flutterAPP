import 'package:flutter/material.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/abidjan_map_view.dart';
import 'package:repair_service_ui/widgets/carpool_match_section.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

class PlanResultPage extends StatefulWidget {
  @override
  _PlanResultPageState createState() => _PlanResultPageState();
}

class _PlanResultPageState extends State<PlanResultPage> {
  int selectedOption = 0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Constants.primaryColor),
        title: Text(
          'Meilleures solutions',
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: MediaQuery.of(context).padding.top + 80.0,
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Résultats optimisés par IA',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Voici les meilleures options pour votre trajet à Abidjan.',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.0),
            mapPreviewCard(),
            SizedBox(height: 28.0),
            CarpoolMatchSection(
              from: 'Marcory — Zone 4',
              to: 'Plateau — Centre',
            ),
            SizedBox(height: 28.0),
            Text(
              'Options de transport',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
              ),
            ),
            SizedBox(height: 16.0),
            ...List.generate(
              solutions.length,
              (index) => _buildSolutionCard(solutions[index], index),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget mapPreviewCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: SizedBox(
        height: 200.0,
        child: AbidjanMapView(
          pickupLabel: 'Départ',
          pickupSnippet: 'Abidjan Centre',
          dropoffLabel: 'Arrivée',
          dropoffSnippet: 'Yopougon',
          mapPadding: const EdgeInsets.only(bottom: 40.0),
        ),
      ),
    );
  }

  Widget _buildSolutionCard(Map<String, dynamic> solution, int index) {
    bool isSelected = selectedOption == index;
    return Container(
      margin: EdgeInsets.only(bottom: 14.0),
      decoration: BoxDecoration(
        color: isSelected
            ? solution['color'].withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isSelected
              ? solution['color']
              : Colors.grey[200]!,
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: solution['color'].withOpacity(0.15),
                  blurRadius: 12.0,
                  offset: Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8.0,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            setState(() {
              selectedOption = index;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: solution['color'].withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Icon(
                        solution['icon'],
                        color: solution['color'],
                        size: 26.0,
                      ),
                    ),
                    SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                solution['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              if (solution['isRecommended']) ...[
                                SizedBox(width: 8.0),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 3.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Constants.accentGreen.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Text(
                                    'Recommandé',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.accentGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            solution['info'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          solution['price'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: solution['color'],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${solution['duration']} • ${solution['distance']}',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isSelected) ...[
                  SizedBox(height: 14.0),
                  Divider(height: 1.0, color: Colors.grey[200]),
                  SizedBox(height: 12.0),
                  Text(
                    solution['details'],
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13.0,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 14.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${solution['title']} réservé!'),
                                backgroundColor: solution['color'],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: solution['color'],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: Text(
                            'Réserver',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.share, size: 18.0),
                          onPressed: () {},
                          splashRadius: 20.0,
                        ),
                      ),
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
}
