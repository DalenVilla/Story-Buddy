import 'dart:convert';
import 'package:http/http.dart' as http;

class TeacherStory {
  final String id;
  final String name;
  final String content;
  final String imageUrl;

  TeacherStory({
    required this.id,
    required this.name,
    required this.content,
    required this.imageUrl,
  });

  factory TeacherStory.fromJson(String id, Map<String, dynamic> json) {
    return TeacherStory(
      id: id,
      name: json['story_name'] ?? 'Untitled',
      content: json['story_content'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class TeacherStoryService {
  static const String _endpoint =
      'https://story-buddy-backend.onrender.com/get_teacher_stories';

  static Future<List<TeacherStory>> fetchTeacherStories() async {
    final resp = await http.get(Uri.parse(_endpoint));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is Map && data['teacher_stories'] is Map) {
        final Map storiesMap = data['teacher_stories'];
        return storiesMap.entries
            .map<TeacherStory>((entry) =>
                TeacherStory.fromJson(entry.key.toString(), entry.value))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to fetch teacher stories: ${resp.statusCode}');
    }
  }
} 