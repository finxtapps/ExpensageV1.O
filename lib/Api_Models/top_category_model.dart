class TopCategoryResponse {
  final bool success;
  final String message;
  final String period;
  final int count;
  final int totalExpenses;
  final HighestExpense? highestExpense;
  final List<TopCategoryItem> data;

  TopCategoryResponse({
    required this.success,
    required this.message,
    required this.period,
    required this.count,
    required this.totalExpenses,
    required this.highestExpense,
    required this.data,
  });

  factory TopCategoryResponse.fromJson(Map<String, dynamic> json) {
    return TopCategoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      period: json['period'] ?? '',
      count: json['count'] ?? 0,
      totalExpenses: json['totalExpenses'] ?? 0,
      highestExpense: json['highestExpense'] != null
          ? HighestExpense.fromJson(json['highestExpense'])
          : null,
      data: json['data'] != null
          ? List<TopCategoryItem>.from(
        json['data'].map((x) => TopCategoryItem.fromJson(x)),
      )
          : [],
    );
  }
}



class HighestExpense {
  final String category;
  final int percentage;
  final int amount;

  HighestExpense({
    required this.category,
    required this.percentage,
    required this.amount,
  });

  factory HighestExpense.fromJson(Map<String, dynamic> json) {
    return HighestExpense(
      category: json['category'] ?? '',
      percentage: json['percentage'] ?? 0,
      amount: json['amount'] ?? 0,
    );
  }
}



class TopCategoryItem {
  final int rank;
  final String category;
  final int totalAmount;
  final int count;
  final int percentage;

  TopCategoryItem({
    required this.rank,
    required this.category,
    required this.totalAmount,
    required this.count,
    required this.percentage,
  });

  factory TopCategoryItem.fromJson(Map<String, dynamic> json) {
    return TopCategoryItem(
      rank: json['rank'] ?? 0,
      category: json['category'] ?? '',
      totalAmount: json['totalAmount'] ?? 0,
      count: json['count'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }
}