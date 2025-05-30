import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<double> getDistanceFromMapbox({
  required LatLng origin,
  required LatLng destination,
  required String accessToken,
}) async {
  
  final String url =
      'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?geometries=geojson&access_token=$accessToken';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['routes'].isNotEmpty) {
      final double distanceMeters = data['routes'][0]['distance'];
      //final double durationSeconds = data['routes'][0]['duration'];

      return distanceMeters / 1000; // devuelve en kilómetros
    } else {
      throw Exception('No se encontraron rutas válidas.');
    }
  } else {
    throw Exception('Error al obtener la ruta de Mapbox');
  }
}

Future<List<Map<String, dynamic>>> getSuggestionsFromMapbox(String input, String accessToken) async {
  if (input.trim().length < 3) return [];

  final url =
      'https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(input)}.json'
      '?access_token=$accessToken&autocomplete=true&limit=5';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['features']);
  } else {
    throw Exception('Error al obtener sugerencias de Mapbox');
  }
}



