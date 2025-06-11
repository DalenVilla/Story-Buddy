import 'package:flutter/material.dart';
import 'student_home_screen.dart';

class StudentOnboardingScreen extends StatefulWidget {
  final String studentName;
  final String className;
  final String teacherName;
  final String grade;
  final String classCode;
  
  const StudentOnboardingScreen({
    super.key,
    required this.studentName,
    required this.className,
    required this.teacherName,
    required this.grade,
    required this.classCode,
  });

  @override
  State<StudentOnboardingScreen> createState() => _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState extends State<StudentOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _slideController;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> emotionThemes = [
    {'name': 'Kindness', 'icon': Icons.favorite, 'color': Colors.pink},
    {'name': 'Courage', 'icon': Icons.bolt, 'color': Colors.orange},
    {'name': 'Friendship', 'icon': Icons.people, 'color': Colors.green},
    {'name': 'Curiosity', 'icon': Icons.search, 'color': Colors.blue},
    {'name': 'Empathy', 'icon': Icons.psychology, 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _bounceController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B73FF),
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6B73FF),
                  Color(0xFF9B59B6),
                ],
              ),
            ),
            child: Column(
              children: [
                // Top confetti and celebration area
                Container(
                  height: 120,
                  child: Stack(
                    children: [
                      // Confetti effects (simple positioned containers)
                      ..._buildConfetti(),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.celebration,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Welcome to the Class!',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main content area
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Class confirmation
                          _buildClassConfirmation(),
                          
                          const SizedBox(height: 32),
                          
                          // Student name welcome
                          _buildStudentWelcome(),
                          
                          const SizedBox(height: 32),
                          
                          // Emotion themes
                          _buildEmotionThemes(),
                          
                          const SizedBox(height: 32),
                          
                          // Mascot and message
                          _buildMascotSection(),
                          
                          const SizedBox(height: 32),
                          
                          // Start story button
                          _buildStartButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildConfetti() {
    return [
      Positioned(top: 20, left: 30, child: _buildConfettiPiece(Colors.yellow, 8)),
      Positioned(top: 40, left: 80, child: _buildConfettiPiece(Colors.pink, 6)),
      Positioned(top: 15, right: 40, child: _buildConfettiPiece(Colors.green, 10)),
      Positioned(top: 50, right: 100, child: _buildConfettiPiece(Colors.orange, 7)),
      Positioned(top: 30, left: 150, child: _buildConfettiPiece(Colors.blue, 9)),
      Positioned(top: 45, right: 200, child: _buildConfettiPiece(Colors.purple, 5)),
    ];
  }

  Widget _buildConfettiPiece(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildClassConfirmation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6B73FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6B73FF).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: const Color(0xFF6B73FF),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Class Confirmed!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B73FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome to ${widget.teacherName}\'s ${widget.grade}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3436),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.className,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentWelcome() {
    return Column(
      children: [
        Text(
          'Hi there,',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.studentName,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'We\'re so excited to have you!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmotionThemes() {
    return Column(
      children: [
        Text(
          'In this class, we\'ll explore:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: emotionThemes.map((emotion) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: (emotion['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (emotion['color'] as Color).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    emotion['icon'] as IconData,
                    color: emotion['color'] as Color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    emotion['name'] as String,
                    style: TextStyle(
                      color: emotion['color'] as Color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMascotSection() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '"Let\'s explore how you feel with awesome stories!"',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[800],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '- Buddy the Story Bear 🐻',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StorytimeHomeScreen(
                studentName: widget.studentName.split(' ').first, // Just first name for greeting
                teacherName: widget.teacherName,
                grade: widget.grade,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B73FF),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xFF6B73FF).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Start My First Story!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 