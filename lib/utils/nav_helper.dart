import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/main_shell.dart';

/// Retour : ferme l’overlay du shell ou la route courante.
void popPage(BuildContext context) {
  final shell = MainShell.of(context);
  if (shell != null && shell.hasOverlay) {
    shell.popOverlay();
  } else if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}
