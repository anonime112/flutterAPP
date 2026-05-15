import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/main_shell.dart';
import 'package:repair_service_ui/pages/register_page.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/utils/helper.dart';
import 'package:repair_service_ui/widgets/input_widget.dart';
import 'package:repair_service_ui/widgets/primary_button.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InputWidget(
            hintText: "Email",
            suffixIcon: Icons.mail_outline,
          ),
          SizedBox(
            height: 15.0,
          ),
          InputWidget(
            hintText: "Password",
            obscureText: true,
          ),
          SizedBox(
            height: 25.0,
          ),
          PrimaryButton(
            text: "Entrer",
            onPressed: () {
              AppSession.setFromRegistration(UserType.client);
              Helper.nextPage(context, const MainShell());
            },
          ),
          SizedBox(height: 16.0),
          Center(
            child: TextButton(
              onPressed: () => Helper.nextPage(context, const RegisterPage()),
              child: Text(
                'Pas de compte ? S’inscrire',
                style: TextStyle(
                  color: Color(0xFFFE7A3B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
