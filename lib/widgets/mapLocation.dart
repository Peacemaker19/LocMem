import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:native_function/models/placeLocation.dart';
import 'package:native_function/pages/map_page.dart';

class MapLocation extends StatefulWidget {
  void Function(PlaceLocation locationPicked) pickedMap;
  MapLocation({super.key, required this.pickedMap});

  @override
  State<MapLocation> createState() => _MapLocationState();
}

class _MapLocationState extends State<MapLocation> {
  PlaceLocation? _pickedLocation;
  var isGettingLocation = false;

  String get locationPreview {
    final lat = _pickedLocation!.lat;
    final lng = _pickedLocation!.long;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:H%7C$lat,$lng&key=AIzaSyC67o4gsrRPIOOQJEHiEjJ76H93pIbW1bo';
  }

  Future<void> _savePlace(double lat, double long) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyC67o4gsrRPIOOQJEHiEjJ76H93pIbW1bo');
    final response = await http.get(url);
    final resdata = json.decode(response.body);
    final address = resdata['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(lat: lat, long: long, address: address);
      isGettingLocation = false;
    });
    widget.pickedMap(_pickedLocation!);
  }

  void _getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(
      () {
        isGettingLocation = true;
      },
    );

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedPlace =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (context) => const MapPage(),
    ));

    if (pickedPlace == null) {
      return;
    }

    _savePlace(pickedPlace.latitude, pickedPlace.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = TextButton.icon(
      onPressed: null,
      icon: const Icon(Icons.location_on_outlined),
      label: const Text('Location'),
    );

    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationPreview,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.blueGrey)),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(8),
            height: 150,
            width: double.infinity,
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: TextButton.icon(
                onPressed: _getLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Current Location'),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton.icon(
                onPressed: _selectOnMap,
                icon: const Icon(Icons.map),
                label: const Text('Choose From Map'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
