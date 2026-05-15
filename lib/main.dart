import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repair_service_ui/pages/app_home.dart';
import 'package:repair_service_ui/pages/home.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/pages/register_page.dart';
import 'package:repair_service_ui/pages/request_service_flow.dart';
import 'package:repair_service_ui/utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Abidjan Trajet',
        theme: ThemeData(
          primaryColor: Constants.primaryColor,
          scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Constants.accentLagoon,
            primary: Constants.primaryColor,
            secondary: Constants.accentOrange,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        initialRoute: "/",
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      });
    case "/onboarding":
      return MaterialPageRoute(builder: (BuildContext context) {
        return RequestServiceFlow();
      });
    case "/app-home":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const MainShell();
      });
    case "/register":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const RegisterPage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      });
  }
}
