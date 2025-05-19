import 'package:flutter/material.dart';
import 'screens/video_analysis_page.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';

// Theme provider that manages app-wide theme state
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: Color(0xFF6750A4),
      brightness: Brightness.light,
    ).copyWith(
      secondary: Color(0xFF03DAC6),
      tertiary: Color(0xFFEF5350),
      // Custom colors with better contrast
      surfaceVariant: Color(0xFFE7E0EC),
      primaryContainer: Color(0xFFEADDFF),
      secondaryContainer: Color(0xFFCEF6EC),
      // Improved text contrast
      onSurfaceVariant: Color(0xFF49454F),
      onBackground: Color(0xFF1C1B1F),
      onSurface: Color(0xFF1C1B1F),
    );

    final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: Color(0xFFD0BCFF),
      brightness: Brightness.dark,
    ).copyWith(
      secondary: Color(0xFF03DAC6),
      tertiary: Color(0xFFEF5350),
      // Enhanced dark mode colors
      surface: Color(0xFF1C1B1F),
      background: Color(0xFF121212),
      primaryContainer: Color(0xFF4F378B),
      secondaryContainer: Color(0xFF064B40),
      surfaceVariant: Color(0xFF49454F),
    );

    return MaterialApp(
      title: 'EmoSense AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
            fontSize: 34.0,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
          bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF6750A4), width: 2),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 2,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF6750A4),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6750A4),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF6750A4),
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6750A4),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xFF6750A4),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3, color: Color(0xFF6750A4)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        fontFamily: 'Roboto',
        cardTheme: CardTheme(
          elevation: 4,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Color(0xFF1C1B1F),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return Color(0xFFD0BCFF);
            }
            return Colors.grey.shade400;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return Color(0xFF4F378B);
            }
            return Colors.grey.shade800;
          }),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
            fontSize: 34.0,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
          bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade900,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade800),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFD0BCFF), width: 2),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 2,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFFD0BCFF),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD0BCFF),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFD0BCFF),
          unselectedItemColor: Colors.grey.shade500,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          backgroundColor: Color(0xFF1C1B1F),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD0BCFF),
          foregroundColor: Colors.black,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xFFD0BCFF),
          unselectedLabelColor: Colors.grey.shade500,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3, color: Color(0xFFD0BCFF)),
          ),
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: MainNavigationScreen(),
      routes: {
        '/sessionReview': (context) => SessionReviewPage(),
        '/recording': (context) => RecordingPage(),
        '/videoAnalysis': (context) => VideoAnalysisPage(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _themeAnimationController;
  late Animation<double> _themeAnimation;
  bool _showThemeIndicator = false;

  final List<Widget> _screens = [
    HomePage(),
    DashboardPage(),
    RecordingPage(),
    SessionReviewPage(),
  ];

  final List<String> _titles = ['Home', 'Dashboard', 'Recording', 'History'];

  @override
  void initState() {
    super.initState();
    _themeAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _themeAnimation = CurvedAnimation(
      parent: _themeAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _themeAnimationController.dispose();
    super.dispose();
  }

  void _toggleTheme(ThemeProvider themeProvider) {
    // Start animation in the appropriate direction
    if (themeProvider.isDarkMode) {
      _themeAnimationController.forward();
    } else {
      _themeAnimationController.reverse();
    }

    // Toggle theme
    themeProvider.toggleTheme(!themeProvider.isDarkMode);

    // Show theme indicator
    setState(() {
      _showThemeIndicator = true;
    });

    // Hide theme indicator after delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showThemeIndicator = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set animation value based on theme mode
    if (themeProvider.isDarkMode && _themeAnimationController.value == 0) {
      _themeAnimationController.value = 1;
    } else if (!themeProvider.isDarkMode &&
        _themeAnimationController.value == 1) {
      _themeAnimationController.value = 0;
    }

    // Home screen doesn't need an app bar
    final bool showAppBar = _currentIndex != 0;

    return Scaffold(
      appBar:
          showAppBar
              ? AppBar(
                title: Text(_titles[_currentIndex]),
                actions: [
                  AnimatedBuilder(
                    animation: _themeAnimation,
                    builder: (context, child) {
                      return IconButton(
                        icon: AnimatedCrossFade(
                          firstChild: Icon(Icons.dark_mode),
                          secondChild: Icon(Icons.light_mode),
                          crossFadeState:
                              themeProvider.isDarkMode
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 300),
                        ),
                        onPressed: () => _toggleTheme(themeProvider),
                        tooltip:
                            themeProvider.isDarkMode
                                ? 'Switch to Light Mode'
                                : 'Switch to Dark Mode',
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Show settings dialog
                    },
                  ),
                ],
              )
              : null,
      body: Stack(
        children: [
          _screens[_currentIndex],
          if (_showThemeIndicator)
            ThemeModeIndicator(isDarkMode: themeProvider.isDarkMode),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_outlined),
            selectedIcon: Icon(Icons.mic),
            label: 'Record',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

// Theme mode indicator widget
class ThemeModeIndicator extends StatelessWidget {
  final bool isDarkMode;

  const ThemeModeIndicator({Key? key, required this.isDarkMode})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? Colors.grey.shade800.withOpacity(0.8)
                    : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                size: 18,
                color: isDarkMode ? Colors.amber : Colors.orange,
              ),
              SizedBox(width: 8),
              Text(
                isDarkMode ? 'Dark Mode' : 'Light Mode',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dashboard Page: Real-time Analytics
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = true;
  bool _showNotifications = true;
  String _selectedTimeRange = 'Today';
  bool _isTranscribing = false;

  // Example transcription data
  final List<Map<String, dynamic>> _transcriptionData = [
    {
      'speaker': 'Customer',
      'text':
          'I have been having issues with the premium subscription features not working properly.',
      'timestamp': '00:12',
      'sentiment': 'Frustrated',
    },
    {
      'speaker': 'Agent',
      'text':
          'I am sorry to hear that. Let me check your account status right away.',
      'timestamp': '00:18',
      'sentiment': 'Neutral',
    },
    {
      'speaker': 'Customer',
      'text':
          'Thank you, I appreciate that. I have been trying to resolve this for a while.',
      'timestamp': '00:25',
      'sentiment': 'Neutral',
    },
    {
      'speaker': 'Agent',
      'text':
          'I can see the issue. There was a glitch in the system. I have fixed it and added an extra month free to your subscription.',
      'timestamp': '00:42',
      'sentiment': 'Neutral',
    },
    {
      'speaker': 'Customer',
      'text':
          'That is wonderful! Thank you so much for solving this so quickly!',
      'timestamp': '00:50',
      'sentiment': 'Happy',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Simulate loading data
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              Future.delayed(Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                _showSettingsDialog();
              } else if (value == 'export') {
                _showExportDialog();
              } else if (value == 'help') {
                _showHelpDialog();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 8),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        Icon(
                          Icons.download,
                          size: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 8),
                        Text('Export Data'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'help',
                    child: Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 8),
                        Text('Help & Guides'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildTimeRangeSelector(),
                      ),
                      TabBar(
                        tabs: [
                          Tab(text: 'Emotion Analysis'),
                          Tab(text: 'Transcription'),
                        ],
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildEmotionAnalysisTab(),
                            _buildTranscriptionTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isTranscribing)
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: FloatingActionButton.small(
                onPressed: () {
                  setState(() {
                    _isTranscribing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transcription stopped'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                backgroundColor: Colors.red,
                child: Icon(Icons.stop),
                tooltip: 'Stop Transcription',
              ),
            ),
          FloatingActionButton.extended(
            onPressed: () {
              _showRecommendationsDialog();
            },
            icon: Icon(Icons.smart_toy),
            label: Text('AI Recommendations'),
            tooltip: 'Get AI Recommendations',
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Time Range: '),
          InkWell(
            onTap: _showTimeRangeMenu,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedTimeRange,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimeRangeMenu() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem(value: 'Today', child: Text('Today')),
        PopupMenuItem(value: 'Yesterday', child: Text('Yesterday')),
        PopupMenuItem(value: 'This Week', child: Text('This Week')),
        PopupMenuItem(value: 'This Month', child: Text('This Month')),
        PopupMenuItem(value: 'Custom Range', child: Text('Custom Range')),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedTimeRange = value;
        });
      }
    });
  }

  void _showSettingsDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    bool localDarkMode = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Dashboard Settings'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: Text('Dark Mode'),
                      subtitle: Text('Use dark theme for dashboard'),
                      value: localDarkMode,
                      onChanged: (value) {
                        setState(() {
                          localDarkMode = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Notifications'),
                      subtitle: Text('Show emotion change alerts'),
                      value: _showNotifications,
                      onChanged: (value) {
                        setState(() {
                          _showNotifications = value;
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Default Time Range'),
                      subtitle: Text(_selectedTimeRange),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pop(context);
                        _showTimeRangeMenu();
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Apply settings
                      themeProvider.toggleTheme(localDarkMode);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Settings updated'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text('Apply'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Export Data'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('Export as PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Exporting as PDF...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.table_chart),
                  title: Text('Export as CSV'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Exporting as CSV...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.insert_chart),
                  title: Text('Export as Excel'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Exporting as Excel...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Dashboard Help'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHelpSection(
                    'Emotional State Analysis',
                    'Shows the current emotional state of the customer in real-time. The height of each bar represents the intensity of that emotion.',
                  ),
                  Divider(),
                  _buildHelpSection(
                    'Detailed Emotions',
                    'Shows detailed breakdown of all detected emotions with percentage values. Tap on any emotion for more details.',
                  ),
                  Divider(),
                  _buildHelpSection(
                    'AI Recommendations',
                    'The AI Recommendations button provides suggested actions based on the customer\'s current emotional state.',
                  ),
                  Divider(),
                  _buildHelpSection(
                    'Time Range',
                    'Use the time range selector to view emotion data for different time periods.',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Open detailed help
                  Navigator.pop(context);
                },
                child: Text('Full Documentation'),
              ),
            ],
          ),
    );
  }

  Widget _buildHelpSection(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(description, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showRecommendationsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.smart_toy,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text('AI Recommendations'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.withOpacity(0.2),
                    child: Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    ),
                  ),
                  title: Text('Customer is largely satisfied'),
                  subtitle: Text('Offer additional premium services'),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.withOpacity(0.2),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                    ),
                  ),
                  title: Text('Some frustration detected'),
                  subtitle: Text(
                    'Consider offering a discount or compensation',
                  ),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    child: Icon(Icons.psychology, color: Colors.blue),
                  ),
                  title: Text('Customer seems confused'),
                  subtitle: Text(
                    'Simplify your explanation or offer visual aids',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Implement the recommendations
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Implementing recommendations...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text('Apply All'),
              ),
            ],
          ),
    );
  }

  Widget _buildEmotionAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Customer: John Smith',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Call Duration: 05:23', style: TextStyle(fontSize: 14)),
          SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emotional State Analysis',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildEmotionGauge('Happy', 0.65, Colors.green),
                        _buildEmotionGauge('Frustrated', 0.25, Colors.orange),
                        _buildEmotionGauge('Angry', 0.10, Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildCustomerInsightsCard(),
          SizedBox(height: 20),
          Text(
            'Detailed Emotions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _emotionCard('Happy', 0.65, Colors.green),
          _emotionCard('Frustrated', 0.25, Colors.orange),
          _emotionCard('Angry', 0.10, Colors.red),
          _emotionCard('Confused', 0.15, Colors.blue),
          _emotionCard('Neutral', 0.20, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildTranscriptionTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Live Conversation Transcription',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isTranscribing = !_isTranscribing;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isTranscribing
                            ? 'Transcription started'
                            : 'Transcription stopped',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: Icon(_isTranscribing ? Icons.stop : Icons.mic),
                label: Text(_isTranscribing ? 'Stop' : 'Start'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isTranscribing
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Conversation',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.search, size: 20),
                                onPressed: () {},
                                tooltip: 'Search transcription',
                              ),
                              IconButton(
                                icon: Icon(Icons.download, size: 20),
                                onPressed: () {},
                                tooltip: 'Export transcription',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _transcriptionData.length,
                        itemBuilder: (context, index) {
                          final item = _transcriptionData[index];
                          final isCustomer = item['speaker'] == 'Customer';
                          final sentiment = item['sentiment'];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      isCustomer
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer
                                          : Theme.of(
                                            context,
                                          ).colorScheme.secondaryContainer,
                                  child: Icon(
                                    isCustomer
                                        ? Icons.person
                                        : Icons.support_agent,
                                    color:
                                        isCustomer
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer
                                            : Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            item['speaker'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            item['timestamp'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                            ),
                                          ),
                                          if (sentiment != 'Neutral') ...[
                                            SizedBox(width: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getSentimentColor(
                                                  sentiment,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    _getSentimentIcon(
                                                      sentiment,
                                                    ),
                                                    size: 12,
                                                    color: _getSentimentColor(
                                                      sentiment,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    sentiment,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: _getSentimentColor(
                                                        sentiment,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(item['text']),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (_isTranscribing)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Recording...',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInsightsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Customer Insights',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.info_outline, size: 20),
                  onPressed: () {
                    // Show info about insights
                  },
                  tooltip: 'About insights',
                ),
              ],
            ),
            Divider(),
            _buildInsightItem(
              icon: Icons.trending_up,
              color: Colors.green,
              title: 'Positive Trend',
              description:
                  'Customer sentiment has improved by 35% in the last 5 minutes',
            ),
            SizedBox(height: 12),
            _buildInsightItem(
              icon: Icons.repeat,
              color: Colors.orange,
              title: 'Recurring Issue',
              description:
                  'This customer has reported similar issues 2 times in the past month',
            ),
            SizedBox(height: 12),
            _buildInsightItem(
              icon: Icons.star,
              color: Colors.purple,
              title: 'High Value Customer',
              description:
                  'Premium subscriber for 2+ years with multiple purchases',
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // View more insights
                },
                icon: Icon(Icons.visibility, size: 18),
                label: Text('View All Insights'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'Happy':
        return Colors.green;
      case 'Frustrated':
        return Colors.orange;
      case 'Angry':
        return Colors.red;
      case 'Confused':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getSentimentIcon(String sentiment) {
    switch (sentiment) {
      case 'Happy':
        return Icons.sentiment_very_satisfied;
      case 'Frustrated':
        return Icons.sentiment_dissatisfied;
      case 'Angry':
        return Icons.sentiment_very_dissatisfied;
      case 'Confused':
        return Icons.psychology;
      default:
        return Icons.sentiment_neutral;
    }
  }

  Widget _buildEmotionGauge(String label, double value, Color color) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            width: 16,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 100 * value,
                  width: 16,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          Text(
            '${(value * 100).round()}%',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _emotionCard(String label, double score, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.emoji_emotions, color: color),
        ),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0, right: 8),
          child: LinearProgressIndicator(
            value: score,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        trailing: Container(
          width: 40,
          alignment: Alignment.centerRight,
          child: Text(
            '${(score * 100).round()}%',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// Session Review Page: Interaction Logs
class SessionReviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> sessions = [
    {
      'customer': 'John Smith',
      'time': '10:05 AM',
      'duration': '12m 34s',
      'emotion': 'Angry',
      'agentAction': 'Escalated to supervisor',
      'emotionColor': Colors.red,
    },
    {
      'customer': 'Sarah Johnson',
      'time': '11:32 AM',
      'duration': '8m 12s',
      'emotion': 'Happy',
      'agentAction': 'Resolved issue',
      'emotionColor': Colors.green,
    },
    {
      'customer': 'Michael Brown',
      'time': '01:45 PM',
      'duration': '15m 47s',
      'emotion': 'Confused',
      'agentAction': 'Provided detailed guide',
      'emotionColor': Colors.blue,
    },
    {
      'customer': 'Emily Davis',
      'time': '03:20 PM',
      'duration': '5m 39s',
      'emotion': 'Frustrated',
      'agentAction': 'Offered discount',
      'emotionColor': Colors.orange,
    },
  ];

  SessionReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Filter sessions
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        session['customer'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        session['time'],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Duration: ${session['duration']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: session['emotionColor'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_emotions,
                              size: 16,
                              color: session['emotionColor'],
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Primary: ${session['emotion']}',
                              style: TextStyle(
                                color: session['emotionColor'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Agent Action:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(session['agentAction']),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // View session details
                        },
                        child: Text('VIEW DETAILS'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Recording Page: New session recording
class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool _isRecording = false;
  int _recordingSeconds = 0;
  String _currentEmotion = 'Neutral';
  Color _emotionColor = Colors.grey;

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _startRecordingTimer();
      }
    });
  }

  void _startRecordingTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingSeconds++;
          // Simulate emotion changes
          if (_recordingSeconds % 5 == 0) {
            List<Map<String, dynamic>> emotions = [
              {'emotion': 'Happy', 'color': Colors.green},
              {'emotion': 'Neutral', 'color': Colors.grey},
              {'emotion': 'Confused', 'color': Colors.blue},
              {'emotion': 'Frustrated', 'color': Colors.orange},
            ];
            var randomEmotion = emotions[_recordingSeconds % emotions.length];
            _currentEmotion = randomEmotion['emotion'];
            _emotionColor = randomEmotion['color'];
          }
        });
        _startRecordingTimer();
      }
    });
  }

  String get _formattedTime {
    int minutes = _recordingSeconds ~/ 60;
    int seconds = _recordingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recording Session')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer display
              Text(
                _formattedTime,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),

              // Recording status
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color:
                      _isRecording
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isRecording ? Icons.mic : Icons.mic_off,
                      color: _isRecording ? Colors.red : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _isRecording ? 'Recording' : 'Not Recording',
                      style: TextStyle(
                        color: _isRecording ? Colors.red : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Current emotion
              if (_isRecording) ...[
                Text(
                  'Current Detected Emotion:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: _emotionColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _currentEmotion,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _emotionColor,
                    ),
                  ),
                ),
              ],

              Spacer(),

              // Record button
              GestureDetector(
                onTap: _toggleRecording,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color:
                        _isRecording
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _isRecording ? 'Tap to stop' : 'Tap to start recording',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
