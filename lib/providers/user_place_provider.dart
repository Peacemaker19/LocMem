import 'dart:io';
import 'package:native_function/models/placeLocation.dart';
import 'package:native_function/models/places.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT,description TEXT, image TEXT, lat REAL, long REAL, address TEXT)');
  }, version: 1);
  return db;
}

class UserPlaceNotifier extends StateNotifier<List<places>> {
  UserPlaceNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final place = data
        .map((row) => places(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                lat: row['lat'] as double,
                long: row['long'] as double,
                address: row['address'] as String)))
        .toList();

    state = place;
  }

  void addPlace(places place) async {
    final newPlace = place;

    final db = await _getDatabase();

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'description': newPlace.description,
      'image': newPlace.image.path,
      'lat': newPlace.location.lat,
      'long': newPlace.location.long,
      'address': newPlace.location.address,
    });

    state = [...state, newPlace];
  }

  void deletePlace(String id) async {
    final db = await _getDatabase();
    db.delete('user_places', where: 'id = ?', whereArgs: [id]);
    loadPlaces();
  }
}

final userPlaceProvider =
    StateNotifierProvider<UserPlaceNotifier, List<places>>(
  (ref) => UserPlaceNotifier(),
);
