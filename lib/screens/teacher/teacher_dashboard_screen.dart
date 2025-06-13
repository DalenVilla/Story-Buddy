import 'package:flutter/material.dart';
import 'teacher_classes_screen.dart';

class TeacherDashboardScreen extends StatelessWidget {
  final VoidCallback? onNavigateToClasses;
  
  const TeacherDashboardScreen({super.key, this.onNavigateToClasses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Teacher Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back, Teacher!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your classes and inspire students',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Emotional Trends
            const Text(
              'Emotional Trends',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'This Week\'s Emotion Patterns',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            _buildEmotionalTrendsChart(),
            
            const SizedBox(height: 32),
            
            // Quick Stats
            const Text(
              'Quick Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (onNavigateToClasses != null) {
                        onNavigateToClasses!();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherClassesScreen(),
                          ),
                        );
                      }
                    },
                    child: _buildStatCard(
                      'Active Classes',
                      '3',
                      Icons.class_outlined,
                      Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total Students',
                    '24',
                    Icons.people_outline,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Stories Created',
                    '12',
                    Icons.auto_stories_outlined,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'View Stats',
                    '15',
                    Icons.analytics_outlined,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Recent Activity
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildActivityCard(
              'New student joined Class 3A',
              '2 hours ago',
              Icons.person_add_outlined,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildActivityCard(
              'Story "Space Adventure" completed',
              '4 hours ago',
              Icons.check_circle_outline,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildActivityCard(
              'Assignment graded for Class 2B',
              '1 day ago',
              Icons.grade_outlined,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionalTrendsChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Joy', Colors.amber[600]!),
              _buildLegendItem('Sadness', Colors.blue[600]!),
              _buildLegendItem('Anxiety', Colors.red[600]!),
              _buildLegendItem('Anger', Colors.orange[600]!),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Chart Area
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: EmotionalTrendsPainter(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Days of the week labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Mon', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Tue', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Wed', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Thu', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Fri', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Sat', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Sun', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String emotion, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          emotion,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  void _showCreateClassDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CreateClassWizard();
      },
    );
  }
}

class CreateClassWizard extends StatefulWidget {
  const CreateClassWizard({super.key});

  @override
  State<CreateClassWizard> createState() => _CreateClassWizardState();
}

class _CreateClassWizardState extends State<CreateClassWizard> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Step 1 - Basic Info
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  String _selectedGrade = 'Kindergarten';
  
  // Step 2 - Emotions
  List<String> _selectedEmotions = [];
  
  // Step 3 - Class Code (generated)
  String _generatedClassCode = '';

  final List<String> _grades = [
    'Kindergarten',
    '1st Grade',
    '2nd Grade',
    '3rd Grade',
    '4th Grade',
    '5th Grade',
    '6th Grade'
  ];



  final List<Map<String, dynamic>> _allEmotions = [
    {'name': 'Empathy', 'icon': Icons.favorite, 'color': Colors.pink},
    {'name': 'Resilience', 'icon': Icons.shield, 'color': Colors.blue},
    {'name': 'Kindness', 'icon': Icons.star, 'color': Colors.amber},
    {'name': 'Confidence', 'icon': Icons.psychology, 'color': Colors.purple},
    {'name': 'Friendship', 'icon': Icons.people, 'color': Colors.green},
    {'name': 'Courage', 'icon': Icons.bolt, 'color': Colors.red},
    {'name': 'Patience', 'icon': Icons.schedule, 'color': Colors.teal},
    {'name': 'Gratitude', 'icon': Icons.celebration, 'color': Colors.orange},
    {'name': 'Curiosity', 'icon': Icons.search, 'color': Colors.indigo},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _classNameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate basic info form
      if (_formKey.currentState!.validate()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentStep == 1) {
      // Validate emotions selection
      if (_selectedEmotions.isNotEmpty) {
        // Generate class code
        _generatedClassCode = _generateClassCode();
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _generateClassCode() {
    // Generate a simple 6-character class code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(6, (index) => chars.codeUnitAt(
        (DateTime.now().millisecondsSinceEpoch + index) % chars.length
      ))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // Header with progress indicators
            _buildHeader(),
            const SizedBox(height: 24),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(),
                  _buildEmotionsStep(),
                  _buildClassCodeStep(),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.class_outlined,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Create New Class',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ),
            if (_currentStep < 2)
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                color: Colors.grey[400],
              ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Progress indicators
        Row(
          children: [
            _buildProgressIndicator(0, 'Basic Info'),
            Expanded(child: Container(height: 2, color: Colors.grey[300])),
            _buildProgressIndicator(1, 'Emotions'),
            Expanded(child: Container(height: 2, color: Colors.grey[300])),
            _buildProgressIndicator(2, 'Complete'),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF6B73FF) : Colors.grey[300],
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF6B73FF) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Class Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the basic details for your new class',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          TextFormField(
            controller: _classNameController,
            decoration: InputDecoration(
              labelText: 'Class Name',
              hintText: 'e.g., Morning Reading',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF6B73FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a class name';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          DropdownButtonFormField<String>(
            value: _selectedGrade,
            decoration: InputDecoration(
              labelText: 'Grade Level',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF6B73FF),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            items: _grades.map((String grade) {
              return DropdownMenuItem<String>(
                value: grade,
                child: Text(grade),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGrade = newValue!;
              });
            },
          ),
          
          const SizedBox(height: 20),
          

        ],
      ),
    );
  }

  Widget _buildEmotionsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emotional Focus',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select 1-3 emotional themes for your class (${_selectedEmotions.length}/3 selected)',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _allEmotions.map((emotion) {
                final emotionName = emotion['name'] as String;
                final isSelected = _selectedEmotions.contains(emotionName);
                final canSelect = _selectedEmotions.length < 3 || isSelected;

                return GestureDetector(
                  onTap: canSelect ? () {
                    setState(() {
                      if (isSelected) {
                        _selectedEmotions.remove(emotionName);
                      } else {
                        if (_selectedEmotions.length < 3) {
                          _selectedEmotions.add(emotionName);
                        }
                      }
                    });
                  } : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (emotion['color'] as Color).withOpacity(0.2)
                          : Colors.grey[50],
                      border: Border.all(
                        color: isSelected
                            ? emotion['color'] as Color
                            : canSelect
                                ? Colors.grey[300]!
                                : Colors.grey[200]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          emotion['icon'] as IconData,
                          color: isSelected || canSelect
                              ? emotion['color'] as Color
                              : Colors.grey[400],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          emotionName,
                          style: TextStyle(
                            color: isSelected
                                ? emotion['color'] as Color
                                : canSelect
                                    ? const Color(0xFF2D3436)
                                    : Colors.grey[400],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle,
                            color: emotion['color'] as Color,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        if (_selectedEmotions.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Please select at least one emotional theme',
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildClassCodeStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6B73FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF6B73FF),
              size: 48,
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Class Created Successfully!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'Your class "${_classNameController.text}" has been created.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                const Text(
                  'Class Code',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _generatedClassCode,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B73FF),
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Share this code with your students so they can join your class',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    if (_currentStep == 2) {
      // Final step - only Close button
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Class "${_classNameController.text}" created! Code: $_generatedClassCode',
                ),
                backgroundColor: const Color(0xFF6B73FF),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B73FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Close',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Text(
                'Previous',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        
        if (_currentStep > 0) const SizedBox(width: 16),
        
        Expanded(
          child: ElevatedButton(
            onPressed: _currentStep == 0 
                ? _nextStep
                : _selectedEmotions.isNotEmpty 
                    ? _nextStep
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              _currentStep == 0 ? 'Next' : 'Finish',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        if (_currentStep == 0)
          const SizedBox(width: 16),
        
        if (_currentStep == 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class EmotionalTrendsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sample data for emotions over the week (0-7 scale)
    final Map<String, List<double>> emotionData = {
      'Joy': [3.5, 4.2, 5.1, 6.0, 6.5, 5.8, 5.2],
      'Sadness': [2.1, 2.8, 3.2, 2.5, 1.8, 2.1, 2.6],
      'Anxiety': [4.8, 3.9, 4.5, 3.2, 2.8, 3.5, 3.1],
      'Anger': [1.5, 2.1, 2.8, 3.5, 2.9, 2.2, 1.8],
    };

    final Map<String, Color> emotionColors = {
      'Joy': const Color(0xFFFFC107),
      'Sadness': const Color(0xFF2196F3),
      'Anxiety': const Color(0xFFF44336),
      'Anger': const Color(0xFFFF9800),
    };

    // Draw subtle grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 0.5;

    for (int i = 1; i <= 6; i++) {
      final y = size.height - (i * size.height / 7);
      canvas.drawLine(
        Offset(20, y),
        Offset(size.width - 10, y),
        gridPaint,
      );
    }

    // Draw Y-axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 7; i++) {
      final y = size.height - (i * size.height / 7);
      textPainter.text = TextSpan(
        text: i.toString(),
        style: const TextStyle(
          fontSize: 10,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - 5));
    }

    // Draw emotion curves with gradient fills
    emotionData.forEach((emotion, values) {
      final color = emotionColors[emotion]!;
      
      // Create smooth curve path
      final curvePath = _createSmoothCurve(values, size);
      
      // Draw gradient fill under the curve
      final fillPath = Path.from(curvePath);
      fillPath.lineTo(size.width - 10, size.height);
      fillPath.lineTo(20, size.height);
      fillPath.close();
      
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.05),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      canvas.drawPath(fillPath, gradientPaint);
      
      // Draw the smooth curve line
      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      
      canvas.drawPath(curvePath, linePaint);
      
      // Draw data points with glow effect
      for (int i = 0; i < values.length; i++) {
        final x = 20 + (i * (size.width - 30) / (values.length - 1));
        final y = size.height - (values[i] * size.height / 7);
        
        // Glow effect
        final glowPaint = Paint()
          ..color = color.withOpacity(0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 6, glowPaint);
        
        // Main point
        final pointPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 4, pointPaint);
        
        // Inner point
        final innerPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 2.5, innerPaint);
      }
    });
  }

  Path _createSmoothCurve(List<double> values, Size size) {
    final path = Path();
    final points = <Offset>[];
    
    // Convert data to points
    for (int i = 0; i < values.length; i++) {
      final x = 20 + (i * (size.width - 30) / (values.length - 1));
      final y = size.height - (values[i] * size.height / 7);
      points.add(Offset(x, y));
    }
    
    if (points.isEmpty) return path;
    
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      
      // Calculate control points for smooth curve
      final controlPoint1 = Offset(
        current.dx + (next.dx - current.dx) * 0.3,
        current.dy,
      );
      final controlPoint2 = Offset(
        next.dx - (next.dx - current.dx) * 0.3,
        next.dy,
      );
      
      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        next.dx, next.dy,
      );
    }
    
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
