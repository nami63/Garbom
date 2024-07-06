import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LatLng _initialCameraPosition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  Location _location = Location();
  bool _isLoading = true; // Initially set to true to show loading indicator

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  void _initLocationTracking() {
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude ?? 0.0,
                currentLocation.longitude ?? 0.0),
            zoom: 15,
          ),
        ),
      );
      setState(() {
        _isLoading = false; // Hide loading indicator once location is received
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Page")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialCameraPosition, zoom: 5),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            mapType: MapType.normal,
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
