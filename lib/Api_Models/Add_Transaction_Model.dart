// CHANGE: Single model representing API `data` object for a Transaction
// NEW: fromJson/toJson with nullable invoice handling

class TransactionModel {
  final String? id;
  final String userId;
  final String item;
  final double amount;
  final String? invoice;
  final String? paymentMethod;
  final String? status;
  final DateTime? date;
  final String? createdAt;
  final String? type;
  final String? icon;
  final String? category;


  TransactionModel({
    this.id,
    required this.userId,
    required this.item,
    required this.amount,
    required this.invoice,
    required this.type,
    required this.icon,
    required this.category,
    this.paymentMethod,
    this.status,
    this.date,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] as String?,
      userId: (json['userId'] ?? json['user']) as String? ?? '',
      item: (json['item'] ?? '') as String,
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : double.tryParse('${json['amount']}') ?? 0.0,
      invoice: json['invoice'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      status: json['status'] as String?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      createdAt: json['createdAt'] as String?,
      type: json['type'] as String?,
      icon: json['icon'] as String?,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "item": item,
      "amount": amount,
      "type": type,
      "icon": icon,
      "category": category,
      if (invoice != null) "invoice": invoice,
    };
  }
}

