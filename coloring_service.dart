import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coloring_page.dart';

class ColoringService {
  // Use the JSONBin URL for coloring pages
  static const String apiUrl = 'https://api.jsonbin.io/v3/qs/68039ce18960c979a5889a0a';

  Future<List<ColoringPage>> fetchColoringPages() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          
          // Check if 'record' field exists in the response
          if (jsonResponse.containsKey('record')) {
            final List<dynamic> jsonData = jsonResponse['record'] as List<dynamic>;
            
            // Debug print to help identify JSON structure
            print('Successfully loaded coloring pages: ${jsonData.length}');
            
            // Convert each JSON object to a ColoringPage
            return jsonData.map((json) => ColoringPage.fromJson(json)).toList();
          } else {
            print('Error: JSON response does not contain "record" field');
            print('Response body: ${response.body}');
            return [];
          }
        } catch (e) {
          print('Error parsing JSON: $e');
          print('Response body: ${response.body}');
          return [];
        }
      } else {
        print('Failed to load coloring pages: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching coloring pages: $e');
      return [];
    }
  }
}
