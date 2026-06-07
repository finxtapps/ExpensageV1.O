class TransactionHistoryModel {
  bool? success;
  int? count;
  List<TransactionData>? data;

  TransactionHistoryModel({
    this.success,
    this.count,
    this.data,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryModel(
      success: json["success"],
      count: json["count"],
      data: json["data"] != null
          ? List<TransactionData>.from(
          json["data"].map((x) => TransactionData.fromJson(x)))
          : [],
    );
  }
}

class TransactionData {
  String? id;
  String? userId;
  String? title;
  num? amount;
  String? type;
  String? category;
  String? icon;
  String? note;
  String? paymentMethod;
  String? status;
  String? date;
  String? createdAt;
  String? updatedAt;

  TransactionData({
    this.id,
    this.userId,
    this.title,
    this.amount,
    this.type,
    this.category,
    this.icon,
    this.note,
    this.paymentMethod,
    this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json["_id"],
      userId: json["userId"],
      title: json["title"],
      amount: json["amount"],
      type: json["type"],
      category: json["category"],
      icon: json["icon"],
      note: json["note"],
      paymentMethod: json["paymentMethod"],
      status: json["status"],
      date: json["date"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }
}
