import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_function/models/placeLocation.dart';
import 'package:native_function/models/places.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:native_function/providers/user_place_provider.dart';
import 'package:native_function/widgets/image_input.dart';
import 'package:native_function/widgets/mapLocation.dart';

class AddNewPlace extends ConsumerStatefulWidget {
  const AddNewPlace({super.key});

  @override
  ConsumerState<AddNewPlace> createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends ConsumerState<AddNewPlace> {
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  final _formKey = GlobalKey<FormState>();
  var isLoading = true;
  late String name, subject;
  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final filename = path.basename(_selectedImage!.path);
      final copiedImage =
          await _selectedImage!.copy('${appDir.path}/$filename');
          
      ref.read(userPlaceProvider.notifier).addPlace(places(
          title: name,
          description: subject,
          image: copiedImage,
          location: _selectedLocation!));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  maxLength: 50,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1-50 letters.';
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    label: Text('Place Name'),
                  ),
                  onSaved: (newValue) => name = newValue!,
                ),
                TextFormField(
                  maxLength: 100,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 100) {
                      return 'Must be between 1-100 letters.';
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    label: Text('Place Description'),
                  ),
                  onSaved: (newValue) => subject = newValue!,
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blueGrey)),
                  height: 150,
                  width: double.infinity,
                  child: ImageInput(
                    onPickImage: (image) => _selectedImage = image,
                  ),
                ),
                MapLocation(
                  pickedMap: (locationPicked) =>
                      _selectedLocation = locationPicked,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: ElevatedButton(
                        onPressed: _onSave, child: const Text('Add Place')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
