import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus lugares'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.placeForm);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Consumer<GreatPlaces>(
              child: const Center(
                child: Text('Nenhum local cadastrado'),
              ),
              builder: (context, greatPlaces, child) {
                if (greatPlaces.itemsCount == 0) {
                  return child!;
                } else {
                  return ListView.builder(
                    itemCount: greatPlaces.itemsCount,
                    itemBuilder: (context, index) {
                      final item = greatPlaces.getItemByIndex(index);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(item.image),
                        ),
                        title: Text(item.title),
                        subtitle: Text(item.location.address ?? ''),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.placeDetail,
                            arguments: item,
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => greatPlaces.removeById(item.id),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
