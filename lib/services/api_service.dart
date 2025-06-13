import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://story-buddy-backend.onrender.com';
  
  // Get flag to determine if Harith should be shown
  static Future<bool> getFlag() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_flag'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['flag'] == 1;
      } else {
        print('Failed to get flag: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching flag: $e');
      return false;
    }
  }
  
  // Get Harith's student stories
  static Future<List<Map<String, dynamic>>> getStudentStories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_student_stories'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final stories = data['student_stories'] as List;
        return stories.cast<Map<String, dynamic>>();
      } else {
        print('Failed to get student stories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching student stories: $e');
      return [];
    }
  }
} 