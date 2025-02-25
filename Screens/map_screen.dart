import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  late MapController _mapController;
  LatLng _currentLocation = LatLng(28.7041, 77.1025); // Default location
  LatLng? _searchedLocation;
  List<List<LatLng>> _routes = []; // Store multiple routes
  List<Map<String, dynamic>> _routeDetails = []; // Distance & duration
  int _selectedRouteIndex = 0;
  final String apiKey = '5b3ce3597851110001cf6248199aa2d0a0b24fff8da2e070e044c2f0';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
  }

  /// Get user's real location
  Future<void> _getUserLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final userLocation = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
    });
    _mapController.move(_currentLocation, 15.0);
  }

  /// Search location and add as destination
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      final response = await Dio().get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {'q': query, 'format': 'json', 'limit': 1},
      );

      if (response.data.isNotEmpty) {
        final lat = double.parse(response.data[0]['lat']);
        final lon = double.parse(response.data[0]['lon']);
        setState(() {
          _searchedLocation = LatLng(lat, lon);
        });
        _mapController.move(_searchedLocation!, 15.0);
      } else {
        _showSnackbar('Location not found');
      }
    } catch (e) {
      _showSnackbar('Error searching location');
    }
  }

  /// Get route options
  Future<void> _getRoutes() async {
    if (_searchedLocation == null) {
      _showSnackbar('Please search a destination first.');
      return;
    }

    try {
      final response = await Dio().post(
        'https://api.openrouteservice.org/v2/directions/driving-car/geojson',
        options: Options(headers: {
          'Authorization': apiKey,
          'Content-Type': 'application/json',
        }),
        data: {
          "coordinates": [
            [_currentLocation.longitude, _currentLocation.latitude],
            [_searchedLocation!.longitude, _searchedLocation!.latitude]
          ],
          "alternative_routes": {"target_count": 3}, // Request alternative routes
        },
      );

      if (response.data != null && response.data['features'].isNotEmpty) {
        List<List<LatLng>> routeOptions = [];
        List<Map<String, dynamic>> routeDetails = [];

        for (var feature in response.data['features']) {
          var coordinates = feature['geometry']['coordinates'];
          List<LatLng> route = coordinates.map<LatLng>((point) => LatLng(point[1], point[0])).toList();

          routeOptions.add(route);
          routeDetails.add({
            'distance': feature['properties']['segments'][0]['distance'] / 1000, // KM
            'duration': feature['properties']['segments'][0]['duration'] ~/ 60, // Minutes
          });
        }

        setState(() {
          _routes = routeOptions;
          _routeDetails = routeDetails;
          _selectedRouteIndex = 0; // Default to first route
        });
      } else {
        _showSnackbar('No routes found');
      }
    } catch (e) {
      _showSnackbar('Error fetching routes');
    }
  }

  /// Select alternative route
  void _selectRoute(int index) {
    setState(() {
      _selectedRouteIndex = index;
    });
  }

  /// Reset everything
  void _resetMap() {
    setState(() {
      _routes.clear();
      _routeDetails.clear();
      _searchedLocation = null;
      _selectedRouteIndex = 0;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4B268F),
        title: const Text("Smart Travel Guide", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _resetMap,
            tooltip: "Reset Map",
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(center: _currentLocation, zoom: 12.0),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                  ),
                  if (_searchedLocation != null)
                    Marker(
                      point: _searchedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                ],
              ),
              if (_routes.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    for (int i = 0; i < _routes.length; i++)
                      Polyline(
                        points: _routes[i],
                        strokeWidth: _selectedRouteIndex == i ? 5.0 : 3.0,
                        color: _selectedRouteIndex == i ? Colors.blue : Colors.grey,
                      ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(hintText: "Search destination...", border: InputBorder.none),
                      onSubmitted: _searchLocation,
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.search), onPressed: () => _searchLocation(_searchController.text)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: _getRoutes,
              child: const Text("Get Directions"),
            ),
          ),
        ],
      ),
    );
  }
}
