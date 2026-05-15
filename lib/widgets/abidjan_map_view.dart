import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';
import 'package:repair_service_ui/config/maps_config.dart';
import 'package:repair_service_ui/utils/constants.dart';

/// Carte Abidjan : **Google Maps** par défaut (tuiles et style Google).
/// Sans clé API valide, l’écran peut rester gris : utilisez alors `--dart-define=MAP_OSM=true` pour OpenStreetMap.
class AbidjanMapView extends StatefulWidget {
  const AbidjanMapView({
    super.key,
    this.mapPadding = EdgeInsets.zero,
    this.onMapControllerReady,
    this.showTraffic = false,
    this.pickupLabel = 'Départ',
    this.pickupSnippet = 'Marcory — Zone 4',
    this.dropoffLabel = 'Arrivée',
    this.dropoffSnippet = 'Plateau — Centre-ville',
    this.preferOpenStreetMap,
  });

  final EdgeInsets mapPadding;
  final void Function(gmaps.GoogleMapController controller)? onMapControllerReady;
  final bool showTraffic;
  final String pickupLabel;
  final String pickupSnippet;
  final String dropoffLabel;
  final String dropoffSnippet;
  final bool? preferOpenStreetMap;

  @override
  State<AbidjanMapView> createState() => _AbidjanMapViewState();
}

class _AbidjanMapViewState extends State<AbidjanMapView> {
  static final gmaps.LatLng _gCenter = gmaps.LatLng(Constants.abidjanLat, Constants.abidjanLng);
  static final gmaps.LatLng _gPickup = gmaps.LatLng(5.3470, -3.9925);
  static final gmaps.LatLng _gDropoff = gmaps.LatLng(5.3255, -4.0015);

  static final LatLng _osmCenter = LatLng(Constants.abidjanLat, Constants.abidjanLng);
  static final LatLng _osmPickup = LatLng(5.3470, -3.9925);
  static final LatLng _osmDropoff = LatLng(5.3255, -4.0015);

  final MapController _osmController = MapController();
  gmaps.GoogleMapController? _googleController;

  late final Set<gmaps.Polyline> _googlePolylines = {
    gmaps.Polyline(
      polylineId: const gmaps.PolylineId('demo_route'),
      color: Constants.accentOrange,
      width: 5,
      jointType: gmaps.JointType.round,
      startCap: gmaps.Cap.roundCap,
      endCap: gmaps.Cap.roundCap,
      points: [
        _gPickup,
        const gmaps.LatLng(5.3380, -3.9940),
        const gmaps.LatLng(5.3320, -3.9965),
        const gmaps.LatLng(5.3285, -3.9990),
        _gDropoff,
      ],
    ),
  };

  Set<gmaps.Marker> _googleMarkers() => {
        gmaps.Marker(
          markerId: const gmaps.MarkerId('pickup'),
          position: _gPickup,
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueGreen),
          infoWindow: gmaps.InfoWindow(title: widget.pickupLabel, snippet: widget.pickupSnippet),
        ),
        gmaps.Marker(
          markerId: const gmaps.MarkerId('dropoff'),
          position: _gDropoff,
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueOrange),
          infoWindow: gmaps.InfoWindow(title: widget.dropoffLabel, snippet: widget.dropoffSnippet),
        ),
      };

  bool _myLocationEnabled = false;

  List<LatLng> get _osmRoutePoints => [
        _osmPickup,
        const LatLng(5.3380, -3.9940),
        const LatLng(5.3320, -3.9965),
        const LatLng(5.3285, -3.9990),
        _osmDropoff,
      ];

  @override
  void initState() {
    super.initState();
    final useOsm = widget.preferOpenStreetMap ?? kMapsPreferOpenStreetMap;
    if (!useOsm) {
      _initLocation();
    }
  }

  Future<void> _initLocation() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (!mounted) return;
    final ok = perm == LocationPermission.whileInUse || perm == LocationPermission.always;
    setState(() => _myLocationEnabled = ok);
  }

  @override
  void dispose() {
    _googleController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useOsm = widget.preferOpenStreetMap ?? kMapsPreferOpenStreetMap;
    if (useOsm) {
      return _buildOsmMap();
    }
    return _buildGoogleMap();
  }

  Widget _buildGoogleMap() {
    return Stack(
      fit: StackFit.expand,
      children: [
        gmaps.GoogleMap(
          initialCameraPosition: gmaps.CameraPosition(
            target: _gCenter,
            zoom: 13.25,
            tilt: 20,
          ),
          markers: _googleMarkers(),
          polylines: _googlePolylines,
          padding: widget.mapPadding,
          myLocationEnabled: _myLocationEnabled,
          myLocationButtonEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          trafficEnabled: widget.showTraffic,
          buildingsEnabled: true,
          zoomControlsEnabled: false,
          mapType: gmaps.MapType.normal,
          onMapCreated: (c) {
            _googleController = c;
            widget.onMapControllerReady?.call(c);
          },
        ),
        Positioned(
          left: 8 + widget.mapPadding.left,
          right: 8 + widget.mapPadding.right,
          bottom: 4 + widget.mapPadding.bottom,
          child: Text(
            'Google Maps',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[800],
              shadows: const [Shadow(color: Colors.white70, blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOsmMap() {
    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          mapController: _osmController,
          options: MapOptions(
            initialCenter: _osmCenter,
            initialZoom: 13.2,
            minZoom: 5,
            maxZoom: 18,
            backgroundColor: const Color(0xFFDDE8F0),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.repair_service_ui',
              maxNativeZoom: 19,
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _osmRoutePoints,
                  color: Constants.accentOrange,
                  strokeWidth: 5,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 38,
                  height: 38,
                  point: _osmPickup,
                  alignment: Alignment.bottomCenter,
                  child: Icon(Icons.location_on, color: Constants.accentGreen, size: 38),
                ),
                Marker(
                  width: 38,
                  height: 38,
                  point: _osmDropoff,
                  alignment: Alignment.bottomCenter,
                  child: Icon(Icons.location_on, color: Constants.accentOrange, size: 38),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          left: 6 + widget.mapPadding.left,
          right: 6 + widget.mapPadding.right,
          bottom: 4 + widget.mapPadding.bottom,
          child: Text(
            '© OpenStreetMap contributeurs',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[800],
              shadows: const [Shadow(color: Colors.white70, blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }
}
