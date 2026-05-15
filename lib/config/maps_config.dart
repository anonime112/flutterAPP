/// Cartes : Google Maps par défaut (clé dans `AndroidManifest` / `AppDelegate`).
///
/// Pour développer **sans** clé Google, lancez avec :
/// `flutter run --dart-define=MAP_OSM=true`
const bool kMapsPreferOpenStreetMap = bool.fromEnvironment('MAP_OSM', defaultValue: false);

// Watsonx configuration (IBM Watson Orchestrate API)
const String kWatsonxEndpoint = 'https://api.ap-southeast-1.dl.watson-orchestrate.ibm.com/instances/20260506-1632-0412-70cb-0eda0fe2b13b';
const String kWatsonxApiKey = 'azE6dXNlcl9iNDkwODA2My03ZGIwLTM0MzYtYmIyZC0yOGM2OGMyZGY4MTA6NzVzNzF6N0RxR1BYK2p6R2swawBmaUpacTB1ZlBJSDlTUGIrdFRyc1c2dz06TTJ5Ug';
