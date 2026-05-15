import 'package:flutter/material.dart';
import 'package:repair_service_ui/widgets/login_form.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Pont-bouygues.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF17232A).withOpacity(0.92), Color(0xFF17232A).withOpacity(0.72)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 60.0,
                left: 24.0,
                right: 24.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Abidjan Trajet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 14.0),
                    Text(
                      'L’IA vous aide à choisir le meilleur moyen pour aller d’un point A à un point B : VTC, bus, covoiturage et plus.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 80.0,
                width: size.width,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20.0,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Connexion',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              'Accédez à la carte, aux itinéraires intelligents et à vos trajets à Abidjan.',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 24.0),
                            LoginForm(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
