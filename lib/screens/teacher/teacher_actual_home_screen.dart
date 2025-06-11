import 'package:flutter/material.dart';
import 'teacher_classes_screen.dart';
import 'teacher_dashboard_screen.dart';

class TeacherActualHomeScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  
  const TeacherActualHomeScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Home',
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
                    '👋 Welcome back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to inspire your students today?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Quick Actions Section
            const Text(
              '📌 Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick Action Cards Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildQuickActionCard(
                  context,
                  title: 'Create a Class',
                  icon: Icons.add_circle_outline,
                  emoji: '➕',
                  color: Colors.green,
                  onTap: () => _showCreateClassDialog(context),
                ),
                _buildQuickActionCard(
                  context,
                  title: 'View Stories',
                  icon: Icons.auto_stories_outlined,
                  emoji: '📘',
                  color: Colors.blue,
                  onTap: () {
                    if (onNavigate != null) {
                      onNavigate!(3); // Navigate to Stories tab
                    }
                  },
                ),
                _buildQuickActionCard(
                  context,
                  title: 'Active Classes',
                  icon: Icons.visibility_outlined,
                  emoji: '👁',
                  color: Colors.purple,
                  onTap: () {
                    if (onNavigate != null) {
                      onNavigate!(2); // Navigate to Classes tab
                    }
                  },
                ),
                _buildQuickActionCard(
                  context,
                  title: 'Student Activity',
                  icon: Icons.inbox_outlined,
                  emoji: '📥',
                  color: Colors.orange,
                  onTap: () {
                    if (onNavigate != null) {
                      onNavigate!(1); // Navigate to Dashboard tab
                    }
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Tip of the Day Section
            const Text(
              '🧠 Tip of the Day',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTipOfTheDayCard(),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String emoji,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3436),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipOfTheDayCard() {
    final tips = [
      "💡 Try incorporating storytelling into math problems to make them more engaging for students.",
      "🌟 Encourage students to create their own story endings to boost creativity.",
      "🤝 Use group storytelling activities to improve collaboration skills.",
      "🎭 Act out story scenes with your students to make reading more interactive.",
      "📝 Have students illustrate their favorite story moments to enhance comprehension.",
      "🎨 Create story maps together to help students understand plot structure.",
      "🌈 Use different colored pens when writing stories to make the process more fun.",
    ];
    
    final random = DateTime.now().day % tips.length;
    final todaysTip = tips[random];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B73FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF6B73FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Daily Teaching Tip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            todaysTip,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
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