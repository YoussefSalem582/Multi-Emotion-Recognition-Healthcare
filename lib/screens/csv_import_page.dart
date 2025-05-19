import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../core/core.dart';
import '../presentation/providers/csv_import_provider.dart';
import '../models/customer_satisfaction.dart';
import '../core/widgets/custom/satisfaction_chart.dart';

class CsvImportPage extends StatefulWidget {
  const CsvImportPage({super.key});

  @override
  _CsvImportPageState createState() => _CsvImportPageState();
}

class _CsvImportPageState extends State<CsvImportPage> {
  late CsvImportProvider _provider;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    // The provider will be initialized via Provider.of in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<CsvImportProvider>(context);
  }

  Future<void> _importFile() async {
    try {
      // Use FilePicker instead of ImagePicker for better file selection experience
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        final extension = path.extension(file.path).toLowerCase();
        final fileSize = await file.length();

        if (extension != '.csv' && extension != '.xlsx') {
          _showSnackBar('Please select a CSV or Excel file');
          return;
        }

        // Use batch processing for large files (> 5MB)
        bool success = false;
        if (fileSize > 5 * 1024 * 1024) {
          // 5MB
          success = await _provider.importLargeFile(file);
          if (success) {
            _showSnackBar('Large file imported successfully');
          } else {
            _showSnackBar('Failed to import large file: ${_provider.error}');
          }
        } else {
          success = await _provider.importFromFile(file);
          if (success) {
            _showSnackBar('Data imported successfully');
          } else {
            _showSnackBar('Failed to import data: ${_provider.error}');
          }
        }

        // Show validation warnings if any
        if (success && _provider.lastValidationResult != null) {
          final warnings = _provider.lastValidationResult!.warningMessages;
          if (warnings.isNotEmpty) {
            _showWarningsDialog(warnings);
          }
        }
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showWarningsDialog(List<String> warnings) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Import Warnings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('The following warnings were found:'),
                SizedBox(height: 16),
                ...warnings.map(
                  (warning) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.amber,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(child: Text(warning)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _downloadTemplate() async {
    try {
      // Ask user whether they want CSV or Excel template
      final format = await _showFormatSelectionDialog();
      if (format == null) return;

      final isExcel = format == 'Excel';
      final templatePath = await _provider.generateSampleTemplate(isExcel);

      if (templatePath.isNotEmpty) {
        await Share.share(
          'Customer Satisfaction ${isExcel ? 'Excel' : 'CSV'} Template',
          subject: isExcel ? 'Excel Template' : 'CSV Template',
        );
        _showSnackBar('Template generated at: $templatePath');
      } else {
        _showSnackBar('Failed to generate template');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> _exportData() async {
    if (!_provider.hasData) {
      _showSnackBar('No data to export');
      return;
    }

    try {
      // Ask user whether they want CSV or Excel export
      final format = await _showFormatSelectionDialog();
      if (format == null) return;

      final isExcel = format == 'Excel';
      final exportPath = await _provider.exportData(isExcel);

      if (exportPath.isNotEmpty) {
        _showSnackBar('Data exported to: $exportPath');
        await Share.share(
          'Customer Satisfaction Data Export',
          subject: isExcel ? 'Excel Export' : 'CSV Export',
        );
      } else {
        _showSnackBar('Failed to export data: ${_provider.error}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<String?> _showFormatSelectionDialog() async {
    return showDialog<String>(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: Text('Select Format'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'CSV'),
                child: Row(
                  children: [
                    Icon(Icons.description, color: Colors.blue),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CSV Format',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Simple text-based format, widely compatible',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Excel'),
                child: Row(
                  children: [
                    Icon(Icons.table_chart, color: Colors.green),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Excel Format',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Microsoft Excel format with advanced features',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', textAlign: TextAlign.center),
              ),
            ],
          ),
    );
  }

  Future<void> _selectDateRange() async {
    final initialDateRange =
        _selectedDateRange ??
        DateTimeRange(
          start: DateTime.now().subtract(Duration(days: 30)),
          end: DateTime.now(),
        );

    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });
      // Apply date filter to the provider
      _provider.setDateFilter(
        newDateRange.start,
        newDateRange.end.add(Duration(days: 1)), // Include the end date fully
      );
      _showSnackBar('Date filter applied');
    }
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDateRange = null;
    });
    _provider.clearDateFilter();
    _showSnackBar('Date filter cleared');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer Satisfaction Data'),
          actions: [
            // Theme toggle button
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                  tooltip: 'Toggle Theme',
                );
              },
            ),
            if (_selectedDateRange != null)
              IconButton(
                icon: const Icon(Icons.filter_alt_off),
                onPressed: _clearDateFilter,
                tooltip: 'Clear Date Filter',
              ),
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: _selectDateRange,
              tooltip: 'Filter by Date',
            ),
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: _downloadTemplate,
              tooltip: 'Download Sample Template',
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _exportData,
              tooltip: 'Export Data',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _provider.clearData,
              tooltip: 'Clear Data',
            ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: _importFile,
          child: const Icon(Icons.upload_file),
          tooltip: 'Import File',
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_provider.isLoading) {
      return _buildLoadingState();
    }

    if (!_provider.hasData) {
      return _buildEmptyState();
    }

    return _buildDataView();
  }

  Widget _buildLoadingState() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_provider.isBatchProcessing) ...[
                  // Progress indicator with percentage for batch processing
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _provider.importProgress,
                          strokeWidth: 6,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          "${(_provider.importProgress * 100).toInt()}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Processing large file...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_provider.retryAttempts > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Retry attempt ${_provider.retryAttempts}...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.7),
                        ),
                      ),
                    ),
                ] else ...[
                  // Regular loading indicator with animation
                  SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                      .animate()
                      .scale(duration: const Duration(milliseconds: 300))
                      .then()
                      .shimmer(
                        duration: const Duration(milliseconds: 1200),
                        delay: const Duration(milliseconds: 300),
                      ),
                  const SizedBox(height: 24),
                  Text(
                    'Loading data...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (_provider.error.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.errorContainer.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _provider.error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 14,
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

  Widget _buildEmptyState() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final hasVersion = snapshot.hasData;
        final version = hasVersion ? snapshot.data!.version : '';
        final buildNumber = hasVersion ? snapshot.data!.buildNumber : '';

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upload_file,
                size: 80,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Import a CSV or Excel file to analyze customer satisfaction',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _importFile,
                icon: const Icon(Icons.file_upload),
                label: const Text('Import File'),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _downloadTemplate,
                icon: const Icon(Icons.download),
                label: const Text('Download Sample Template'),
              ),
              if (hasVersion) ...[
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Version $version ($buildNumber)',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataView() {
    final summary = _provider.summary;
    if (summary == null) {
      return const Center(child: Text('No summary available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigate to advanced dashboard
          Card(
            margin: EdgeInsets.only(bottom: 24),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.satisfactionDashboard);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'View Advanced Dashboard',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Explore detailed analytics, trends, and insights',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),

          // Date filter indicator
          if (_selectedDateRange != null) _buildDateFilterCard(),

          _buildSummaryCards(summary),
          const SizedBox(height: 24),
          _buildScoreDistribution(summary),
          const SizedBox(height: 24),
          _buildCategoryAverages(summary),
          const SizedBox(height: 24),
          _buildSatisfactionTable(_provider.satisfactionData),
        ],
      ),
    );
  }

  Widget _buildDateFilterCard() {
    final dateFormat = DateFormat('MMM d, yyyy');
    final startDate = dateFormat.format(_selectedDateRange!.start);
    final endDate = dateFormat.format(_selectedDateRange!.end);

    return Card(
      margin: EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
              onPressed: _clearDateFilter,
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
        'Average Satisfaction',
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
        'Top Score',
        '${summary.topRatedInteractions.isNotEmpty ? summary.topRatedInteractions.first.satisfactionScore : 0}',
        Icons.thumb_up,
        Colors.green,
      ),
      _buildInfoCard(
        'Categories',
        '${summary.categoryAverages.length}',
        Icons.category,
        Colors.purple,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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

  Widget _buildScoreDistribution(SatisfactionSummary summary) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Score Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SatisfactionChart(
              scoreDistribution: summary.scoreDistribution,
              height: 250,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryAverages(SatisfactionSummary summary) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Performance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SatisfactionChart(
              scoreDistribution: summary.scoreDistribution,
              categoryAverages: summary.categoryAverages,
              height: 300,
              showLegend: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSatisfactionTable(List<CustomerSatisfaction> data) {
    // Format date for better readability
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Interactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Export button for this specific table
                IconButton(
                  icon: Icon(Icons.download),
                  onPressed: _exportData,
                  tooltip: 'Export Data',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Agent')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Score')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Feedback')),
                ],
                rows:
                    data
                        .take(10)
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item.customerId)),
                              DataCell(Text(item.agentId)),
                              DataCell(Text(dateFormat.format(item.timestamp))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
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
                                    item.satisfactionScore.toString(),
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
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 200),
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
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 4.5) return Colors.green[800]!;
    if (score >= 4.0) return Colors.green;
    if (score >= 3.5) return Colors.lightGreen;
    if (score >= 3.0) return Colors.amber;
    if (score >= 2.0) return Colors.orange;
    return Colors.red;
  }
}

