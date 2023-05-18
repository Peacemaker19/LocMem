import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_function/models/places.dart';
import '../pages/placePage.dart';
import '../providers/user_place_provider.dart';

class PlaceList extends ConsumerWidget {
  List<places> placeList = [];
  PlaceList({required this.placeList, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget alertBox(places place) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        backgroundColor: Colors.white.withOpacity(0.3),
        alignment: Alignment.center,
        title: const Text('Are you sure to delete this place?'),
        icon: const Icon(
          Icons.delete,
          size: 50,
          color: Colors.red,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('No')),
          TextButton(
              onPressed: () {
                ref.watch(userPlaceProvider.notifier).deletePlace(place.id);
                Navigator.of(context).pop();
              },
              child: Text('Yes'))
        ],
      );
    }

    Widget content =
        const Center(child: Text('No Places Yet! Add Some Places.'));

    if (placeList.isNotEmpty) {
      content = SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: ListView.builder(
          itemCount: placeList.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () => showDialog(
                context: context,
                builder: (context) => alertBox(placeList[index]),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlacePage(place: placeList[index]),
                  ),
                );
              },
              child: Card(
                elevation: 20,
                shape: const StadiumBorder(
                    side: BorderSide(width: 1, color: Colors.green)),
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage: FileImage(placeList[index].image),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            placeList[index].title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            placeList[index].description,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    return content;
  }
}
