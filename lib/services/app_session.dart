import 'package:repair_service_ui/pages/register_page.dart';

/// Session locale (type d’utilisateur après inscription / connexion).
class AppSession {
  AppSession._();

  static UserType userType = UserType.client;
  static String displayName = 'Utilisateur Abidjan';

  static bool get isConducteur => userType == UserType.conducteur;
  static bool get isClient => userType == UserType.client;

  static void setFromRegistration(UserType type, {String? name}) {
    userType = type;
    if (name != null && name.isNotEmpty) displayName = name;
    if (type == UserType.conducteur) {
      displayName = name?.isNotEmpty == true ? name! : 'Conducteur Abidjan';
    }
  }

  static void logout() {
    userType = UserType.client;
    displayName = 'Utilisateur Abidjan';
  }
}
