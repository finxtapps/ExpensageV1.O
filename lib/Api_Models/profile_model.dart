class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePicture;
  final String gender;
  final String currency;
  final String? referredBy;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePicture,
    required this.gender,
    required this.currency,
    this.referredBy,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      gender: json['gender'] ?? '',
      currency: json['currency'] ?? '',
      referredBy: json['referredBy'],
    );
  }
}































// class ProfileModel {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String profilePic;
//   final String gender;
//   final String currency;
//   final String? referredBy;
//
//   ProfileModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.profilePic,
//     required this.gender,
//     required this.currency,
//     this.referredBy,
//   });
//
//   factory ProfileModel.fromJson(Map<String, dynamic> json) {
//     return ProfileModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       profilePic: json['profilePic'] ?? '',
//       gender: json['gender'] ?? '',
//       currency: json['currency'] ?? '',
//       referredBy: json['referredBy'],
//     );
//   }
// }
