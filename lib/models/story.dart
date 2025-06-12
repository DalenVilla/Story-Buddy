class Story {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final Map<int, String> choices;
  final DateTime createdAt;

  Story({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.choices,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'choices': choices.map((key, value) => MapEntry(key.toString(), value)),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      choices: Map<int, String>.from(
        (json['choices'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), value.toString()),
        ),
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Generate a title from the story content
  static String generateTitle(String content) {
    // Extract the first meaningful sentence or use first few words
    final sentences = content.split('.').where((s) => s.trim().isNotEmpty).toList();
    if (sentences.isNotEmpty) {
      String firstSentence = sentences.first.trim();
      // Remove common story openings
      firstSentence = firstSentence.replaceAll(RegExp(r'^(Once upon a time,?\s*|In a land where\s*|Deep in\s*|On a sunny morning\s*|In a world\s*|Long ago\s*)', caseSensitive: false), '');
      
      // Take first 6 words maximum
      final words = firstSentence.split(' ').take(6).join(' ');
      return words.isNotEmpty ? words : 'My Story';
    }
    return 'My Story';
  }
} 