/// Cartes : Google Maps par défaut (clé dans `AndroidManifest` / `AppDelegate`).
///
/// Pour développer **sans** clé Google, lancez avec :
/// `flutter run --dart-define=MAP_OSM=true`
const bool kMapsPreferOpenStreetMap = bool.fromEnvironment('MAP_OSM', defaultValue: false);

// Watsonx configuration (IBM Watson Orchestrate API)
const String kWatsonxEndpoint = 'https://api.ap-southeast-1.dl.watson-orchestrate.ibm.com/instances/20260506-1632-0412-70cb-0eda0fe2b13b';
const String kWatsonxApiKey = 'azE6dXNyX2I0OTA4MDYzLTdkMjAtMzQzNi1iYjJkLTI4YzY4YzJkZjgxMDpEYXFSU0pNTkpZOEVZbnZhdGpxUmlJdDBlKzVDbUhGbUVwaUVWeVUrbEpJPTpWSllZ';
