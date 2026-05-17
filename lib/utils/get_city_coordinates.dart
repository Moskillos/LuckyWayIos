import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Map<String, double>?> getCityCoordinates(String cityName) async {
  String apiKey = "AIzaSyDVkK7x-ABKGCaMEVWyzuhbAe_jklIJo-U";
  final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?address=$cityName&key=$apiKey");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['results'].isNotEmpty) {
      final location = data['results'][0]['geometry']['location'];
      return {"lat": location['lat'], "lng": location['lng']};
    }
  }
  return null;
}

bool isCityWithinDistance(List<LatLng> path, double cityLat, double cityLng, double maxDistanceKm) {
  for (var point in path) {
    double distance = Geolocator.distanceBetween(cityLat, cityLng, point.latitude, point.longitude) / 1000; // in km
    if (distance <= maxDistanceKm) {
      return true; // La città è entro i 30 km dal percorso
    }
  }
  return false;
}

Future<Map<String, double>?> getAddressCoordinates(String address) async {
  String apiKey = "AIzaSyDVkK7x-ABKGCaMEVWyzuhbAe_jklIJo-U";
  final Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      final location = data['results'][0]['geometry']['location'];
      return {
        'lat': location['lat'],
        'lng': location['lng'],
      };
    }
  }
  return null;
}