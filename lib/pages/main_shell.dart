import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/driver/driver_home_tab.dart';
import 'package:repair_service_ui/pages/history_stats_page.dart';
import 'package:repair_service_ui/pages/orders_tab_page.dart';
import 'package:repair_service_ui/pages/profile_page.dart';
import 'package:repair_service_ui/pages/tabs/home_tab.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/widgets/app_bottom_nav.dart';
import 'package:repair_service_ui/widgets/app_drawer.dart';

/// Conteneur principal : onglets + barre de navigation sur toutes les vues.
class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  static MainShellState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainShellState>();
  }

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  late int _currentIndex;
  Widget? _overlay;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void pushOverlay(Widget page) {
    setState(() => _overlay = page);
  }

  void popOverlay() {
    setState(() => _overlay = null);
  }

  bool get hasOverlay => _overlay != null;

  void switchTab(int index) {
    setState(() {
      _overlay = null;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _overlay == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _overlay != null) {
          popOverlay();
        }
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        body: _overlay ?? IndexedStack(
          index: _currentIndex,
          children: AppSession.isConducteur
              ? const [
                  DriverHomeTab(),
                  HistoryStatsPage(),
                  OrdersTabPage(),
                  ProfilePage(),
                ]
              : const [
                  HomeTab(),
                  HistoryStatsPage(),
                  OrdersTabPage(),
                  ProfilePage(),
                ],
        ),
        bottomNavigationBar: AppBottomNav(
          isConducteur: AppSession.isConducteur,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (_overlay != null) popOverlay();
            setState(() => _currentIndex = index);
          },
        ),
      ),
    );
  }
}

/// Enveloppe pour une page secondaire tout en gardant la barre du shell parent.
class ShellOverlayPage extends StatelessWidget {
  const ShellOverlayPage({
    super.key,
    required this.child,
    this.title,
  });

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Material(
            color: const Color(0xFF1A1C1E),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => MainShell.of(context)?.popOverlay(),
                  ),
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
