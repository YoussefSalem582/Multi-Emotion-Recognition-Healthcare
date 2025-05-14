import '../core/core.dart';
import 'dart:math' as math;
import '../models/analytics_data.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  bool _isExpanded = false;
  String _selectedTimeRange = 'Today';

  // Example data
  final Map<String, double> _currentEmotionData = {
    'Happy': 0.65,
    'Neutral': 0.20,
    'Frustrated': 0.10,
    'Confused': 0.03,
    'Angry': 0.02,
  };

  final List<Map<String, dynamic>> _emotionHistory = [
    {
      'time': '10:05 AM',
      'emotions': {
        'Happy': 0.25,
        'Frustrated': 0.45,
        'Angry': 0.20,
        'Neutral': 0.10,
      },
    },
    {
      'time': '10:15 AM',
      'emotions': {
        'Happy': 0.40,
        'Frustrated': 0.30,
        'Angry': 0.10,
        'Neutral': 0.20,
      },
    },
    {
      'time': '10:25 AM',
      'emotions': {
        'Happy': 0.55,
        'Frustrated': 0.20,
        'Angry': 0.05,
        'Neutral': 0.20,
      },
    },
    {
      'time': '10:35 AM',
      'emotions': {
        'Happy': 0.65,
        'Frustrated': 0.10,
        'Angry': 0.02,
        'Neutral': 0.23,
      },
    },
  ];

  final List<Map<String, dynamic>> _recommendations = [
    {
      'title': 'Offer a discount',
      'description':
          'Customer is happy with the service, offer a loyalty discount',
      'icon': Icons.local_offer,
      'color': Colors.green,
    },
    {
      'title': 'Clarify features',
      'description': 'Some confusion detected about product capabilities',
      'icon': Icons.help_outline,
      'color': Colors.blue,
    },
    {
      'title': 'Escalate to supervisor',
      'description': 'Frustration detected at timestamp 01:23',
      'icon': Icons.support_agent,
      'color': Colors.orange,
    },
  ];

  // New analytics data
  final List<AnalyticsData> _analyticsItems = [
    AnalyticsData(
      title: 'Happy Customer Rate',
      value: '84%',
      trend: '12%',
      icon: Icons.sentiment_very_satisfied,
      color: Colors.green,
      isPositive: true,
    ),
    AnalyticsData(
      title: 'Frustration Rate',
      value: '8%',
      trend: '5%',
      icon: Icons.sentiment_dissatisfied,
      color: Colors.orange,
      isPositive: false,
    ),
    AnalyticsData(
      title: 'Avg. Response Time',
      value: '1.8m',
      trend: '14%',
      icon: Icons.timer,
      color: Colors.blue,
      isPositive: true,
    ),
    AnalyticsData(
      title: 'Resolution Rate',
      value: '92%',
      trend: '3%',
      icon: Icons.check_circle,
      color: Colors.purple,
      isPositive: true,
    ),
  ];

  // Emotion trends data
  final Map<String, List<double>> _emotionTrends = {
    'Happy': [0.25, 0.35, 0.42, 0.50, 0.55, 0.60, 0.65],
    'Frustrated': [0.45, 0.35, 0.25, 0.18, 0.15, 0.12, 0.10],
    'Neutral': [0.20, 0.22, 0.25, 0.22, 0.20, 0.22, 0.20],
  };

  final Map<String, Color> _emotionColors = {
    'Happy': Colors.green,
    'Frustrated': Colors.orange,
    'Neutral': Colors.grey,
    'Angry': Colors.red,
    'Confused': Colors.blue,
  };

  // Customer segments
  final List<CustomerSegment> _customerSegments = [
    CustomerSegment(
      name: 'Very Satisfied',
      percentage: 0.45,
      color: Colors.green,
    ),
    CustomerSegment(
      name: 'Satisfied',
      percentage: 0.30,
      color: Colors.lightGreen,
    ),
    CustomerSegment(name: 'Neutral', percentage: 0.15, color: Colors.grey),
    CustomerSegment(
      name: 'Dissatisfied',
      percentage: 0.10,
      color: Colors.orange,
    ),
  ];

  // Key insights

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EmoSense Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              _showTimeRangeSelector(context);
            },
            tooltip: 'Select time range',
          ),
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
            tooltip: 'Refresh data',
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Show settings dialog
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Dashboard Settings'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SwitchListTile(
                            title: Text('Auto Refresh'),
                            subtitle: Text('Update dashboard every 5 minutes'),
                            value: false,
                            onChanged: (value) {
                              Navigator.pop(context);
                            },
                          ),
                          SwitchListTile(
                            title: Text('Sound Alerts'),
                            subtitle: Text('Play sound for emotion changes'),
                            value: false,
                            onChanged: (value) {
                              Navigator.pop(context);
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
            tooltip: 'Dashboard settings',
          ),
        ],
        bottom:
            _isLoading
                ? null
                : PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
                        Tab(icon: Icon(Icons.history), text: 'History'),
                        Tab(
                          icon: Icon(Icons.lightbulb_outline),
                          text: 'Insights',
                        ),
                        Tab(icon: Icon(Icons.people), text: 'Segments'),
                      ],
                      onTap: (index) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
      ),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading dashboard...',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              )
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildHistoryTab(),
                  _buildInsightsTab(),
                  _buildSegmentsTab(),
                ],
              ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    if (_isLoading) return SizedBox();

    final List<Widget> actions = [
      FloatingActionButton(
        heroTag: 'export',
        mini: true,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Exporting dashboard data...'),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(label: 'VIEW', onPressed: () {}),
            ),
          );
        },
        child: Icon(Icons.download),
        tooltip: 'Export data',
      ),
      SizedBox(height: 8),
      FloatingActionButton(
        heroTag: 'recommendations',
        mini: true,
        onPressed: () {
          _showRecommendationsSheet(context);
        },
        child: Icon(Icons.smart_toy),
        tooltip: 'AI Recommendations',
      ),
      SizedBox(height: 8),
      FloatingActionButton(
        heroTag: 'main',
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedRotation(
          duration: Duration(milliseconds: 300),
          turns: _isExpanded ? 0.125 : 0,
          child: Icon(_isExpanded ? Icons.close : Icons.add),
        ),
        tooltip: 'Actions',
      ),
    ];

    return _isExpanded
        ? Column(
          mainAxisSize: MainAxisSize.min,
          children:
              actions.map((widget) {
                // Add a sliding animation for the additional buttons
                if (widget is FloatingActionButton && widget != actions.last) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: ModalRoute.of(context)!.animation!,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: widget,
                  );
                }
                return widget;
              }).toList(),
        )
        : actions.last;
  }

  void _showTimeRangeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Time Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                      'Today',
                      'Yesterday',
                      'This Week',
                      'This Month',
                      'Custom Range',
                    ].map((range) {
                      return ChoiceChip(
                        label: Text(range),
                        selected: _selectedTimeRange == range,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedTimeRange = range;
                              Navigator.pop(context);
                            });
                          }
                        },
                      );
                    }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeRangeBar(),
          SizedBox(height: 16),
          _buildSummaryCard(),
          SizedBox(height: 16),
          _buildAnalyticsGrid(),
          SizedBox(height: 24),
          _buildCustomerCard(),
          SizedBox(height: 20),
          _buildEmotionTrendsCard(),
          SizedBox(height: 20),
          _buildEnhancedEmotionCard(),
        ],
      ),
    );
  }

  Widget _buildTimeRangeBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Showing data for: ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          InkWell(
            onTap: () => _showTimeRangeSelector(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedTimeRange,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Session Summary',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacer(),
                OutlinedButton.icon(
                  icon: Icon(Icons.share, size: 16),
                  label: Text('Share'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sharing dashboard summary...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 8),
            Text(
              '${_selectedTimeRange} Overview',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The overall customer sentiment is positive with 84% satisfaction rate. There was a brief period of frustration detected around 10:15 AM, but this was quickly resolved.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Overall sentiment trend: Positive',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: _analyticsItems.length,
          itemBuilder: (context, index) {
            return AnalyticsCard(
              data: _analyticsItems[index],
              isCompact: true,
              onTap: () {
                // Handle analytics card tap
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmotionTrendsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.trending_up,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Emotion Trends',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    tooltip: 'Options',
                    onSelected: (value) {
                      if (value == 'refresh') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Refreshing trend data...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else if (value == 'export') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Exporting trend data...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else if (value == 'fullscreen') {
                        // Show fullscreen chart
                        showDialog(
                          context: context,
                          builder:
                              (context) => Dialog(
                                insetPadding: EdgeInsets.all(16),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Detailed Emotion Trends',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed:
                                                () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        height: 400,
                                        child: MultiTrendChart(
                                          dataSeries: _emotionTrends,
                                          colors: _emotionColors,
                                          height: 380,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        );
                      }
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 'refresh',
                            child: Row(
                              children: [
                                Icon(Icons.refresh, size: 18),
                                SizedBox(width: 8),
                                Text('Refresh Data'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'export',
                            child: Row(
                              children: [
                                Icon(Icons.download, size: 18),
                                SizedBox(width: 8),
                                Text('Export Trends'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'fullscreen',
                            child: Row(
                              children: [
                                Icon(Icons.fullscreen, size: 18),
                                SizedBox(width: 8),
                                Text('View Fullscreen'),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Last 30 minutes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 220,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: MultiTrendChart(
                  dataSeries: _emotionTrends,
                  colors: _emotionColors,
                  height: 200,
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      _emotionTrends.keys.map((emotion) {
                        final lastValue = _emotionTrends[emotion]!.last;
                        final previousValue =
                            _emotionTrends[emotion]![_emotionTrends[emotion]!
                                    .length -
                                2];
                        final isIncreasing = lastValue > previousValue;

                        return Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _emotionColors[emotion]!.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _emotionColors[emotion]!.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getEmotionIcon(emotion),
                                size: 16,
                                color: _emotionColors[emotion],
                              ),
                              SizedBox(width: 6),
                              Text(
                                emotion,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '${(lastValue * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _emotionColors[emotion],
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                isIncreasing
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 12,
                                color: isIncreasing ? Colors.green : Colors.red,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Segments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emotional Distribution',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _SegmentsPainter(segments: _customerSegments),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children:
                        _customerSegments.map((segment) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: segment.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(segment.name),
                                Spacer(),
                                Text('${(segment.percentage * 100).toInt()}%'),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Customer Journey',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emotional Touchpoints',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildJourneyTimeline(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyTimeline() {
    final stages = [
      {'name': 'Awareness', 'emotion': 'Neutral', 'percentage': 0.65},
      {'name': 'Consideration', 'emotion': 'Confused', 'percentage': 0.25},
      {'name': 'Decision', 'emotion': 'Happy', 'percentage': 0.75},
      {'name': 'Onboarding', 'emotion': 'Frustrated', 'percentage': 0.30},
      {'name': 'Retention', 'emotion': 'Happy', 'percentage': 0.85},
    ];

    return Column(
      children: [
        for (int i = 0; i < stages.length; i++)
          _buildJourneyStage(
            stages[i]['name'] as String,
            stages[i]['emotion'] as String,
            stages[i]['percentage'] as double,
            isFirst: i == 0,
            isLast: i == stages.length - 1,
          ),
      ],
    );
  }

  Widget _buildJourneyStage(
    String name,
    String emotion,
    double percentage, {
    required bool isFirst,
    required bool isLast,
  }) {
    final Color color = _getEmotionColor(emotion);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.withOpacity(0.3),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      emotion,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${(percentage * 100).toInt()}% satisfaction',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: percentage,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
              SizedBox(height: isLast ? 0 : 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emotion Timeline',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emotional Progression',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _emotionHistory.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Text(
                                _emotionHistory[index]['time'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: EmotionChart(
                                  emotions:
                                      _emotionHistory[index]['emotions']
                                          as Map<String, double>,
                                  colors: _emotionColors,
                                  size: 100,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _getPrimaryEmotion(
                                  _emotionHistory[index]['emotions'],
                                ),
                                style: TextStyle(
                                  color: _getEmotionColor(
                                    _getPrimaryEmotion(
                                      _emotionHistory[index]['emotions'],
                                    ),
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Session Log',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ...List.generate(5, (index) {
            final timestamp = DateTime.now().subtract(
              Duration(minutes: index * 10),
            );
            final formattedTime =
                '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

            return Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      index == 0
                          ? Colors.green.withOpacity(0.2)
                          : index == 1
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                  child: Icon(
                    index == 0
                        ? Icons.sentiment_very_satisfied
                        : index == 1
                        ? Icons.sentiment_neutral
                        : Icons.sentiment_satisfied,
                    color:
                        index == 0
                            ? Colors.green
                            : index == 1
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ),
                title: Text(
                  index == 0
                      ? 'Very positive response'
                      : index == 1
                      ? 'Minor frustration detected'
                      : 'Neutral conversation',
                ),
                subtitle: Text('Timestamp: $formattedTime'),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  // View details
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emotional Insights',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insights,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Session Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    'The customer started with mixed emotions but gradually became more positive. There was a brief moment of frustration at 10:15 AM, but the overall trend shows increasing satisfaction.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInsightCard(
                          title: '10:15 AM',
                          subtitle: 'Peak Frustration',
                          icon: Icons.warning_amber,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildInsightCard(
                          title: '10:35 AM',
                          subtitle: 'Most Happy',
                          icon: Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Generate detailed report
                          },
                          icon: Icon(Icons.analytics),
                          label: Text('Detailed Report'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Export data
                          },
                          icon: Icon(Icons.download),
                          label: Text('Export Data'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'AI Recommendations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ..._recommendations.map((recommendation) {
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: recommendation['color'].withOpacity(0.2),
                  child: Icon(
                    recommendation['icon'],
                    color: recommendation['color'],
                  ),
                ),
                title: Text(recommendation['title']),
                subtitle: Text(recommendation['description']),
                trailing: IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    // View recommendation details
                  },
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 36,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Smith',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Customer ID: #CS12345',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.7),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '+1 (555) 123-4567',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.email,
                              size: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.7),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'john.s@example.com',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCustomerInfoItem(
                    title: 'Current Call',
                    value: '05:23',
                    icon: Icons.timer,
                  ),
                  _buildCustomerInfoItem(
                    title: 'Customer Type',
                    value: 'Premium',
                    icon: Icons.star,
                  ),
                  _buildCustomerInfoItem(
                    title: 'Status',
                    value: 'Active',
                    icon: Icons.verified_user,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Happy',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      // View customer profile
                    },
                    icon: Icon(Icons.person_outline, size: 18),
                    label: Text('Profile'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerInfoItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withOpacity(0.7),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEnhancedEmotionCard() {
    // Get the sorted emotions by value
    final sortedEmotions =
        _currentEmotionData.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final primaryEmotion = sortedEmotions.first.key;
    final primaryValue = sortedEmotions.first.value;
    final primaryColor = _getEmotionColor(primaryEmotion);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getEmotionIcon(primaryEmotion),
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Emotional Analysis',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    tooltip: 'Emotion information',
                    onPressed: () {
                      // Show emotion information dialog
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.psychology,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Emotions Explained'),
                                ],
                              ),
                              content: Container(
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildEmotionExplanationRow(
                                      'Happy',
                                      'Positive customer experience, satisfied with the service.',
                                    ),
                                    Divider(),
                                    _buildEmotionExplanationRow(
                                      'Neutral',
                                      'Neither positive nor negative sentiment detected.',
                                    ),
                                    Divider(),
                                    _buildEmotionExplanationRow(
                                      'Frustrated',
                                      'Customer experiencing difficulty or dissatisfaction.',
                                    ),
                                    Divider(),
                                    _buildEmotionExplanationRow(
                                      'Confused',
                                      'Customer doesn\'t understand the information provided.',
                                    ),
                                    Divider(),
                                    _buildEmotionExplanationRow(
                                      'Angry',
                                      'Strong negative emotion, requires immediate attention.',
                                    ),
                                  ],
                                ),
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
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: EmotionChart(
                          emotions: _currentEmotionData,
                          colors: _emotionColors,
                          size: 180,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: EmotionBarChart(emotionData: _currentEmotionData),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getEmotionIcon(primaryEmotion),
                          color: primaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Primary Emotion',
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '${primaryEmotion} (${(primaryValue * 100).toInt()}%)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      _getEmotionDescription(primaryEmotion),
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  // View detailed analysis
                  _tabController.animateTo(2); // Switch to Insights tab
                },
                icon: Icon(Icons.analytics),
                label: Text('View Detailed Analysis'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmotionDescription(String emotion) {
    switch (emotion) {
      case 'Happy':
        return 'Customer is showing strong positive emotions and satisfaction with the service. This is a good opportunity to suggest additional services or products.';
      case 'Neutral':
        return 'Customer is not showing any significant emotional response. Consider adding more personalized elements to the interaction.';
      case 'Confused':
        return 'Customer appears to be having trouble understanding some aspects of the conversation. Try simplifying explanations and checking for comprehension.';
      case 'Frustrated':
        return 'Customer is showing signs of irritation or dissatisfaction. Address concerns quickly and consider offering compensation or escalation options.';
      case 'Angry':
        return 'Customer is displaying strong negative emotions. Immediate de-escalation is recommended, possibly by transferring to a supervisor or offering immediate solutions.';
      default:
        return 'Analyzing customer emotions to provide better service recommendations.';
    }
  }

  void _showRecommendationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AI Recommendations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Based on the current emotional state, here are some recommended actions:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 16),
              ..._recommendations.map((recommendation) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: recommendation['color'].withOpacity(0.2),
                    child: Icon(
                      recommendation['icon'],
                      color: recommendation['color'],
                    ),
                  ),
                  title: Text(recommendation['title']),
                  subtitle: Text(recommendation['description']),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () {
                      Navigator.pop(context);
                      // Implement recommendation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Implementing: ${recommendation['title']}',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Generate new recommendations
                  },
                  child: Text('Generate More Recommendations'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getPrimaryEmotion(Map<String, double> emotions) {
    String primary = '';
    double maxValue = 0;

    emotions.forEach((emotion, value) {
      if (value > maxValue) {
        maxValue = value;
        primary = emotion;
      }
    });

    return primary;
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Colors.green;
      case 'Neutral':
        return Colors.grey;
      case 'Confused':
        return Colors.blue;
      case 'Frustrated':
        return Colors.orange;
      case 'Angry':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Icons.sentiment_very_satisfied;
      case 'Neutral':
        return Icons.sentiment_neutral;
      case 'Confused':
        return Icons.psychology;
      case 'Frustrated':
        return Icons.sentiment_dissatisfied;
      case 'Angry':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.emoji_emotions;
    }
  }

  Widget _buildInsightCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionExplanationRow(String emotion, String description) {
    Color emotionColor = _getEmotionColor(emotion);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: emotionColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getEmotionIcon(emotion),
              color: emotionColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emotion,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: emotionColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentsPainter extends CustomPainter {
  final List<CustomerSegment> segments;

  _SegmentsPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final outerRadius = radius * 0.9;
    final innerRadius = radius * 0.6;

    double startAngle = -math.pi / 2; // Start from top

    for (var segment in segments) {
      final sweepAngle = 2 * math.pi * segment.percentage;

      // Draw segment
      final segmentPaint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = segment.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        sweepAngle,
        true,
        segmentPaint,
      );

      // Draw inner white circle to create donut chart
      final innerPaint =
          Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.white;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        sweepAngle,
        true,
        innerPaint,
      );

      // Calculate position for label if segment is large enough
      if (segment.percentage >= 0.1) {
        final labelAngle = startAngle + (sweepAngle / 2);
        final labelRadius = (innerRadius + outerRadius) / 2;
        final labelX = center.dx + labelRadius * math.cos(labelAngle);
        final labelY = center.dy + labelRadius * math.sin(labelAngle);

        final textSpan = TextSpan(
          text: '${(segment.percentage * 100).toInt()}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            labelX - textPainter.width / 2,
            labelY - textPainter.height / 2,
          ),
        );
      }

      startAngle += sweepAngle;
    }

    // Draw center circle
    final centerPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white;

    canvas.drawCircle(center, innerRadius, centerPaint);

    // Draw center text
    final textSpan = TextSpan(
      text: 'Customer\nEmotions',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
