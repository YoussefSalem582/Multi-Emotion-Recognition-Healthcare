import '../core/core.dart';
import '../presentation/controllers/navigation_controller.dart';
import '../presentation/pages/home_page.dart';
import 'dashboard_page.dart';
import 'record_page.dart';
import 'video_page.dart';
import '../presentation/providers/theme_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final NavigationController _navigationController = NavigationController();
  late AnimationController _themeAnimationController;
  late Animation<double> _themeAnimation;

  // List of pages to display
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const DashboardPage(),
      const RecordPage(),
      const VideoPage(),
    ];

    // Listen to navigation changes
    _navigationController.addListener(() {
      setState(() {});
    });

    // Initialize animation controller for theme change indicator
    _themeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _themeAnimation = CurvedAnimation(
      parent: _themeAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _navigationController.dispose();
    _themeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Start animation when theme indicator is shown
    if (themeProvider.showThemeIndicator) {
      _themeAnimationController.forward(from: 0.0);
    }

    return Scaffold(
      body: Stack(
        children: [
          // Current screen
          IndexedStack(
            index: _navigationController.currentIndex,
            children: _pages,
          ),

          // Theme change indicator
          if (themeProvider.showThemeIndicator)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _themeAnimation,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          themeProvider.isDarkMode
                              ? 'Dark Mode Enabled'
                              : 'Light Mode Enabled',
                          style: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _navigationController.buildBottomNavigationBar(),
    );
  }
}
