import 'package:flutter/material.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/page_indicator.dart';

class HomePageThree extends StatefulWidget {
  final VoidCallback prevPage;
  final VoidCallback onGetStarted;

  const HomePageThree({required this.prevPage, required this.onGetStarted, Key? key}) : super(key: key);

  @override
  _HomePageThreeState createState() => _HomePageThreeState();
}

class _HomePageThreeState extends State<HomePageThree> {
  String active = 'vtc';

  void setActiveFunc(String key) {
    setState(() {
      active = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/0_250303064111.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.0),
          PageIndicator(activePage: 3, darkMode: true),
          SizedBox(height: 20.0),
          Text(
            'Votre assistant de trajet est prêt',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'L’IA vous propose les meilleurs moyens pour vos déplacements dans Abidjan.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15.0,
            ),
          ),
          SizedBox(height: 24.0),
          Expanded(
            child: Column(
              children: [
                featureTile('Planifier une course', 'Choisissez vos points A et B', Icons.calendar_today),
                SizedBox(height: 12.0),
                featureTile('Historique des courses', 'Retrouvez vos trajets antérieurs', Icons.history),
                SizedBox(height: 12.0),
                featureTile('Trouver un covoitureur', 'Partagez une course facilement', Icons.people),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Section sombre',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Visionnez le résumé du dernier trajet, consultez les promos et suivez votre route.',
                  style: TextStyle(color: Colors.white70, fontSize: 14.0, height: 1.5),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: widget.onGetStarted,
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(vertical: 18.0),
            ),
            child: Text(
              'Accéder à l’accueil',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 14.0),
          TextButton(
            onPressed: widget.prevPage,
            child: Text(
              'Retour',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

Widget featureTile(String title, String subtitle, IconData icon) {
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Constants.greyColor,
      borderRadius: BorderRadius.circular(22.0),
    ),
    child: Row(
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Icon(icon, color: Constants.primaryColor),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
              ),
              SizedBox(height: 4.0),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
