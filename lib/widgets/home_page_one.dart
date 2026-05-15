import 'package:flutter/material.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/page_indicator.dart';

class HomePageOne extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback prevPage;

  const HomePageOne({required this.nextPage, required this.prevPage, Key? key}) : super(key: key);
  @override
  _HomePageOneState createState() => _HomePageOneState();
}

class _HomePageOneState extends State<HomePageOne> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height - kToolbarHeight,
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/gettyimages-1321204684-2048x2048.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              radius: 28.0,
              backgroundColor: Colors.white,
              child: Icon(Icons.navigation, color: Constants.primaryColor),
            ),
          ),
          SizedBox(height: 24.0),
          PageIndicator(activePage: 1),
          SizedBox(height: 24.0),
          Text(
            'Votre assistant trajet à Abidjan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Comparez les moyens de transport et laissez l’IA vous proposer l’itinéraire le plus adapté au trafic.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: widget.nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: Text(
              'Commencer',
              style: TextStyle(color: Constants.primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
