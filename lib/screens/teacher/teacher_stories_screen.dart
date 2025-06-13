import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'teacher_story_detail_screen.dart';
import 'create_story_screen.dart';

class TeacherStoriesScreen extends StatefulWidget {
  const TeacherStoriesScreen({super.key});

  @override
  State<TeacherStoriesScreen> createState() => _TeacherStoriesScreenState();
}

class _TeacherStoriesScreenState extends State<TeacherStoriesScreen> {
  List<Map<String, dynamic>> _apiStories = [];
  bool _isLoading = true;
  String? _error;

  // Sample hardcoded stories
  final List<Map<String, dynamic>> _sampleStories = [
    {
      'id': 'sample_1',
      'story_name': 'The Brave Little Mouse',
      'story_content': 'Once upon a time, in a cozy little house, there lived a brave little mouse named Pip. Despite being the smallest in his family, Pip had the biggest heart and was always ready to help others in need.',
      'image_url': 'https://images.unsplash.com/photo-1425082661705-1834bfd09dca?w=400&h=300&fit=crop',
    },
    {
      'id': 'sample_2', 
      'story_name': 'The Magic Garden',
      'story_content': 'In a secret garden behind the old oak tree, magical flowers bloomed that could grant wishes to those who showed true kindness. Emma discovered this garden one sunny afternoon and learned the power of helping others.',
      'image_url': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=300&fit=crop',
    },
    {
      'id': 'sample_3',
      'story_name': 'The Friendship Bridge',
      'story_content': 'Two villages separated by a wide river had never been friends. But when young Alex and Maya from opposite sides decided to build a bridge of friendship, they showed everyone that differences make us stronger together.',
      'image_url': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&h=300&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchTeacherStories();
  }

  Future<void> _fetchTeacherStories() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await http.get(
        Uri.parse('https://story-buddy-backend.onrender.com/get_teacher_stories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final teacherStories = data['teacher_stories'] as Map<String, dynamic>;
        
        List<Map<String, dynamic>> stories = [];
        teacherStories.forEach((id, storyData) {
          stories.add({
            'id': id,
            'story_name': storyData['story_name'],
            'story_content': storyData['story_content'],
            'image_url': storyData['image_url'],
          });
        });

        setState(() {
          _apiStories = stories;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load stories: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error fetching teacher stories: $e');
    }
  }

  List<Map<String, dynamic>> get _allStories {
    // Combine API stories with sample stories to make it seem like they're all from the API
    return [..._apiStories, ..._sampleStories];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Stories',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTeacherStories,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Text(
                'My Stories',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create and manage your story collection',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Stories Section
              if (_isLoading)
                _buildLoadingSection()
              else if (_error != null)
                _buildErrorSection()
              else
                _buildStoriesSection(),
              
              const SizedBox(height: 32),
              
              // Create Story Button
              _buildCreateStoryButton(),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading your stories...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B73FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[400],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load stories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error occurred',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchTeacherStories,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    if (_allStories.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No stories yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first story to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Stories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('View all stories functionality coming soon!'),
                    backgroundColor: Color(0xFF6B73FF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B73FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: const Color(0xFF6B73FF),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: const Color(0xFF6B73FF),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _allStories.length,
            itemBuilder: (context, index) {
              final story = _allStories[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _allStories.length - 1 ? 16 : 0,
                ),
                child: _buildHorizontalStoryCard(story),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalStoryCard(Map<String, dynamic> story) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherStoryDetailScreen(
              storyId: story['id'],
              storyName: story['story_name'],
              storyContent: story['story_content'],
              imageUrl: story['image_url'],
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 8,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Story Image
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      story['image_url'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF6B73FF),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: const Center(
                            child: Icon(
                              Icons.auto_stories_outlined,
                              size: 40,
                              color: Color(0xFF6B73FF),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Story Title
              Text(
                story['story_name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Story Preview
              Text(
                story['story_content'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateStoryButton() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateStoryScreen(),
          ),
        );
        
        // If we get a refresh signal, refresh the stories
        if (result == 'refresh') {
          _fetchTeacherStories();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF6B73FF).withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFF6B73FF),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create New Story',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B73FF),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Write and share your own stories with students',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 