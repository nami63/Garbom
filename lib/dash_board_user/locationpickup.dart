import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerAlert extends StatefulWidget {
  final Function(LatLng)? onLocationSelected;
  const LocationPickerAlert({super.key, this.onLocationSelected});

  @override
  State<LocationPickerAlert> createState() => _LocationPickerAlertState();
}

class _LocationPickerAlertState extends State<LocationPickerAlert> {
  GoogleMapController? mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied');
    } else {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
    });
    if (widget.onLocationSelected != null && _selectedLocation != null) {
      widget.onLocationSelected!(_selectedLocation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 400,
        width: 300,
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: _selectedLocation ?? LatLng(0, 0),
            zoom: 15,
          ),
          onTap: (LatLng latLng) {
            setState(() {
              _selectedLocation = latLng;
            });
            if (widget.onLocationSelected != null) {
              widget.onLocationSelected!(latLng);
            }
          },
          markers: _selectedLocation != null
              ? {
                  Marker(
                      markerId: MarkerId('selected'),
                      position: _selectedLocation!)
                }
              : {},
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_selectedLocation != null) {
              Navigator.of(context).pop();
              if (widget.onLocationSelected != null) {
                widget.onLocationSelected!(_selectedLocation!);
              }
            }
          },
          child: Text('Select'),
        ),
      ],
    );
  }
}
