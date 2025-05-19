import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/customer_satisfaction.dart';

enum FileValidationError {
  missingHeaders,
  invalidFormat,
  emptyFile,
  missingRequiredFields,
  invalidDataType,
  none,
}

class ValidationResult {
  final bool isValid;
  final FileValidationError errorType;
  final String errorMessage;
  final List<String> warningMessages;

  ValidationResult({
    required this.isValid,
    this.errorType = FileValidationError.none,
    this.errorMessage = '',
    this.warningMessages = const [],
  });

  factory ValidationResult.valid() {
    return ValidationResult(isValid: true);
  }

  factory ValidationResult.invalid(
    FileValidationError errorType,
    String errorMessage, {
    List<String> warningMessages = const [],
  }) {
    return ValidationResult(
      isValid: false,
      errorType: errorType,
      errorMessage: errorMessage,
      warningMessages: warningMessages,
    );
  }
}

class CsvImportService {
  // Required headers for valid import files
  final List<String> _requiredHeaders = [
    'customer_id',
    'agent_id',
    'timestamp',
    'satisfaction_score',
    'duration',
    'category',
  ];

  // Import from file (handles both CSV and Excel)
  Future<List<CustomerSatisfaction>> importFromFile(File file) async {
    try {
      final extension = path.extension(file.path).toLowerCase();

      // Validate the file extension
      ValidationResult validationResult = _validateFileExtension(extension);
      if (!validationResult.isValid) {
        debugPrint('File validation error: ${validationResult.errorMessage}');
        return [];
      }

      if (extension == '.csv') {
        return await importFromCsvFile(file);
      } else if (extension == '.xlsx') {
        return await importFromExcelFile(file);
      } else {
        debugPrint('Unsupported file extension: $extension');
        return [];
      }
    } catch (e) {
      debugPrint('Error importing file: $e');
      return [];
    }
  }

  // Import CSV data from a file
  Future<List<CustomerSatisfaction>> importFromCsvFile(File file) async {
    try {
      final String fileContent = await file.readAsString();

      // Validate CSV content
      final ValidationResult validationResult = _validateCsvContent(
        fileContent,
      );
      if (!validationResult.isValid) {
        debugPrint('CSV validation error: ${validationResult.errorMessage}');
        return [];
      }

      return _processRawCsvData(fileContent);
    } catch (e) {
      debugPrint('Error importing CSV: $e');
      return [];
    }
  }

