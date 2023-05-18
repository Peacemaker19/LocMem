import 'package:flutter/material.dart';
import 'package:native_function/models/places.dart';
import 'package:native_function/pages/map_page.dart';

class PlacePage extends StatelessWidget {
  final places place;
  const PlacePage({required this.place, super.key});

  String get locationPreview {
    final lat = place.location.lat;
    final lng = place.location.long;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:H%7C$lat,$lng&key=AIzaSyC67o4gsrRPIOOQJEHiEjJ76H93pIbW1bo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: SizedBox(
        child: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapPage(
                            location: place.location, isSelecting: false),
                      ),
                    ),
                    child: CircleAvatar(
                      maxRadius: 76,
                      backgroundImage: NetworkImage(locationPreview),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white38),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent),
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 60),
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      place.location.address,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