/// Responsive layout helper for dashboard components
class ResponsiveDashboardLayout extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final int crossAxisCountLarge;
  final int crossAxisCountMedium;
  final int crossAxisCountSmall;
  final double aspectRatio;
  final double spacing;

  const ResponsiveDashboardLayout({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(0),
    this.crossAxisCountLarge = 4,
    this.crossAxisCountMedium = 2,
    this.crossAxisCountSmall = 1,
    this.aspectRatio = 1.5,
    this.spacing = 16.0,
  });

  /// Factory constructor specifically for card grid layouts
  factory ResponsiveDashboardLayout.forCardGrid({
    Key? key,
    required List<Widget> cards,
    EdgeInsets padding = const EdgeInsets.all(0),
    double aspectRatio = 1.5,
    double spacing = 16.0,
  }) {
    return ResponsiveDashboardLayout(
      key: key,
      children: cards,
      padding: padding,
      crossAxisCountLarge: 4, // 4 cards in a row on large screens
      crossAxisCountMedium: 2, // 2 cards in a row on medium screens
      crossAxisCountSmall: 1, // 1 card per row on small screens
      aspectRatio: aspectRatio,
      spacing: spacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Determine how many cards to show per row based on width
        int crossAxisCount;
        if (width > 900) {
          crossAxisCount = crossAxisCountLarge;
        } else if (width > 600) {
          crossAxisCount = crossAxisCountMedium;
        } else {
          crossAxisCount = crossAxisCountSmall;
        }

        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          shrinkWrap: true,
          padding: padding,
          children: children,
        );
      },
    );
  }
}
