class CustomerSatisfaction {
  final String customerId;
  final String agentId;
  final DateTime timestamp;
  final int satisfactionScore; // 1-5 rating
  final String feedback;
  final int duration; // in seconds
  final String category;

  CustomerSatisfaction({
    required this.customerId,
    required this.agentId,
    required this.timestamp,
    required this.satisfactionScore,
    this.feedback = '',
    required this.duration,
    required this.category,
  });

  factory CustomerSatisfaction.fromCsv(Map<String, dynamic> data) {
    return CustomerSatisfaction(
      customerId: data['customer_id'] ?? '',
      agentId: data['agent_id'] ?? '',
      timestamp: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
      satisfactionScore: int.tryParse(data['satisfaction_score'] ?? '0') ?? 0,
      feedback: data['feedback'] ?? '',
      duration: int.tryParse(data['duration'] ?? '0') ?? 0,
      category: data['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerId,
      'agent_id': agentId,
      'timestamp': timestamp.toIso8601String(),
      'satisfaction_score': satisfactionScore,
      'feedback': feedback,
      'duration': duration,
      'category': category,
    };
  }
}

class SatisfactionSummary {
  final double averageScore;
  final int totalInteractions;
  final Map<String, int> scoreDistribution;
  final Map<String, double> categoryAverages;
  final List<CustomerSatisfaction> topRatedInteractions;
  final List<CustomerSatisfaction> lowRatedInteractions;

  SatisfactionSummary({
    required this.averageScore,
    required this.totalInteractions,
    required this.scoreDistribution,
    required this.categoryAverages,
    required this.topRatedInteractions,
    required this.lowRatedInteractions,
  });
}
