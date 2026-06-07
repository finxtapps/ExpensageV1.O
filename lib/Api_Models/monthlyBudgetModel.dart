class BudgetModel {
  final String id;
  final String userId;
  final int totalBudget;
  final String currency;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.totalBudget,
    required this.currency,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    print("vvvvvvvvvv BudgetModel.fromJson called");
    print("vvvvvvvvvv Raw JSON: $json");

    final parsedUserId = json['userId'] is Map
        ? json['userId']['_id']
        : json['userId'];

    final parsedTotalBudget = json['totalBudget'] ?? 0;

    print("vvvvvvvvvv Parsed userId: $parsedUserId");
    print("vvvvvvvvvv Parsed totalBudget: $parsedTotalBudget");

    return BudgetModel(
      id: json['_id'] ?? '',
      userId: parsedUserId ?? '',
      totalBudget: parsedTotalBudget,
      currency: json['currency'] ?? 'INR',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "totalBudget": totalBudget,
    };
  }
}
