import 'package:flutter/material.dart';
import 'package:repair_service_ui/services/plan_service.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

class PlanTripListPage extends StatefulWidget {
  const PlanTripListPage({super.key});

  @override
  State<PlanTripListPage> createState() => _PlanTripListPageState();
}

class _PlanTripListPageState extends State<PlanTripListPage> {
  @override
  Widget build(BuildContext context) {
    final trips = PlanService.plannedTrips;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Voyages planifiés', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.white,
      body: trips.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Aucun voyage planifié pour le moment. Ajoute un voyage depuis la page de planification.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16, height: 1.4),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${trip.from} → ${trip.to}',
                              style: TextStyle(
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Constants.accentOrange),
                            onPressed: () {
                              setState(() {
                                PlanService.removeTrip(trip.id);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Date : ${trip.formattedDate}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Heure : ${trip.formattedTime}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: trips.length,
            ),
    );
  }
}
