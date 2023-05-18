import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_function/models/places.dart';
import 'package:native_function/pages/addPlace.dart';
import 'package:native_function/providers/user_place_provider.dart';
import 'package:native_function/widgets/placeList.dart';

class ParentPage extends ConsumerStatefulWidget {
  const ParentPage({super.key});

  @override
  ConsumerState<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends ConsumerState<ParentPage> {
  List<places> placeList = [];
  late Future<void> _placeFuture;

  @override
  void initState() {
    super.initState();
    _placeFuture = ref.read(userPlaceProvider.notifier).loadPlaces();
  }

  void _addPlace(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddNewPlace(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final newPlace = ref.watch(userPlaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () => _addPlace(context), icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _placeFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: const CircularProgressIndicator())
                : PlaceList(placeList: newPlace),
      ),
    );
  }
}
