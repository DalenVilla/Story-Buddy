import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  static const String _baseImageUrl = 'https://generativelanguage.googleapis.com/v1beta/models/imagegeneration:generateContent';

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
    
    // Vary the story opening styles
    final openings = [
      '"Once upon a time…"',
      '"In a land where clouds could sing…"',
      '"Deep in a magical forest…"',
      '"On a sunny morning when anything was possible…"',
      '"In a world filled with wonder…"',
      '"Long ago in a place where dreams come true…"',
    ];
    
    final selectedOpening = openings[random.nextInt(openings.length)];
    
    // Vary the magical elements mentioned
    final magicalElements = [
      'talking animals, enchanted places, dreamlike elements',
      'friendly magical creatures, mysterious doors, floating objects',
      'singing flowers, dancing trees, shimmering portals',
      'wise animals, magical gardens, glowing pathways',
      'helpful sprites, rainbow bridges, whispering winds',
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
- Inspire hope, curiosity, and resilience
- Include a fun, light touch of fantasy ($selectedMagical)
- Be written in simple language for a 6-year-old
- End on a positive, comforting note

Avoid moralizing or lecturing. Instead, reflect their emotional journey in a metaphorical or story-based way.

Write at a reading level for a 6-year-old:
- Use simple, age-appropriate words
- Use short sentences (10 words or fewer)
- 6 Paragraphs
- Use gentle and clear ideas they can easily understand
- No complex metaphors or long dialogue
- No introduction or explanation — **just return the story only**
- Use 1-2 syllable words ONLY.

Begin the story with an inviting line like: $selectedOpening

Keep the tone warm, playful, and emotionally supportive.

**Create something completely fresh and new. Only return the story text itself. Do not explain, introduce, or summarize it.**
then finally create an image of the whole story.
''';
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
} 