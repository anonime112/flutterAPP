import 'package:flutter/material.dart';
import 'package:repair_service_ui/pages/request_service_flow.dart';
import 'package:repair_service_ui/services/app_session.dart';
import 'package:repair_service_ui/utils/constants.dart';
import 'package:repair_service_ui/widgets/input_widget.dart';
import 'package:repair_service_ui/widgets/primary_button.dart';

enum UserType { client, conducteur }

/// Inscription avec choix Client ou Conducteur.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const Color _headerDark = Color(0xFF1A1C1E);

  UserType _userType = UserType.client;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Type de compte',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _typeCard(UserType.client)),
                      const SizedBox(width: 12),
                      Expanded(child: _typeCard(UserType.conducteur)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Informations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  InputWidget(hintText: 'Nom complet', suffixIcon: Icons.person_outline),
                  const SizedBox(height: 12),
                  InputWidget(hintText: 'Email', suffixIcon: Icons.mail_outline),
                  const SizedBox(height: 12),
                  InputWidget(hintText: 'Téléphone (+225)', suffixIcon: Icons.phone_outlined),
                  const SizedBox(height: 12),
                  InputWidget(hintText: 'Mot de passe', obscureText: true),
                  if (_userType == UserType.conducteur) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Constants.accentLagoon.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Constants.accentLagoon.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Constants.accentLagoon, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Compte conducteur : vérifiez votre permis et votre véhicule pour proposer des courses.',
                              style: TextStyle(fontSize: 12, color: Colors.grey[800], height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  PrimaryButton(
                    text: 'Créer mon compte',
                    onPressed: () {
                      AppSession.setFromRegistration(_userType);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const RequestServiceFlow()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Déjà un compte ? Se connecter',
                        style: TextStyle(color: Constants.accentOrange, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, top + 4, 20, 28),
      color: _headerDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inscription',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Rejoignez Abidjan Trajet',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeCard(UserType type) {
    final selected = _userType == type;
    final isClient = type == UserType.client;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _userType = type),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? Constants.accentOrange.withValues(alpha: 0.1) : Constants.greyColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? Constants.accentOrange : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (isClient ? Constants.accentLagoon : Constants.primaryColor).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isClient ? Icons.person_outline : Icons.local_taxi,
                  size: 28,
                  color: isClient ? Constants.accentLagoon : Constants.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isClient ? 'Client' : 'Conducteur',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Constants.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isClient ? 'Réserver des trajets' : 'Proposer des courses',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
