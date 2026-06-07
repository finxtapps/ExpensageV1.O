class BarGraphResponse {
  final bool success;
  final String message;
  final String source;
  final BarGraphData data;
  final bool isUpdated;
  final DateTime lastUpdated;

  BarGraphResponse({
    required this.success,
    required this.message,
    required this.source,
    required this.data,
    required this.isUpdated,
    required this.lastUpdated,
  });

  factory BarGraphResponse.fromJson(Map<String, dynamic> json) {
    return BarGraphResponse(
      success: json['success'],
      message: json['message'],
      source: json['source'],
      data: BarGraphData.fromJson(json['data']),
      isUpdated: json['isUpdated'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class BarGraphData {
  final Map<String, int> weeklyExpenses;
  final Map<String, int> monthlyExpenses;
  final Map<String, int> yearlyTotal;

  BarGraphData({
    required this.weeklyExpenses,
    required this.monthlyExpenses,
    required this.yearlyTotal,
  });

  factory BarGraphData.fromJson(Map<String, dynamic> json) {
    return BarGraphData(
      weeklyExpenses: Map<String, int>.from(
        json['Last 28 days']['Monthly Expense'],
      ),
      monthlyExpenses: Map<String, int>.from(
        json['Last 12 months']['Year Expenses'],
      ),
      yearlyTotal: Map<String, int>.from(
        json['Total Expenses year wise'],
      ),
    );
  }
}
