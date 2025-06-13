import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/gemini_service.dart';
import 'teacher_story_detail_screen.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final GeminiService _geminiService = GeminiService();
  
  // Form controllers
  final _moodController = TextEditingController();
  final _weatherController = TextEditingController();
  final _eventController = TextEditingController();
  final _changeController = TextEditingController();
  
  // Selection states
  String? _selectedClass;
  List<String> _selectedStudents = [];
  bool _isAllStudents = true;
  bool _isGenerating = false;
  List<String> _selectedEmotions = [];
  
  // Sample data - in real app this would come from API
  final List<Map<String, dynamic>> _classes = [
    {
      'id': 'class_1',
      'name': 'Morning Reading',
      'grade': '3rd Grade',
      'students': ['Emma S.', 'Liam K.', 'Sophia M.', 'Noah P.', 'Olivia R.']
    },
    {
      'id': 'class_2',
      'name': 'Creative Stories',
      'grade': '4th Grade',
      'students': ['Alex T.', 'Maya L.', 'James W.', 'Isabella C.', 'Lucas D.']
    },
    {
      'id': 'class_3',
      'name': 'Adventure Tales',
      'grade': '5th Grade',
      'students': ['Zoe M.', 'Ethan B.', 'Ava H.', 'Mason R.', 'Chloe F.']
    },
  ];

  // Emotion options for selection
  final List<Map<String, dynamic>> _emotions = [
    {'name': 'Empathy', 'icon': Icons.favorite, 'color': const Color(0xFFE91E63)}, // Vibrant Pink
    {'name': 'Resilience', 'icon': Icons.shield, 'color': const Color(0xFF2196F3)}, // Bright Blue
    {'name': 'Kindness', 'icon': Icons.star, 'color': const Color(0xFFFFC107)}, // Golden Yellow
    {'name': 'Confidence', 'icon': Icons.psychology, 'color': const Color(0xFF9C27B0)}, // Rich Purple
    {'name': 'Friendship', 'icon': Icons.people, 'color': const Color(0xFF4CAF50)}, // Fresh Green
    {'name': 'Courage', 'icon': Icons.bolt, 'color': const Color(0xFFFF5722)}, // Bold Orange-Red
    {'name': 'Patience', 'icon': Icons.schedule, 'color': const Color(0xFF00BCD4)}, // Cyan
    {'name': 'Gratitude', 'icon': Icons.celebration, 'color': const Color(0xFFFF9800)}, // Warm Orange
    {'name': 'Curiosity', 'icon': Icons.search, 'color': const Color(0xFF3F51B5)}, // Deep Indigo
  ];

  @override
  void dispose() {
    _moodController.dispose();
    _weatherController.dispose();
    _eventController.dispose();
    _changeController.dispose();
    super.dispose();
  }

  List<String> get _currentStudents {
    if (_selectedClass == null) return [];
    final classData = _classes.firstWhere((c) => c['id'] == _selectedClass);
    return List<String>.from(classData['students']);
  }

  String get _selectedStudentsText {
    if (_isAllStudents) return 'All Students';
    if (_selectedStudents.isEmpty) return 'Select Students';
    if (_selectedStudents.length == 1) return _selectedStudents.first;
    return '${_selectedStudents.length} students selected';
  }

  void _toggleEmotion(String emotionName) {
    setState(() {
      if (_selectedEmotions.contains(emotionName)) {
        _selectedEmotions.remove(emotionName);
      } else if (_selectedEmotions.length < 2) {
        _selectedEmotions.add(emotionName);
      } else {
        // Show message that only 2 emotions can be selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You can only select up to 2 emotions'),
            backgroundColor: Color(0xFF6B73FF),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  Future<void> _generateStory() async {
    if (!_formKey.currentState!.validate() || _selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and select a class'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // Create teacher-specific prompt
      final prompt = _buildTeacherPrompt();
      
      // Generate story using Gemini
      final storyContent = await _geminiService.generateTeacherStory(prompt);
      
      // Generate story title using Gemini
      String storyTitle;
      try {
        storyTitle = await _geminiService.generateStoryTitle(story: storyContent);
      } catch (e) {
        print('Error generating story title: $e');
        storyTitle = 'Story for ${_getSelectedClassName()}'; // Fallback title
      }
      
      // Generate image for the story
      String? imageUrl;
      try {
        imageUrl = await _geminiService.generateImageFromStory(story: storyContent);
      } catch (e) {
        print('Error generating image: $e');
        // Continue without image
      }
      
      // Save story to backend
      try {
        await _saveStoryToBackend(
          storyName: storyTitle,
          storyContent: storyContent,
          imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
        );
      } catch (e) {
        print('Error saving story to backend: $e');
        // Continue even if backend save fails
      }
      
      // Navigate to story detail screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherStoryDetailScreen(
              storyId: 'generated_${DateTime.now().millisecondsSinceEpoch}',
              storyName: storyTitle,
              storyContent: storyContent,
              imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating story: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  String _buildTeacherPrompt() {
    final className = _getSelectedClassName();
    final studentInfo = _isAllStudents 
        ? 'the entire class' 
        : _selectedStudents.join(', ');
    final focusEmotions = _selectedEmotions.isNotEmpty 
        ? _selectedEmotions.join(' and ') 
        : 'general emotional well-being';
    
    return '''
Create a thoughtful, educational story for a teacher to share with their students. 

Context:
- Target audience: 6 year old
- Primary emotions to focus on: $focusEmotions
- Student mood today: ${_moodController.text}
- If their mood was weather: ${_weatherController.text}
- Notable event today: ${_eventController.text}
- What they might want to change: ${_changeController.text}

Please create a story that:
 Includes relatable characters that students can connect with
 Incorporates the weather/mood metaphor naturally
 Provides gentle guidance or reflection on the day's events
 Has a positive, uplifting message
 Is age-appropriate and engaging
 Helps students process their feelings and experiences
 Shows healthy ways to understand and cope with the focus emotions


Use easy words (suitable for 6-year-olds) and short sentences AND 4 paragraphs only

Gently explore why someone might feel: $focusEmotions

Include a simple event similar to: ${_eventController.text}

Show the weather as a metaphor for feelings

Introduce a friendly character who feels the same way

Help the character understand or fix the feeling/problem

End with a kind and hopeful message

Avoid narrator text like "Here's your story" — just begin the story


Written in a warm, nurturing tone that a teacher would use. Make it educational yet entertaining, with clear emotional lessons woven throughout, especially focusing on the emotions: $focusEmotions.
''';
  }

  String _getSelectedClassName() {
    if (_selectedClass == null) return '';
    final classData = _classes.firstWhere((c) => c['id'] == _selectedClass);
    return classData['name'];
  }

  Future<void> _saveStoryToBackend({
    required String storyName,
    required String storyContent,
    required String imageUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://story-buddy-backend.onrender.com/save_teacher_story'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'story_name': storyName,
          'story_content': storyContent,
          'image_url': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        print('Story saved successfully to backend');
      } else {
        throw Exception('Failed to save story: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saving story to backend: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Create Story',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              
              const SizedBox(height: 32),
              
              // Class Selection
              _buildClassSelection(),
              
              const SizedBox(height: 24),
              
              // Student Selection
              _buildStudentSelection(),
              
              const SizedBox(height: 32),
              
              // Emotion Focus Selection
              _buildEmotionSelection(),
              
              const SizedBox(height: 32),
              
              // Emotional Settings
              _buildEmotionalSettings(),
              
              const SizedBox(height: 40),
              
              // Generate Button
              _buildGenerateButton(),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '🧭',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Create a Story for Your Students',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Build a magical story to help your students reflect, feel seen, and grow.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildClassSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '👧 Select Class',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedClass,
              hint: const Text('Choose a class'),
              isExpanded: true,
              items: _classes.map((classData) {
                return DropdownMenuItem<String>(
                  value: classData['id'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        classData['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${classData['grade']} • ${classData['students'].length} students',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClass = value;
                  _selectedStudents.clear();
                  _isAllStudents = true;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Students',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectedClass != null ? _showStudentSelectionDialog : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _selectedClass != null ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedClass != null ? Colors.grey[300]! : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedClass != null ? _selectedStudentsText : 'Select a class first',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedClass != null ? const Color(0xFF2D3436) : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: _selectedClass != null ? const Color(0xFF6B73FF) : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '🎭',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Focus Emotions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_selectedEmotions.length}/2 selected',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B73FF),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Select up to 2 emotions to focus on in the story',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        
        // Emotion Carousel
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _emotions.length,
            itemBuilder: (context, index) {
              final emotion = _emotions[index];
              final isSelected = _selectedEmotions.contains(emotion['name']);
              
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _emotions.length - 1 ? 16 : 0,
                ),
                child: GestureDetector(
                  onTap: () => _toggleEmotion(emotion['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 100,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? emotion['color'].withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                            ? emotion['color']
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected 
                              ? emotion['color'].withOpacity(0.3)
                              : Colors.grey.withOpacity(0.1),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                                         child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(
                           emotion['icon'],
                           size: isSelected ? 32 : 28,
                           color: isSelected 
                               ? emotion['color']
                               : Colors.grey[600],
                         ),
                         const SizedBox(height: 8),
                         Text(
                           emotion['name'],
                           style: TextStyle(
                             fontSize: 12,
                             fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                             color: isSelected 
                                 ? emotion['color']
                                 : const Color(0xFF2D3436),
                           ),
                           textAlign: TextAlign.center,
                         ),
                         if (isSelected)
                           Container(
                             margin: const EdgeInsets.only(top: 4),
                             width: 20,
                             height: 2,
                             decoration: BoxDecoration(
                               color: emotion['color'],
                               borderRadius: BorderRadius.circular(1),
                             ),
                           ),
                       ],
                     ),
                  ),
                ),
              );
            },
          ),
        ),
        
        if (_selectedEmotions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6B73FF).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF6B73FF).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF6B73FF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Story will focus on: ${_selectedEmotions.join(' & ')}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B73FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmotionalSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '🧠',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Emotional Setting',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        _buildTextInput(
          controller: _moodController,
          label: 'How has the student (or class) been feeling today?',
          hint: 'e.g., excited, anxious, curious, tired...',
        ),
        
        const SizedBox(height: 16),
        
        _buildTextInput(
          controller: _weatherController,
          label: 'If their mood was the weather, what would it be?',
          hint: 'e.g., sunny with clouds, stormy, calm breeze...',
        ),
        
        const SizedBox(height: 16),
        
        _buildTextInput(
          controller: _eventController,
          label: 'Any event or moment that stood out today?',
          hint: 'e.g., test anxiety, friendship issue, achievement...',
        ),
        
        const SizedBox(height: 16),
        
        _buildTextInput(
          controller: _changeController,
          label: 'If they could change one thing about today, what would it be?',
          hint: 'e.g., more confidence, better focus, kindness...',
        ),
      ],
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6B73FF), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          maxLines: 2,
          minLines: 1,
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _generateStory,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B73FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isGenerating
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Generating Story...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Text(
                'Generate Story',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _showStudentSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Select Students',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // All Students option
                    CheckboxListTile(
                      title: const Text(
                        'All Students',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      value: _isAllStudents,
                      onChanged: (value) {
                        setDialogState(() {
                          _isAllStudents = value ?? false;
                          if (_isAllStudents) {
                            _selectedStudents.clear();
                          }
                        });
                      },
                      activeColor: const Color(0xFF6B73FF),
                    ),
                    
                    const Divider(),
                    
                    // Individual students
                    ...(_currentStudents.map((student) {
                      return CheckboxListTile(
                        title: Text(student),
                        value: !_isAllStudents && _selectedStudents.contains(student),
                        onChanged: _isAllStudents ? null : (value) {
                          setDialogState(() {
                            if (value == true) {
                              _selectedStudents.add(student);
                            } else {
                              _selectedStudents.remove(student);
                            }
                          });
                        },
                        activeColor: const Color(0xFF6B73FF),
                      );
                    })),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Update the main state
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B73FF),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
} 