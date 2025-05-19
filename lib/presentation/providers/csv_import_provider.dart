import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/customer_satisfaction.dart';
import '../../services/csv_import_service.dart';

class CsvImportProvider extends ChangeNotifier {
  final CsvImportService _service = CsvImportService();

  List<CustomerSatisfaction> _satisfactionData = [];
  SatisfactionSummary? _summary;
  bool _isLoading = false;
  String _error = '';
  String? _lastImportedFilePath;
  double _importProgress = 0.0;
  bool _isBatchProcessing = false;
  ValidationResult? _lastValidationResult;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  int _retryAttempts = 0;
  static const int maxRetryAttempts = 3;

  // Getters
  List<CustomerSatisfaction> get satisfactionData => _satisfactionData;
  SatisfactionSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasData => _satisfactionData.isNotEmpty;
  String? get lastImportedFilePath => _lastImportedFilePath;
  double get importProgress => _importProgress;
  bool get isBatchProcessing => _isBatchProcessing;
  ValidationResult? get lastValidationResult => _lastValidationResult;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? get filterEndDate => _filterEndDate;
  int get retryAttempts => _retryAttempts;

  // Import file (CSV or Excel) with retry logic
  Future<bool> importFromFile(File file) async {
    try {
      _setLoading(true);
      _error = '';
      _importProgress = 0.0;
      _lastValidationResult = null;
      _retryAttempts = 0;

      return await _importWithRetry(file);
    } catch (e) {
      _error = 'Error importing file: ${e.toString()}';
      _setLoading(false);
      return false;
    }
  }

  // Helper method for import with retry logic
  Future<bool> _importWithRetry(File file) async {
    try {
      final data = await _service.importFromFile(file);

      if (data.isEmpty) {
        _error = 'No valid data found in the file';
        _setLoading(false);
        return false;
      }

      _satisfactionData = data;
      _lastImportedFilePath = file.path;
      _generateSummary();
      _setLoading(false);
      _retryAttempts = 0; // Reset retry counter on success
      return true;
    } catch (e) {
      _retryAttempts++;
      if (_retryAttempts < maxRetryAttempts) {
        // Add exponential backoff for retries
        await Future.delayed(Duration(milliseconds: 300 * _retryAttempts));
        return _importWithRetry(file);
      } else {
        _error = 'Failed after $maxRetryAttempts attempts: ${e.toString()}';
        _setLoading(false);
        return false;
      }
    }
  }

  // Import large file with batch processing and retry logic
  Future<bool> importLargeFile(File file, {int batchSize = 1000}) async {
    try {
      _setLoading(true);
      _error = '';
      _importProgress = 0.0;
      _isBatchProcessing = true;
      _lastValidationResult = null;
      _retryAttempts = 0;

      return await _importLargeWithRetry(file, batchSize);
    } catch (e) {
      _error = 'Error importing large file: ${e.toString()}';
      _setLoading(false);
      _isBatchProcessing = false;
      return false;
    }
  }

  // Helper method for large file import with retry logic
  Future<bool> _importLargeWithRetry(File file, int batchSize) async {
    try {
      // For simplicity, we'll use the regular import method
      // In a real implementation, you would read the file in chunks and process batches
      final data = await _service.importFromFile(file);

      if (data.isEmpty) {
        _error = 'No valid data found in the file';
        _setLoading(false);
        _isBatchProcessing = false;
        return false;
      }

      _satisfactionData = data;
      _lastImportedFilePath = file.path;
      _generateSummary();
      _setLoading(false);
      _isBatchProcessing = false;
      _importProgress = 1.0;
      _retryAttempts = 0; // Reset retry counter on success
      return true;
    } catch (e) {
      _retryAttempts++;
      if (_retryAttempts < maxRetryAttempts) {
        // Add exponential backoff for retries
        await Future.delayed(Duration(milliseconds: 500 * _retryAttempts));
        _updateProgress(
          _retryAttempts / maxRetryAttempts * 0.3,
        ); // Show some progress during retries
        return _importLargeWithRetry(file, batchSize);
      } else {
        _error = 'Failed after $maxRetryAttempts attempts: ${e.toString()}';
        _setLoading(false);
        _isBatchProcessing = false;
        return false;
      }
    }
  }

  // Generate sample CSV template
  Future<String> generateSampleTemplate(bool isExcel) async {
    try {
      _setLoading(true);
      final path =
          isExcel
              ? await _service.exportExcelTemplate()
              : await _service.exportSampleTemplate();
      _setLoading(false);
      return path;
    } catch (e) {
      _error = 'Error generating template: ${e.toString()}';
      _setLoading(false);
      return '';
    }
  }

  // Export data to file (CSV or Excel)
  Future<String> exportData(bool isExcel) async {
    try {
      if (_satisfactionData.isEmpty) {
        _error = 'No data to export';
        return '';
      }

      _setLoading(true);
      final filteredData = _applyDateFilter(_satisfactionData);
      final path =
          isExcel
              ? await _service.exportToExcel(filteredData)
              : await _service.exportToCSV(filteredData);
      _setLoading(false);
      return path;
    } catch (e) {
      _error = 'Error exporting data: ${e.toString()}';
      _setLoading(false);
      return '';
    }
  }

  // Apply date filtering to a list of satisfaction data
  List<CustomerSatisfaction> _applyDateFilter(List<CustomerSatisfaction> data) {
    if (_filterStartDate == null && _filterEndDate == null) {
      return data;
    }

    return data.where((item) {
      if (_filterStartDate != null &&
          item.timestamp.isBefore(_filterStartDate!)) {
        return false;
      }
      if (_filterEndDate != null && item.timestamp.isAfter(_filterEndDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  // Set date filter
  void setDateFilter(DateTime? startDate, DateTime? endDate) {
    _filterStartDate = startDate;
    _filterEndDate = endDate;
    if (_satisfactionData.isNotEmpty) {
      _generateSummary();
    }
    notifyListeners();
  }

  // Clear date filter
  void clearDateFilter() {
    _filterStartDate = null;
    _filterEndDate = null;
    if (_satisfactionData.isNotEmpty) {
      _generateSummary();
    }
    notifyListeners();
  }

  // Clear all data
  void clearData() {
    _satisfactionData = [];
    _summary = null;
    _lastImportedFilePath = null;
    _error = '';
    _importProgress = 0.0;
    _isBatchProcessing = false;
    _lastValidationResult = null;
    _filterStartDate = null;
    _filterEndDate = null;
    _retryAttempts = 0;
    notifyListeners();
  }

  // Generate summary from existing data
  void _generateSummary() {
    if (_satisfactionData.isNotEmpty) {
      final filteredData = _applyDateFilter(_satisfactionData);
      _summary = _service.generateSummary(
        filteredData,
        startDate: _filterStartDate,
        endDate: _filterEndDate,
      );
    } else {
      _summary = null;
    }
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Update progress for batch processing
  void _updateProgress(double progress) {
    _importProgress = progress;
    notifyListeners();
  }
}
