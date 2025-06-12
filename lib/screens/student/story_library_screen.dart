import 'package:flutter/material.dart';

class StoryLibraryScreen extends StatelessWidget {
  const StoryLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B73FF),
              Color(0xFF9B59B6),
              Color(0xFFFF6B9D),
              Color(0xFFFFA726),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Column(
                      children: [
                        Text(
                          '📚✨',
                          style: TextStyle(fontSize: 32),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Story Library',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              
              // Main content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fun welcome message

            
            // My Teacher Stories
            const Text(
              'Teacher Stories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 240,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStoryCard(
                    'The Magical Treehouse',
                    _buildTreehouseIllustration(),
                    const LinearGradient(
                      colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStoryCard(
                    'Adventures with Buddy',
                    _buildBuddyIllustration(),
                    const LinearGradient(
                      colors: [Color(0xFF98FB98), Color(0xFF90EE90)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStoryCard(
                    'The Wonder Garden',
                    _buildGardenIllustration(),
                    const LinearGradient(
                      colors: [Color(0xFFFFB6C1), Color(0xFFFF69B4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStoryCard(
                    'Space Explorer',
                    _buildSpaceIllustration(),
                    const LinearGradient(
                      colors: [Color(0xFF87CEEB), Color(0xFF4169E1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // My Stories
            const Text(
              'My Stories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 240,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStoryCard(
                    'Coming Soon!',
                    _buildComingSoonIllustration(),
                    const LinearGradient(
                      colors: [Color(0xFFFFF59D), Color(0xFFFFEB3B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStoryCard(
                    'Story #2',
                    _buildComingSoonIllustration(),
                    const LinearGradient(
                      colors: [Color(0xFFE1BEE7), Color(0xFFBA68C8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStoryCard(
                    'Story #3',
                    _buildComingSoonIllustration(),
                    const LinearGradient(
                      colors: [Color(0xFFB39DDB), Color(0xFF9575CD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ],
              ),
            ),
            
                         const SizedBox(height: 32),
                       ],
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }

  Widget _buildStoryCard(String title, Widget illustration, LinearGradient gradient) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        gradient: gradient,
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Story illustration
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: illustration,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreehouseIllustration() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          // Background trees
          const Positioned(
            left: 10,
            top: 20,
            child: Text('🌳', style: TextStyle(fontSize: 24)),
          ),
          const Positioned(
            right: 10,
            top: 15,
            child: Text('🌲', style: TextStyle(fontSize: 20)),
          ),
          // Main treehouse
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Treehouse
                Container(
                  width: 70,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD2691E), Color(0xFF8B4513)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🏠', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('👦', style: TextStyle(fontSize: 12)),
                          Text('🧸', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Tree trunk
                Container(
                  width: 20,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B4513),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Floating sparkles
          const Positioned(
            left: 5,
            top: 5,
            child: Text('✨', style: TextStyle(fontSize: 12)),
          ),
          const Positioned(
            right: 5,
            bottom: 10,
            child: Text('⭐', style: TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyIllustration() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          // Background elements
          const Positioned(
            left: 5,
            top: 10,
            child: Text('🌤️', style: TextStyle(fontSize: 16)),
          ),
          const Positioned(
            right: 8,
            top: 5,
            child: Text('🦋', style: TextStyle(fontSize: 14)),
          ),
          // Main scene
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Girl and dog adventure
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Girl
                    Container(
                      width: 35,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('👧', style: TextStyle(fontSize: 16)),
                          Text('🎒', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Dog
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('🐕', style: TextStyle(fontSize: 28)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Adventure path
                Container(
                  width: 80,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFEB3B), Color(0xFFFFC107)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Adventure sparkles
          const Positioned(
            left: 15,
            bottom: 15,
            child: Text('✨', style: TextStyle(fontSize: 10)),
          ),
          const Positioned(
            right: 15,
            bottom: 20,
            child: Text('💫', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('🌻', style: TextStyle(fontSize: 24)),
              Text('🌸', style: TextStyle(fontSize: 24)),
              Text('🌺', style: TextStyle(fontSize: 24)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('🌿', style: TextStyle(fontSize: 20)),
              Text('🦋', style: TextStyle(fontSize: 20)),
              Text('🌿', style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🚀', style: TextStyle(fontSize: 32)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('⭐', style: TextStyle(fontSize: 16)),
              Text('🌙', style: TextStyle(fontSize: 20)),
              Text('⭐', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.grey[400]!,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 