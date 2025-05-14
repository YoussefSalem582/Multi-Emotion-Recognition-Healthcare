import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:ui';

// Import ThemeProvider
import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  // Recent emotion data
  final List<Map<String, dynamic>> _recentEmotions = [
    {
      'name': 'Sarah Johnson',
      'emotion': 'Happy',
      'color': Colors.green,
      'percentage': 0.82,
      'time': '2 min ago',
      'avatar': 'assets/avatar1.png',
    },
    {
      'name': 'Michael Brown',
      'emotion': 'Frustrated',
      'color': Colors.orange,
      'percentage': 0.65,
      'time': '15 min ago',
      'avatar': 'assets/avatar2.png',
    },
    {
      'name': 'Emily Davis',
      'emotion': 'Neutral',
      'color': Colors.grey,
      'percentage': 0.50,
      'time': '1 hr ago',
      'avatar': 'assets/avatar3.png',
    },
  ];

  // Feature cards data
  final List<Map<String, dynamic>> _featureCards = [
    {
      'title': 'Dashboard',
      'subtitle': 'View live emotion analysis',
      'icon': Icons.dashboard_rounded,
      'color': Color(0xFF6750A4),
      'route': '/dashboard',
    },
    {
      'title': 'Record',
      'subtitle': 'Start a new recording session',
      'icon': Icons.mic_rounded,
      'color': Color(0xFF00A3B4),
      'route': '/recording',
    },
    {
      'title': 'Video',
      'subtitle': 'Analyze emotions in videos',
      'icon': Icons.videocam_rounded,
      'color': Color(0xFF8C4190),
      'route': '/videoAnalysis',
    },
    {
      'title': 'History',
      'subtitle': 'View past sessions',
      'icon': Icons.history_rounded,
      'color': Color(0xFF2A632A),
      'route': '/sessionReview',
    },
  ];

  // Carousel items
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Real-time Analysis',
      'description':
          'Detect emotions as they happen with our advanced AI technology',
      'image': 'assets/carousel1.png',
      'color': Colors.blue,
    },
    {
      'title': 'Customer Insights',
      'description':
          'Understand your customers better with detailed emotional analytics',
      'image': 'assets/carousel2.png',
      'color': Colors.purple,
    },
    {
      'title': 'Improve Service',
      'description':
          'Use emotion data to enhance your customer service quality',
      'image': 'assets/carousel3.png',
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    // Start animation
    _animationController.forward();

    // Auto-scroll carousel
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        _startCarouselTimer();
      }
    });
  }

  void _startCarouselTimer() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentPage = (_currentPage + 1) % _carouselItems.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startCarouselTimer();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            _isSearchExpanded
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search sessions, customers...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  autofocus: true,
                )
                : null,
        leading:
            _isSearchExpanded
                ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isSearchExpanded = false;
                    });
                  },
                )
                : null,
        actions: [
          if (!_isSearchExpanded)
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearchExpanded = true;
                });
              },
            ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!isDarkMode);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Show settings dialog
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    isDarkMode
                        ? [Color(0xFF2E165B), Color(0xFF1F1B24)]
                        : [Color(0xFF6750A4), Color(0xFF4A3B87)],
              ),
            ),
          ),

          // Bottom decoration
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.68,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with gradients
                  _buildHeaderSection(),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Feature cards grid
                        _buildFeatureGrid(),

                        SizedBox(height: 24),

                        // Carousel
                        _buildCarousel(),

                        SizedBox(height: 24),

                        // Recent emotions
                        _buildRecentEmotionsSection(),

                        SizedBox(height: 32),

                        // Quick stats
                        _buildQuickStats(),

                        SizedBox(height: 50), // Bottom spacing
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated app logo and title
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.5),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.0, 0.6, curve: Curves.easeOutQuart),
              ),
            ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.0, 0.6, curve: Curves.easeOutQuart),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'EmoSense AI',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Welcome text
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.3, 0.8, curve: Curves.easeOutQuart),
              ),
            ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.3, 0.8, curve: Curves.easeOutQuart),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to EmoSense',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Real-time emotion detection for better customer service',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: _featureCards.length,
      itemBuilder: (context, index) {
        final item = _featureCards[index];
        // Staggered animation
        final delay = index * 0.1;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final double animValue = Curves.easeOutQuart.transform(
              math.max(
                0,
                math.min(1, (_animationController.value - 0.4 - delay) * 2),
              ),
            );

            return Transform.scale(
              scale: 0.5 + (0.5 * animValue),
              child: Opacity(opacity: animValue, child: child),
            );
          },
          child: _buildFeatureCard(
            title: item['title'],
            subtitle: item['subtitle'],
            icon: item['icon'],
            color: item['color'],
            onTap: () => Navigator.pushNamed(context, item['route']),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withOpacity(0.1), width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Container(
                height: 36,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'EmoSense Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(
                _carouselItems.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _carouselItems.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = _carouselItems[index];
              return Card(
                elevation: 4,
                shadowColor: item['color'].withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        item['color'].withOpacity(0.8),
                        item['color'].withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                item['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Learn More',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              index == 0
                                  ? Icons.speed
                                  : index == 1
                                  ? Icons.insights
                                  : Icons.support_agent,
                              size: 36,
                              color: Colors.white,
                            ),
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
      ],
    );
  }

  Widget _buildRecentEmotionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Emotions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sessionReview');
              },
              child: Text('View All'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...List.generate(
          _recentEmotions.length,
          (index) => _buildEmotionListItem(_recentEmotions[index]),
        ),
      ],
    );
  }

  Widget _buildEmotionListItem(Map<String, dynamic> emotion) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: emotion['color'].withOpacity(0.2),
              child: Icon(Icons.person, color: emotion['color']),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        emotion['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        emotion['time'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: emotion['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.emoji_emotions,
                              size: 12,
                              color: emotion['color'],
                            ),
                            SizedBox(width: 4),
                            Text(
                              emotion['emotion'],
                              style: TextStyle(
                                fontSize: 12,
                                color: emotion['color'],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: emotion['percentage'],
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            emotion['color'],
                          ),
                          borderRadius: BorderRadius.circular(2),
                          minHeight: 4,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${(emotion['percentage'] * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: emotion['color'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Stats',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: '8',
                subtitle: 'Sessions',
                icon: Icons.history,
                color: Color(0xFF6750A4),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: '65%',
                subtitle: 'Happy',
                icon: Icons.sentiment_very_satisfied,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: '15%',
                subtitle: 'Improved',
                icon: Icons.trending_up,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
