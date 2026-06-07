class IncomeTaxHelpModel {
  final String fullName;
  final String email;
  final String phone;
  final int annualIncome;
  final String? incomeStatement;

  IncomeTaxHelpModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.annualIncome,
    this.incomeStatement, // optional
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "annualIncome": annualIncome,
      if (incomeStatement != null) "incomeStatement": incomeStatement,
    };
  }

  factory IncomeTaxHelpModel.fromJson(Map<String, dynamic> json) {
    return IncomeTaxHelpModel(
      fullName: json["fullName"],
      email: json["email"],
      phone: json["phone"],
      annualIncome: json["annualIncome"],
      incomeStatement: json["incomeStatement"],
    );
  }
}
