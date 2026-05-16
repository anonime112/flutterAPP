import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/home_page_one.dart';
import 'package:repair_service_ui/widgets/home_page_three.dart';
import 'package:repair_service_ui/widgets/home_page_two.dart';

class RequestServiceFlow extends StatefulWidget {
  final int initialPage;
  const RequestServiceFlow({this.initialPage = 0, Key? key}) : super(key: key);

  @override
  _RequestServiceFlowState createState() => _RequestServiceFlowState();
}

class _RequestServiceFlowState extends State<RequestServiceFlow> {
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.initialPage;
  }

  void nextPage() {
    setState(() {
      if (current < 2) current += 1;
    });
  }

  void prevPage() {
    setState(() {
      if (current > 0) current -= 1;
    });
  }

  void goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) {
        return const MainShell();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePageOne(nextPage: nextPage, prevPage: prevPage),
      HomePageTwo(nextPage: nextPage, prevPage: prevPage),
      HomePageThree(prevPage: prevPage, onGetStarted: goToHome),
    ];

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: current > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: this.prevPage,
              )
            : null,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: current == 0
          ? Constants.primaryColor
          : current == 1
              ? Color(0xFF1A1C1E)
              : Colors.white,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: pages[current],
      ),
    );
  }
}
