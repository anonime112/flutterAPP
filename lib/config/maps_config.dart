/// Cartes : **OpenStreetMap** par défaut sur tous les builds (gratuit, sans clé API).
///
/// Pour passer à Google Maps : configurer la clé (`AndroidManifest` / `AppDelegate`) puis :
/// `flutter run --dart-define=MAP_GOOGLE=true` ou `flutter build apk --dart-define=MAP_GOOGLE=true`
bool get kMapsPreferOpenStreetMap {
  const forceGoogle = bool.fromEnvironment('MAP_GOOGLE', defaultValue: false);
  return !forceGoogle;
}

// Watsonx configuration (IBM Watson Orchestrate API)
const String kWatsonxEndpoint = 'https://api.ap-southeast-1.dl.watson-orchestrate.ibm.com/instances/20260506-1632-0412-70cb-0eda0fe2b13b';
const String kWatsonxApiKey = 'azE6dXNyX2I0OTA4MDYzLTdkMjAtMzQzNi1iYjJkLTI4YzY4YzJkZjgxMDpEYXFSU0pNTkpZOEVZbnZhdGpxUmlJdDBlKzVDbUhGbUVwaUVWeVUrbEpJPTpWSllZ';