  // Import Excel data from a file
  Future<List<CustomerSatisfaction>> importFromExcelFile(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      // Get the first sheet
      if (excel.tables.isEmpty) {
        debugPrint('Excel file has no sheets');
        return [];
      }

      final sheet = excel.tables.entries.first.value;

      // Validate the Excel sheet
      final ValidationResult validationResult = _validateExcelSheet(sheet);
      if (!validationResult.isValid) {
        debugPrint('Excel validation error: ${validationResult.errorMessage}');
        return [];
      }

      // Process the Excel data
      return _processExcelSheet(sheet);
    } catch (e) {
      debugPrint('Error importing Excel: $e');
      return [];
    }
  }

  // Process raw CSV data string
  List<CustomerSatisfaction> _processRawCsvData(String csvData) {
    try {
      List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter()
          .convert(csvData);

      // Get headers from the first row
      List<String> headers =
          rowsAsListOfValues[0]
              .map((item) => item.toString().toLowerCase())
              .toList();

      // Process the rest of the rows
      List<CustomerSatisfaction> results = [];

      for (int i = 1; i < rowsAsListOfValues.length; i++) {
        Map<String, dynamic> rowData = {};

        // Create a map of header -> value
        for (int j = 0; j < headers.length; j++) {
          if (j < rowsAsListOfValues[i].length) {
            rowData[headers[j]] = rowsAsListOfValues[i][j].toString();
          } else {
            rowData[headers[j]] = '';
          }
        }

        // Create CustomerSatisfaction object from the map
        results.add(CustomerSatisfaction.fromCsv(rowData));
      }

      return results;
    } catch (e) {
      debugPrint('Error processing CSV data: $e');
      return [];
    }
  }

  // Process Excel sheet
  List<CustomerSatisfaction> _processExcelSheet(Sheet sheet) {
    try {
      // Get headers from the first row
      List<String> headers = [];
      for (int col = 0; col < sheet.maxCols; col++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
        );
        headers.add(cell.value?.toString().toLowerCase() ?? '');
      }

      // Process the rest of the rows
      List<CustomerSatisfaction> results = [];

      for (int row = 1; row < sheet.maxRows; row++) {
        Map<String, dynamic> rowData = {};

        // Create a map of header -> value
        for (int col = 0; col < headers.length; col++) {
          if (col < sheet.maxCols) {
            final cell = sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
            );
            rowData[headers[col]] = cell.value?.toString() ?? '';
          } else {
            rowData[headers[col]] = '';
          }
        }

        // Create CustomerSatisfaction object from the map
        results.add(CustomerSatisfaction.fromCsv(rowData));
      }

      return results;
    } catch (e) {
      debugPrint('Error processing Excel data: $e');
      return [];
    }
  }

  // Validate file extension
  ValidationResult _validateFileExtension(String extension) {
    if (extension != '.csv' && extension != '.xlsx') {
      return ValidationResult.invalid(
        FileValidationError.invalidFormat,
        'Unsupported file format. Please use CSV or Excel (.xlsx) files.',
      );
    }
    return ValidationResult.valid();
  }

  // Validate CSV content
  ValidationResult _validateCsvContent(String csvData) {
    if (csvData.isEmpty) {
      return ValidationResult.invalid(
        FileValidationError.emptyFile,
        'The file is empty.',
      );
    }

    // Check if there's at least a header row
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);
    if (rows.isEmpty) {
      return ValidationResult.invalid(
        FileValidationError.emptyFile,
        'The file contains no data.',
      );
    }

    // Check if the file has the required headers
    List<String> headers =
        rows[0].map((e) => e.toString().toLowerCase()).toList();
    final missingHeaders =
        _requiredHeaders.where((h) => !headers.contains(h)).toList();

    if (missingHeaders.isNotEmpty) {
      return ValidationResult.invalid(
        FileValidationError.missingRequiredFields,
        'Missing required headers: ${missingHeaders.join(", ")}',
      );
    }

    return ValidationResult.valid();
  }

  // Validate Excel sheet
  ValidationResult _validateExcelSheet(Sheet sheet) {
    if (sheet.maxRows == 0) {
      return ValidationResult.invalid(
        FileValidationError.emptyFile,
        'The Excel sheet is empty.',
      );
    }

    // Check if there's at least a header row
    if (sheet.maxRows < 2) {
      return ValidationResult.invalid(
        FileValidationError.emptyFile,
        'The Excel sheet contains only headers but no data.',
      );
    }

    // Check if the file has the required headers
    List<String> headers = [];
    for (int col = 0; col < sheet.maxCols; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );
      headers.add(cell.value?.toString().toLowerCase() ?? '');
    }

    final missingHeaders =
        _requiredHeaders.where((h) => !headers.contains(h)).toList();

    if (missingHeaders.isNotEmpty) {
      return ValidationResult.invalid(
        FileValidationError.missingRequiredFields,
        'Missing required headers: ${missingHeaders.join(", ")}',
      );
    }

    return ValidationResult.valid();
  }

  // Generate summary statistics from customer satisfaction data
  SatisfactionSummary generateSummary(
    List<CustomerSatisfaction> data, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (data.isEmpty) {
      return SatisfactionSummary(
        averageScore: 0,
        totalInteractions: 0,
        scoreDistribution: {},
        categoryAverages: {},
        topRatedInteractions: [],
        lowRatedInteractions: [],
      );
    }

    // Filter data by date range if specified
    List<CustomerSatisfaction> filteredData = data;
    if (startDate != null || endDate != null) {
      filteredData =
          data.where((item) {
            if (startDate != null && item.timestamp.isBefore(startDate)) {
              return false;
            }
            if (endDate != null && item.timestamp.isAfter(endDate)) {
              return false;
            }
            return true;
          }).toList();
    }

    if (filteredData.isEmpty) {
      return SatisfactionSummary(
        averageScore: 0,
        totalInteractions: 0,
        scoreDistribution: {},
        categoryAverages: {},
        topRatedInteractions: [],
        lowRatedInteractions: [],
      );
    }

    // Calculate average score
    double totalScore = 0;
    Map<String, int> scoreDistribution = {
      '1': 0,
      '2': 0,
      '3': 0,
      '4': 0,
      '5': 0,
    };

    Map<String, List<int>> categoryScores = {};

    for (var item in filteredData) {
      totalScore += item.satisfactionScore;

      // Update score distribution
      scoreDistribution[item.satisfactionScore.toString()] =
          (scoreDistribution[item.satisfactionScore.toString()] ?? 0) + 1;

      // Group scores by category
      if (!categoryScores.containsKey(item.category)) {
        categoryScores[item.category] = [];
      }
      categoryScores[item.category]!.add(item.satisfactionScore);
    }

    // Calculate average by category
    Map<String, double> categoryAverages = {};
    categoryScores.forEach((category, scores) {
      double sum = scores.fold(
        0,
        (previousValue, score) => previousValue + score,
      );
      categoryAverages[category] = sum / scores.length;
    });

    // Sort data to find top and bottom interactions
    final sortedData = List<CustomerSatisfaction>.from(filteredData);
    sortedData.sort(
      (a, b) => b.satisfactionScore.compareTo(a.satisfactionScore),
    );

    final topRatedInteractions = sortedData.take(5).toList();
    final lowRatedInteractions = sortedData.reversed.take(5).toList();

    return SatisfactionSummary(
      averageScore: totalScore / filteredData.length,
      totalInteractions: filteredData.length,
      scoreDistribution: scoreDistribution,
      categoryAverages: categoryAverages,
      topRatedInteractions: topRatedInteractions,
      lowRatedInteractions: lowRatedInteractions,
    );
  }

  // Process batch of data for large files
  Future<List<CustomerSatisfaction>> processBatch(
    List<Map<String, dynamic>> batch,
  ) async {
    return batch
        .map((rowData) => CustomerSatisfaction.fromCsv(rowData))
        .toList();
  }

  // Export satisfaction data to CSV
  Future<String> exportToCSV(List<CustomerSatisfaction> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('$path/satisfaction_export_$timestamp.csv');

      // Create CSV header
      final headers =
          'customer_id,agent_id,timestamp,satisfaction_score,feedback,duration,category\n';

      // Create CSV rows
      final rows = data
          .map((item) {
            return '${item.customerId},${item.agentId},${item.timestamp.toIso8601String()},${item.satisfactionScore},"${item.feedback.replaceAll('"', '""')}",${item.duration},${item.category}\n';
          })
          .join('');

      // Write to file
      await file.writeAsString(headers + rows);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting to CSV: $e');
      return '';
    }
  }

  // Export satisfaction data to Excel
  Future<String> exportToExcel(List<CustomerSatisfaction> data) async {
    try {
      final excel = Excel.createExcel();
      final Sheet sheet = excel['Customer Satisfaction Data'];

      // Add headers
      final headers = [
        'customer_id',
        'agent_id',
        'timestamp',
        'satisfaction_score',
        'feedback',
        'duration',
        'category',
      ];
      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }

      // Add data rows
      for (int row = 0; row < data.length; row++) {
        final item = data[row];
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row + 1))
            .value = item.customerId;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row + 1))
            .value = item.agentId;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row + 1))
            .value = item.timestamp.toIso8601String();
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row + 1))
            .value = item.satisfactionScore;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row + 1))
            .value = item.feedback;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row + 1))
            .value = item.duration;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row + 1))
            .value = item.category;
      }

      // Save the excel file
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('$path/satisfaction_export_$timestamp.xlsx');

      await file.writeAsBytes(excel.encode()!);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting to Excel: $e');
      return '';
    }
  }

  // Export sample CSV template
  Future<String> exportSampleTemplate() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/satisfaction_template.csv');

      const String headers =
          'customer_id,agent_id,timestamp,satisfaction_score,feedback,duration,category\n';
      const String sampleRow1 =
          'CUST001,AGENT005,2023-10-15T14:30:00,5,Great service!,320,Support\n';
      const String sampleRow2 =
          'CUST002,AGENT003,2023-10-15T15:45:00,3,Average experience,180,Sales\n';

      final String template = headers + sampleRow1 + sampleRow2;
      await file.writeAsString(template);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting sample template: $e');
      return '';
    }
  }

  // Export sample Excel template
  Future<String> exportExcelTemplate() async {
    try {
      final excel = Excel.createExcel();
      final Sheet sheet = excel['Template'];

      // Add headers
      final headers = [
        'customer_id',
        'agent_id',
        'timestamp',
        'satisfaction_score',
        'feedback',
        'duration',
        'category',
      ];
      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }

      // Add sample rows
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
          .value = 'CUST001';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
          .value = 'AGENT005';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1))
          .value = '2023-10-15T14:30:00';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1))
          .value = 5;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1))
          .value = 'Great service!';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1))
          .value = 320;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1))
          .value = 'Support';

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2))
          .value = 'CUST002';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 2))
          .value = 'AGENT003';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 2))
          .value = '2023-10-15T15:45:00';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 2))
          .value = 3;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 2))
          .value = 'Average experience';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 2))
          .value = 180;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 2))
          .value = 'Sales';

      // Save the excel file
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/satisfaction_template.xlsx');

      await file.writeAsBytes(excel.encode()!);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting Excel template: $e');
      return '';
    }
  }
}
