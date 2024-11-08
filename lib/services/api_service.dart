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
          'Cache-Control': 'no-cache', // Prevents caching of the response
          'Pragma': 'no-cache',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (var item in data) {
          if (item is Map<String, dynamic> && item.containsKey('id')) {
            String id = item['id']; // Assuming 'id' is the unique identifier for each gist
            if (!seenIds.contains(id)) {
              seenIds.add(id); // Add ID to the set
              allRepos.add(item); // Add the unique item to the list
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
}
