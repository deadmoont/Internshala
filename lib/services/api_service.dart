import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.github.com/gists/public';

  Future<List<Map<String, dynamic>>> fetchPublicRepos() async {
    Set<String> seenIds = {}; // Track unique gist IDs
    List<Map<String, dynamic>> allRepos = [];

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (var item in data) {
          if (item is Map<String, dynamic> && item.containsKey('id')) {
            String id = item['id'];
            if (!seenIds.contains(id)) {
              seenIds.add(id);
              allRepos.add(item);
            }
          }
        }
      } else {
        throw Exception('Failed to load repos');
      }
    } catch (e) {
      throw Exception('Error fetching repos: $e');
    }

    return allRepos;
  }

  static const String _basUrl = 'https://api.unsplash.com';
  static const String _accessKey = '8_sKr9zDk2jdHGkdqx9ypCt5tCECgpS-BcHbhpuUrY4';
  Future<List<String>> fetchPhotos({int perPage = 20}) async {
    final url = '$_basUrl/photos?per_page=$perPage&client_id=$_accessKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      // Extract photo URLs
      return data.map<String>((photo) => photo['urls']['small']).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
