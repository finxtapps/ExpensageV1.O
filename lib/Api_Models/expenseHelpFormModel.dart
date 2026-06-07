class ExpenseHelpFormModel {
  final bool success;
  final String message;
  final ExpenseData? data;

  ExpenseHelpFormModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ExpenseHelpFormModel.fromJson(Map<String, dynamic> json) {
    return ExpenseHelpFormModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ExpenseData.fromJson(json['data']) : null,
    );
  }
}

class ExpenseData {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final int? annualExpense;
  final String? expenseProof;
  final String? userId;
  final String? status;
  final DateTime? submittedAt;

  ExpenseData({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.annualExpense,
    this.expenseProof,
    this.userId,
    this.status,
    this.submittedAt,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      annualExpense: json['annualExpense'],
      expenseProof: json['expenseProof'],
      userId: json['userId'],
      status: json['status'],
      submittedAt:
      json['submittedAt'] != null ? DateTime.parse(json['submittedAt']) : null,
    );
  }
}
