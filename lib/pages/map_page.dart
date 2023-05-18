// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:native_function/models/placeLocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage(
      {super.key,
      this.location = const PlaceLocation(
        lat: 28.6139,
        long: 77.2090,
        address: '',
      ),
      this.isSelecting = true});

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _isPicked;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick Your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_isPicked);
              },
              icon: const Icon(Icons.save),
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  _isPicked = position;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.lat, widget.location.long),
          zoom: 16,
        ),
        markers: (_isPicked == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _isPicked ??
                      LatLng(
                        widget.location.lat,
                        widget.location.long,
                      ),
                )
              },
      ),
    );
  }
}
