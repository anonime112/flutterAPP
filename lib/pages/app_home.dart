import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/main_shell.dart';

/// Point d’entrée historique — redirige vers le shell avec navigation globale.
class AppHomePage extends StatelessWidget {
  final int initialIndex;

  const AppHomePage({this.initialIndex = 0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainShell(initialIndex: initialIndex);
  }
}
