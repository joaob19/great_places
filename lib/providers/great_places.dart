import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/utils/LOCATION_UTIL.dart';
import 'package:great_places/utils/db_tables.dart';
import 'package:great_places/utils/db_util.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items => [..._items];

  int get itemsCount => _items.length;

  Place getItemByIndex(int index) {
    return _items[index];
  }

  Future<void> loadPlaces() async {
    List<Place> places = [];

    final dataList = await DbUtil.getData(DbTables.places);
    places = dataList.map((item) {
      return Place(
        id: item['id'] as String,
        title: item['title'] as String,
        image: File(item['image'] as String),
        location: PlaceLocation(
          latitude: item['latitude'] as double,
          longitude: item['longitude'] as double,
          address: item['address'] as String,
        ),
      );
    }).toList();

    _items = places;

    notifyListeners();
  }

  Future<void> addPlace(
    String title,
    File image,
    LatLng position,
  ) async {
    String address = await LocationUtil.getAddressFrom(position);

    final newPlace = Place(
        id: Random().nextDouble().toString(),
        title: title,
        image: image,
        location: PlaceLocation(
            latitude: position.latitude,
            longitude: position.longitude,
            address: address));

    _items.add(newPlace);
    DbUtil.insert(DbTables.places, {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': newPlace.location.latitude,
      'longitude': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    notifyListeners();
  }

  Future<void> removeById(String id) async {
    await DbUtil.deleteById(DbTables.places, id);
    loadPlaces();
  }
}
