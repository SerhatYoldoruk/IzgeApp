import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class OsmService {
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  /// Fetch Points of Interest (POIs) from OpenStreetMap using Overpass API
  /// bbox requires: minLat (south), minLng (west), maxLat (north), maxLng (east)
  Future<List<Map<String, dynamic>>> fetchPlacesInBounds(
      double minLat, double minLng, double maxLat, double maxLng) async {
    
    final String bbox = '$minLat,$minLng,$maxLat,$maxLng';
    
    // We fetch hospitals, clinics, parks, schools, and social facilities
    final String query = '''
      [out:json][timeout:25];
      (
        node["amenity"="hospital"]($bbox);
        node["amenity"="clinic"]($bbox);
        node["leisure"="park"]($bbox);
        node["amenity"="school"]($bbox);
        node["amenity"="social_facility"]($bbox);
        node["amenity"="kindergarten"]($bbox);
      );
      out body;
    ''';

    try {
      final response = await http.post(
        Uri.parse(_overpassUrl),
        headers: {
          'Content-Type': 'text/plain',
          'Accept': 'application/json',
          'User-Agent': 'IzgeApp/1.0 (contact@izgeapp.com)',
        },
        body: query,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List elements = data['elements'] ?? [];
        return elements.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load places from OSM: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('OSM Error: $e');
      return [];
    }
  }
}
