import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  // Load API key from environment variable
  static String get _apiKey => dotenv.env['GEM_API'] ?? '';
  static String get _backendApiKey => dotenv.env['BACKEND_API'] ?? '';
  
  Future<String> generateStory({
    required Map<int, String> choices,
    required String age,
    required String theme,
  }) async {
    try {
      // Create a prompt based on the user's choices with randomness
      final prompt = _buildPrompt(choices, age, theme);
      
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [{
            'parts': [{
              'text': prompt
            }]
          }],
          'generationConfig': {
            // Higher temperature for more creativity and randomness
            'temperature': 1.0,
            // Higher topK for more diverse token selection
            'topK': 64,
            // Slightly lower topP for more focused creativity
            'topP': 0.85,
            'maxOutputTokens': 1024,
            // Add some randomness to prevent repetition
            'candidateCount': 1,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Extract the generated text from the response
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          throw Exception('No story content received from Gemini API');
        }
      } else {
        throw Exception('Failed to generate story: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating story: $e');
    }
  }
  
  String _buildPrompt(Map<int, String> choices, String age, String theme) {
    // Add randomness to prevent memory/repetition
    final random = Random();
    final randomSeed = random.nextInt(10000);
    

    
    
    // Vary the magical elements mentioned
final magicalElements = [
  'talking animals, enchanted places, dreamlike elements',
  'friendly magical creatures, mysterious doors, floating objects',
  'singing flowers, dancing trees, shimmering portals',
  'wise animals, magical gardens, glowing pathways',
  'helpful sprites, rainbow bridges, whispering winds',
  'crystal caves, gentle giants, hidden treasure maps',
  'playful fairies, moonlit rivers, starlit lanterns',
  'mischievous pixies, secret tunnels, glowing mushrooms',
  'dragon hatchlings, floating islands, silver waterfalls',
  'time-twisting clocks, echoing chambers, glowing runes',
  'cloud-castle towers, friendly griffins, winding staircases',
  'living books, whispering trees, glowing star-dust',
  'shape-shifting shadows, crystal butterflies, magic wands',
  'dancing fireflies, enchanted instruments, talking stones',
  'whispering seashells, coral archways, mermaid friends',
  'floating lanterns, hidden doorways, magical inkpots',
  'glowing runes, ancient guardians, secret staircases',
  'midnight meadows, glowing dewdrops, talking owls',
  'mirror lakes, friendly water sprites, glowing lotus',
  'hidden treehouses, singing wind chimes, moonbeam paths',
];

    
    final selectedMagical = magicalElements[random.nextInt(magicalElements.length)];
    
    return '''
[Session ID: $randomSeed] You are a fresh, imaginative storyteller creating a completely new and unique story. Ignore any previous stories or patterns.

Create a short, magical story (3–4 short paragraphs) for a young reader who is currently feeling "${choices[0]}".
Right now, their mood is like the weather: "${choices[1]}".

Earlier today, they experienced this: "${choices[2]}". 
They wish they could change one thing: "${choices[3]}".

The story should:
- Be completely original and different from any previous stories
- Help the child feel seen and understood in their emotion
- Include a fun, light touch of fantasy ($selectedMagical)
- Be written in simple language for a 6-year-old
- End on a positive, comforting note

Avoid moralizing or lecturing. Instead, reflect their emotional journey in a metaphorical or story-based way.

Write at a reading level for a 6-year-old:
- Use simple, age-appropriate words
- Use short sentences (10 words or fewer)
- 4 Paragraphs
- Use gentle and clear ideas they can easily understand
- No complex metaphors or long dialogue
- No introduction or explanation — **just return the story only**
- Use 1-3 syllable words ONLY. SHORT SENTENCES ONLY.


Keep the tone warm, playful, and emotionally supportive.

**Create something completely fresh and new. Only return the story text itself. Do not explain, introduce, or summarize it.**

Do not include any JSON, titles, or additional formatting. Just return the pure story text.
''';
  }
  
  Future<String> generateStoryTitle({
    required String story,
  }) async {
    try {
      final prompt = '''
You are a creative title generator for children's stories. 

Given this story:
"$story"

Create a short, magical, kid-friendly title (3-6 words maximum) that captures the essence of the story.

Requirements:
- Simple words a 6-year-old can understand
- Magical and engaging
- No more than 6 words
- Should make kids excited to read/hear the story
- Avoid generic titles like "The Story of..." or "A Tale of..."

Examples of good titles:
- "Luna's Magic Garden"
- "The Singing Tree"
- "Rainbow Bridge Adventure"
- "Sparkle the Brave Dragon"

Return ONLY the title, nothing else.
''';

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [{
            'parts': [{
              'text': prompt
            }]
          }],
          'generationConfig': {
            'temperature': 0.8,
            'topK': 40,
            'topP': 0.9,
            'maxOutputTokens': 50,
            'candidateCount': 1,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          String title = data['candidates'][0]['content']['parts'][0]['text'].trim();
          
          // Remove any JSON formatting
          title = title.replaceAll(RegExp(r'\{[^}]*\}'), '');
          title = title.replaceAll(RegExp(r'\[[^\]]*\]'), '');
          
          // Remove quotes if present
          title = title.replaceAll('"', '').replaceAll("'", '');
          
          // Remove common unwanted prefixes/suffixes
          title = title.replaceAll(RegExp(r'^(Title:|Story Title:|Name:)\s*', caseSensitive: false), '');
          
          // Clean up extra whitespace
          title = title.replaceAll(RegExp(r'\s+'), ' ').trim();
          
          // Ensure it's not too long
          if (title.split(' ').length > 6) {
            title = title.split(' ').take(6).join(' ');
          }
          
          return title.isNotEmpty ? title : 'My Magical Story';
        } else {
          return 'My Magical Story';
        }
      } else {
        print('Error generating title: ${response.statusCode} - ${response.body}');
        return 'My Magical Story';
      }
    } catch (e) {
      print('Error generating story title: $e');
      return 'My Magical Story';
    }
  }

  Future<String> generateImageFromStory({
    required String story,
  }) async {
    try {
      // Step 1: Request image generation from your backend
      final response = await http.post(
        Uri.parse('https://story-buddy-backend.onrender.com/get_image?api=$_backendApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image_desc': story,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Step 2: Extract the image_id from the response
        if (data['image_id'] != null) {
          final imageId = data['image_id'];
          
          // Step 3: Construct the full image URL using the image_id
          final imageUrl = 'https://story-buddy-backend.onrender.com/images/$imageId';
          
          return imageUrl;
        } else {
          throw Exception('No image_id received from backend');
        }
      } else {
        throw Exception('Failed to generate image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating image: $e');
    }
  }

  Future<String> generateTeacherStory(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [{
            'parts': [{
              'text': prompt
            }]
          }],
          'generationConfig': {
            'temperature': 0.8,
            'topK': 40,
            'topP': 0.9,
            'maxOutputTokens': 1024,
            'candidateCount': 1,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          throw Exception('No story content received from Gemini API');
        }
      } else {
        throw Exception('Failed to generate teacher story: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating teacher story: $e');
    }
  }

  Future<Map<String, dynamic>> generateAdventurePart({
    required List<String> storySoFar,
    String? lastChoice,
  }) async {
    try {
      final storyContext = storySoFar.isEmpty ? '(start)' : storySoFar.join('\n');
      final choiceText = (lastChoice ?? '').isEmpty ? 'None (first part)' : lastChoice;
      final prompt = '''
You are a playful storyteller for children.
Story so far:
$storyContext

The child chose: "$choiceText"

Write the next part of the adventure:
- One short paragraph (1-3 sentences)
- Each sentence 10 words or fewer
- Use only 1-3 syllable words
- Keep it magical and kind

After the paragraph, list three choices for what the hero can do next.

Return ONLY valid JSON exactly in this format:
{
  "paragraph": "<paragraph>",
  "options": ["choice one", "choice two", "choice three"]
}
''';

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.9,
            'topK': 40,
            'topP': 0.9,
            'maxOutputTokens': 256,
            'candidateCount': 1,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final text = data['candidates'][0]['content']['parts'][0]['text'];
          // Attempt to locate first JSON block in text
          final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
          if (jsonMatch != null) {
            final jsonString = jsonMatch.group(0);
            if (jsonString != null) {
              final parsed = jsonDecode(jsonString);
              // Validate structure
              if (parsed is Map && parsed['paragraph'] != null && parsed['options'] is List) {
                return {
                  'paragraph': parsed['paragraph'] as String,
                  'options': List<String>.from(parsed['options'] as List),
                };
              }
            }
          }
          // Fallback: treat entire text as paragraph and split lines for options
          final lines = text.trim().split('\n');
          final paragraph = lines.first.trim();
          final options = lines.skip(1).where((l) => l.trim().isNotEmpty).take(3).map((e) => e.replaceAll(RegExp(r'^[0-9]+[).\-]\s*'), '').trim()).toList();
          return {
            'paragraph': paragraph,
            'options': options.isNotEmpty ? options : ['Continue', 'Look around', 'Ask for help'],
          };
        } else {
          throw Exception('No content from Gemini');
        }
      } else {
        throw Exception('Gemini API error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating adventure part: $e');
    }
  }
} 