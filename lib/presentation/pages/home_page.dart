import '../../core/core.dart';
import '../providers/session_provider.dart';
import '../providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _carouselController = PageController(
    viewportFraction: 0.9,
  );
  int _currentCarouselPage = 0;

  // Feature cards data
  final List<Map<String, dynamic>> _featureCards = [
    {
      'title': 'Dashboard',
      'subtitle': 'View live emotion analysis',
      'icon': Icons.dashboard_rounded,
      'color': const Color(0xFF6750A4),
      'route': '/dashboard',
    },
    {
      'title': 'Record',
      'subtitle': 'Start a new recording session',
      'icon': Icons.mic_rounded,
      'color': const Color(0xFF00A3B4),
      'route': '/recording',
    },
    {
      'title': 'Video',
      'subtitle': 'Analyze emotions in videos',
      'icon': Icons.videocam_rounded,
      'color': const Color(0xFF8C4190),
      'route': '/videoAnalysis',
    },
    {
      'title': 'History',
      'subtitle': 'View past sessions',
      'icon': Icons.history_rounded,
      'color': const Color(0xFF2A632A),
      'route': '/history',
    },
  ];

  // Recent emotions data
  final List<Map<String, dynamic>> _recentEmotions = [
    {
      'customer': 'John Smith',
      'emotion': 'Happy',
      'time': '10:30 AM',
      'color': Colors.green,
    },
    {
      'customer': 'Sarah Johnson',
      'emotion': 'Frustrated',
      'time': '09:45 AM',
      'color': Colors.orange,
    },
    {
      'customer': 'Michael Brown',
      'emotion': 'Neutral',
      'time': 'Yesterday',
      'color': Colors.grey,
    },
  ];

  // Carousel items
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Real-time Analysis',
      'description': 'Detect emotions during live customer interactions',
      'icon': Icons.timer,
      'color': const Color(0xFF6750A4),
    },
    {
      'title': 'AI Recommendations',
      'description': 'Get suggestions based on detected emotions',
      'icon': Icons.lightbulb_outline,
      'color': const Color(0xFF00A3B4),
    },
    {
      'title': 'Detailed Reports',
      'description': 'View comprehensive emotion analytics',
      'icon': Icons.bar_chart,
      'color': const Color(0xFF8C4190),
    },
  ];

  @override
  void initState() {
    super.initState();
    _carouselController.addListener(() {
      int page = _carouselController.page!.round();
      if (page != _currentCarouselPage) {
        setState(() {
          _currentCarouselPage = page;
        });
      }
    });

    // Load sessions when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().loadSessions();
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF6750A4), const Color(0xFF8C4190)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const AppLogo(size: 60, showText: false),
                      const SizedBox(height: 8),
                      Text(
                            'EmoSense AI',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            curve: Curves.easeOutQuad,
                            duration: 600.ms,
                          ),
                      Text(
                        'Emotion Recognition for Customer Service',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // Show search dialog
                  showSearch(
                    context: context,
                    delegate: _EmotionSearchDelegate(),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Show settings dialog
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Settings'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.dark_mode),
                                title: Text('Dark Mode'),
                                trailing: Switch(
                                  value: isDarkMode,
                                  onChanged: (value) {
                                    themeProvider.toggleTheme();
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text('App Icon'),
                                trailing: Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/appIconDemo');
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),

          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Feature Grid
                  Text(
                    'Features',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureGrid(),

                  // Carousel
                  const SizedBox(height: 24),
                  Text(
                    'Discover EmoSense',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: _carouselController,
                      itemCount: _carouselItems.length,
                      itemBuilder: (context, index) {
                        return _buildCarouselItem(_carouselItems[index], index);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _carouselItems.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _currentCarouselPage == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.surfaceVariant,
                        ),
                      ),
                    ),
                  ),

                  // Recent emotions
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Emotions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to history page
                        },
                        child: Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  sessionProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : sessionProvider.error != null
                      ? Center(
                        child: Text(
                          'Error: ${sessionProvider.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recentEmotions.length,
                        itemBuilder: (context, index) {
                          return _buildEmotionListItem(_recentEmotions[index]);
                        },
                      ),

                  // Quick stats
                  const SizedBox(height: 24),
                  Text(
                    'Quick Stats',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildQuickStats(),
                  const SizedBox(height: 24),
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
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

        return Animate(
          effects: [
            FadeEffect(delay: Duration(milliseconds: (300 * delay).toInt())),
            SlideEffect(
              delay: Duration(milliseconds: (300 * delay).toInt()),
              begin: const Offset(0, 0.2),
              end: const Offset(0, 0),
              curve: Curves.easeOutQuad,
            ),
          ],
          child: _buildFeatureCard(
            title: item['title'],
            subtitle: item['subtitle'],
            icon: item['icon'],
            color: item['color'],
            onTap: () {
              // Navigate to feature
              if (item['route'] != null) {
                Navigator.pushNamed(context, item['route']);
              }
            },
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              SizedBox(
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

  Widget _buildCarouselItem(Map<String, dynamic> item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 4,
        shadowColor: item['color'].withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [item['color'], item['color'].withOpacity(0.7)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: item['color'],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: const Text('Learn more'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'], color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionListItem(Map<String, dynamic> emotion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        emotion['customer'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        emotion['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: emotion['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          emotion['emotion'],
                          style: TextStyle(
                            color: emotion['color'],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                // Navigate to session details
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Happy',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '68%',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Most common',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.people_alt_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Sessions',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '24',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'This week',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmotionSearchDelegate extends SearchDelegate<String> {
  final List<String> _emotions = [
    'Happy',
    'Sad',
    'Angry',
    'Neutral',
    'Frustrated',
    'Confused',
    'Surprised',
    'Fearful',
    'Disgusted',
  ];

  final List<String> _customers = [
    'John Smith',
    'Sarah Johnson',
    'Michael Brown',
    'Emily Davis',
    'David Wilson',
    'Jennifer Martinez',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    // Filter based on query
    final emotionResults =
        _emotions
            .where((e) => e.toLowerCase().contains(query.toLowerCase()))
            .toList();

    final customerResults =
        _customers
            .where((c) => c.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (query.isNotEmpty && emotionResults.isNotEmpty) ...[
              const Text(
                'Emotions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...emotionResults.map(
                (emotion) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getEmotionColor(emotion).withOpacity(0.2),
                    child: Icon(
                      _getEmotionIcon(emotion),
                      color: _getEmotionColor(emotion),
                    ),
                  ),
                  title: Text(emotion),
                  onTap: () {
                    // Handle emotion selection
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (query.isNotEmpty && customerResults.isNotEmpty) ...[
              const Text(
                'Customers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...customerResults.map(
                (customer) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  title: Text(customer),
                  onTap: () {
                    // Handle customer selection
                  },
                ),
              ),
            ],

            if (query.isNotEmpty &&
                emotionResults.isEmpty &&
                customerResults.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'No results found',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      case 'neutral':
        return Icons.sentiment_neutral;
      case 'frustrated':
        return Icons.sentiment_dissatisfied;
      case 'confused':
        return Icons.psychology;
      case 'surprised':
        return Icons.emoji_emotions;
      case 'fearful':
        return Icons.sentiment_very_dissatisfied;
      case 'disgusted':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.emoji_emotions;
    }
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return Colors.green;
      case 'sad':
        return Colors.blue;
      case 'angry':
        return Colors.red;
      case 'neutral':
        return Colors.grey;
      case 'frustrated':
        return Colors.orange;
      case 'confused':
        return Colors.purple;
      case 'surprised':
        return Colors.amber;
      case 'fearful':
        return Colors.deepPurple;
      case 'disgusted':
        return Colors.brown;
      default:
        return Colors.teal;
    }
  }
}
