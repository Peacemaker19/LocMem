import 'package:uuid/uuid.dart';
import './placeLocation.dart';
import 'dart:io';

const uuid = Uuid();

class places {
  places({
    required this.title,
    required this.description,
    required this.image,
    required this.location,
    id,
  }) : id = id ?? uuid.v4();
  final String id, title, description;
  final File image;
  final PlaceLocation location;
}
