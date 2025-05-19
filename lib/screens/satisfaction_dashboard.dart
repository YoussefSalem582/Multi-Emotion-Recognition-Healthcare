import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/core.dart';
import '../core/widgets/custom/satisfaction_chart.dart';
import '../models/customer_satisfaction.dart';
import '../presentation/providers/csv_import_provider.dart';

class SatisfactionDashboardPage extends StatefulWidget {
  const SatisfactionDashboardPage({Key? key}) : super(key: key);

  @override
  _SatisfactionDashboardPageState createState() =>
      _SatisfactionDashboardPageState();
}

class _SatisfactionDashboardPageState extends State<SatisfactionDashboardPage> {
  late CsvImportProvider _provider;
  String _selectedTimeRange = 'All Time';
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<CsvImportProvider>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_provider.hasData) {
      return _buildEmptyState();
    }

    final summary = _provider.summary!;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              stretch: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
                title: Text(
                  'Satisfaction Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.8),
                            Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.9),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 70,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTimeRangeDisplay(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      summary.averageScore >= 4.0
                                          ? Colors.green
                                          : summary.averageScore >= 3.0
                                          ? Colors.amber
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      summary.averageScore >= 4.0
                                          ? Icons.sentiment_very_satisfied
                                          : summary.averageScore >= 3.0
                                          ? Icons.sentiment_satisfied
                                          : Icons.sentiment_very_dissatisfied,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      summary.averageScore.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'average satisfaction',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
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
              actions: [
                if (_provider.filterStartDate != null)
                  IconButton(
                    icon: Icon(Icons.filter_alt_off, color: Colors.white),
                    onPressed: () {
                      _provider.clearDateFilter();
                      setState(() {
                        _selectedTimeRange = 'All Time';
                      });
                    },
                    tooltip: 'Clear Filter',
                  ),
                IconButton(
                  icon: Icon(Icons.calendar_month, color: Colors.white),
                  onPressed: _showDateFilterDialog,
                  tooltip: 'Filter by Date',
                ),
                IconButton(
                  icon: Icon(Icons.download, color: Colors.white),
                  onPressed: _exportData,
                  tooltip: 'Export Data',
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {
                    _showOptionsBottomSheet();
                  },
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: _buildTabSelector(),
            ),
            Expanded(child: _buildTabContent(summary)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportData,
        icon: Icon(Icons.share),
        label: Text('Share Insights'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  String _getTimeRangeDisplay() {
    if (_provider.filterStartDate == null || _provider.filterEndDate == null) {
      return 'All Time';
    }

    final dateFormat = DateFormat('MMM d, yyyy');
    final start = dateFormat.format(_provider.filterStartDate!);
    final end = dateFormat.format(
      _provider.filterEndDate!.subtract(Duration(days: 1)),
    );

    return '$start - $end';
  }

  Widget _buildTabSelector() {
    final tabs = [
      {'label': 'Overview', 'icon': Icons.dashboard},
      {'label': 'Categories', 'icon': Icons.category},
      {'label': 'Trends', 'icon': Icons.trending_up},
      {'label': 'Details', 'icon': Icons.list},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isSelected = _selectedTabIndex == index;

          return Padding(
            padding: EdgeInsets.only(right: 8),
            child:
                AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1)
                                : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                tab['icon'] as IconData,
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                tab['label'] as String,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.8),
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .animate(target: isSelected ? 1 : 0)
                    .scale(
                      end: const Offset(1.0, 1.0),
                      begin: const Offset(0.95, 0.95),
                    )
                    .fadeIn(),
          );
        }),
      ),
    );
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.download),
                title: Text('Export as CSV'),
                onTap: () {
                  Navigator.pop(context);
                  _performExport(false);
                },
              ),
              ListTile(
                leading: Icon(Icons.table_chart),
                title: Text('Export as Excel'),
                onTap: () {
                  Navigator.pop(context);
                  _performExport(true);
                },
              ),
              ListTile(
                leading: Icon(Icons.print),
                title: Text('Print Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Print feature coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Refresh Data'),
                onTap: () {
                  Navigator.pop(context);
                  // Refresh data
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent(SatisfactionSummary summary) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab(summary);
      case 1:
        return _buildCategoriesTab(summary);
      case 2:
        return _buildTrendsTab(summary);
      case 3:
        return _buildDetailsTab(summary);
      default:
        return _buildOverviewTab(summary);
    }
  }

  Widget _buildOverviewTab(SatisfactionSummary summary) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date filter indicator
          if (_provider.filterStartDate != null) _buildDateFilterCard(),

          // Summary metrics
          _buildSummaryCards(summary),
          SizedBox(height: 24),

          // Score distribution
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Satisfaction Distribution',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 280,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SatisfactionChart(
                            scoreDistribution: summary.scoreDistribution,
                            height: 280,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SatisfactionPieChart(
                            scoreDistribution: summary.scoreDistribution,
                            size: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Top and bottom performances
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTopRatedCard(summary.topRatedInteractions)),
              SizedBox(width: 16),
              Expanded(child: _buildLowRatedCard(summary.lowRatedInteractions)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilterCard() {
    final dateFormat = DateFormat('MMM d, yyyy');
    final startDate = dateFormat.format(_provider.filterStartDate!);
    final endDate = dateFormat.format(
      _provider.filterEndDate!.subtract(Duration(days: 1)),
    );

    return Card(
      margin: EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.filter_alt,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Filter Applied',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text('$startDate to $endDate'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _provider.clearDateFilter();
                setState(() {
                  _selectedTimeRange = 'All Time';
                });
              },
              tooltip: 'Clear filter',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(SatisfactionSummary summary) {
    final averageScoreColor = _getColorForScore(summary.averageScore);
    final cards = [
      _buildInfoCard(
        'Average Score',
        summary.averageScore.toStringAsFixed(1),
        Icons.star,
        averageScoreColor,
      ),
      _buildInfoCard(
        'Total Interactions',
        summary.totalInteractions.toString(),
        Icons.people,
        Colors.blue,
      ),
      _buildInfoCard(
        'Categories',
        '${summary.categoryAverages.length}',
        Icons.category,
        Colors.purple,
      ),
      _buildInfoCard(
        'Date Range',
        _selectedTimeRange,
        Icons.calendar_today,
        Colors.teal,
      ),
    ];

    return ResponsiveDashboardLayout.forCardGrid(cards: cards);
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRatedCard(List<CustomerSatisfaction> items) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Rated Interactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...items
                .take(3)
                .map((item) => _buildInteractionItem(item))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLowRatedCard(List<CustomerSatisfaction> items) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Low Rated Interactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...items
                .take(3)
                .map((item) => _buildInteractionItem(item))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionItem(CustomerSatisfaction item) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getColorForScore(
                item.satisfactionScore.toDouble(),
              ).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${item.satisfactionScore}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getColorForScore(item.satisfactionScore.toDouble()),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer: ${item.customerId}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '${dateFormat.format(item.timestamp)} • ${item.category}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                if (item.feedback.isNotEmpty) SizedBox(height: 4),
                if (item.feedback.isNotEmpty)
                  Text(
                    item.feedback,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle:
                          item.feedback.isNotEmpty
                              ? FontStyle.italic
                              : FontStyle.normal,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab(SatisfactionSummary summary) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date filter indicator
          if (_provider.filterStartDate != null) _buildDateFilterCard(),

          // Category analysis
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category Performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SatisfactionChart(
                    scoreDistribution: summary.scoreDistribution,
                    categoryAverages: summary.categoryAverages,
                    height: 300,
                    showLegend: false,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Category comparison
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category Distribution',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildCategoryDistribution(summary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution(SatisfactionSummary summary) {
    // Count interactions per category
    Map<String, int> categoryCount = {};

    for (var entry in summary.categoryAverages.entries) {
      int count = 0;
      for (var item in _provider.satisfactionData) {
        if (item.category == entry.key) {
          count++;
        }
      }
      categoryCount[entry.key] = count;
    }

    return Column(
      children: [
        for (var entry in categoryCount.entries)
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        height: 30,
                        width:
                            MediaQuery.of(context).size.width *
                            0.6 *
                            (entry.value / summary.totalInteractions),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${entry.value} (${(entry.value / summary.totalInteractions * 100).toStringAsFixed(1)}%)',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTrendsTab(SatisfactionSummary summary) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date filter indicator
          if (_provider.filterStartDate != null) _buildDateFilterCard(),

          // Time series analysis
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Satisfaction Over Time',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 300, child: _buildTimeSeriesChart()),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Agent performance
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agent Performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildAgentPerformance(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSeriesChart() {
    // Sort data by timestamp
    final data = List<CustomerSatisfaction>.from(_provider.satisfactionData);
    data.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // This is a placeholder for a real time series chart
    // In a real app, you'd use a charting library like fl_chart or syncfusion_flutter_charts
    return Center(
      child: Text(
        'Time series chart would go here\nShowing ${data.length} data points over time',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAgentPerformance() {
    // Calculate per-agent stats
    Map<String, List<CustomerSatisfaction>> agentData = {};

    for (var item in _provider.satisfactionData) {
      if (!agentData.containsKey(item.agentId)) {
        agentData[item.agentId] = [];
      }
      agentData[item.agentId]!.add(item);
    }

    // Calculate average scores
    Map<String, double> agentScores = {};
    for (var entry in agentData.entries) {
      double total = 0;
      for (var item in entry.value) {
        total += item.satisfactionScore;
      }
      agentScores[entry.key] = total / entry.value.length;
    }

    // Sort by average score
    List<MapEntry<String, double>> sortedEntries =
        agentScores.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        for (var entry in sortedEntries)
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Agent: ${entry.key}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getColorForScore(entry.value).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        entry.value.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getColorForScore(entry.value),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: entry.value / 5.0,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorForScore(entry.value),
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 4),
                Text(
                  '${agentData[entry.key]!.length} interactions',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsTab(SatisfactionSummary summary) {
    final dateFormat = DateFormat('MMM d, yyyy');

    // Sort data by timestamp, most recent first
    final data = List<CustomerSatisfaction>.from(_provider.satisfactionData);
    data.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Date filter indicator
        if (_provider.filterStartDate != null) _buildDateFilterCard(),

        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Interaction Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${data.length} records',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Agent')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Score')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Duration')),
                      DataColumn(label: Text('Feedback')),
                    ],
                    rows:
                        data
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(Text(item.customerId)),
                                  DataCell(Text(item.agentId)),
                                  DataCell(
                                    Text(dateFormat.format(item.timestamp)),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getColorForScore(
                                          item.satisfactionScore.toDouble(),
                                        ).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${item.satisfactionScore}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _getColorForScore(
                                            item.satisfactionScore.toDouble(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(item.category)),
                                  DataCell(
                                    Text('${_formatDuration(item.duration)}'),
                                  ),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 200,
                                      ),
                                      child: Text(
                                        item.feedback,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showDateFilterDialog() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 1)),
      initialDateRange:
          _provider.filterStartDate != null
              ? DateTimeRange(
                start: _provider.filterStartDate!,
                end: _provider.filterEndDate!.subtract(Duration(days: 1)),
              )
              : DateTimeRange(
                start: DateTime.now().subtract(Duration(days: 30)),
                end: DateTime.now(),
              ),
    );

    if (result != null) {
      setState(() {
        _selectedTimeRange =
            '${DateFormat('MMM d').format(result.start)} - ${DateFormat('MMM d').format(result.end)}';
      });

      // Set the filter with end date +1 day to include the full end date
      _provider.setDateFilter(result.start, result.end.add(Duration(days: 1)));
    }
  }

  Future<void> _exportData() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Export Data'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.description, color: Colors.blue),
                  title: Text('Export as CSV'),
                  onTap: () {
                    Navigator.pop(context);
                    _performExport(false);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.table_chart, color: Colors.green),
                  title: Text('Export as Excel'),
                  onTap: () {
                    Navigator.pop(context);
                    _performExport(true);
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

  Future<void> _performExport(bool isExcel) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Exporting data... Please wait.')));

    final path = await _provider.exportData(isExcel);

    if (path.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data exported successfully'),
          action: SnackBarAction(
            label: 'SHARE',
            onPressed: () async {
              await Share.share(
                'Customer Satisfaction Data Export',
                subject: 'Data Export',
              );
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: ${_provider.error}')),
      );
    }
  }

  Color _getColorForScore(double score) {
    if (score >= 4.5) return Colors.green[800]!;
    if (score >= 4.0) return Colors.green;
    if (score >= 3.5) return Colors.lightGreen;
    if (score >= 3.0) return Colors.amber;
    if (score >= 2.0) return Colors.orange;
    return Colors.red;
  }

  /// Builds the empty state when no data is available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No satisfaction data available',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.csvImport);
            },
            icon: Icon(Icons.upload_file),
            label: Text('Import Data'),
          ),
        ],
      ),
    );
  }
}
