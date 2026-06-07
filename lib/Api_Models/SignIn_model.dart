class LoginResponse {
  final bool success;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: LoginData.fromJson(json['data'] ?? {}),
    );
  }
}

class LoginData {
  final User user;
  final String token;

  LoginData({
    required this.user,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json['user'] ?? {}),
      token: json['token']?.toString() ?? "",
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? gender;
  final String? currency;
  final String profilePicture;
  final String authProvider;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.currency,
    required this.profilePicture,
    required this.authProvider,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      email: json['email']?.toString() ?? "",
      phone: json['phone']?.toString(),        // null allowed
      gender: json['gender']?.toString(),      // null allowed
      currency: json['currency']?.toString(),  // null allowed
      profilePicture: json['profilePicture'] ?? '',
      authProvider: json['authProvider']?.toString() ?? "",
      createdAt: json['createdAt']?.toString() ?? "",
      updatedAt: json['updatedAt']?.toString() ?? "",
    );
  }
}











// class LoginResponse {
//   final bool success;
//   final String message;
//   final UserData data;
//
//   LoginResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: UserData.fromJson(json['data']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data.toJson(),
//     };
//   }
// }
//
// class UserData {
//   final User user;
//
//   UserData({required this.user});
//
//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       user: User.fromJson(json['user']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'user': user.toJson(),
//     };
//   }
// }
//
// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String gender;
//   final String currency;
//   final String? profilePicture;
//   final String authProvider;
//
//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.gender,
//     required this.currency,
//     this.profilePicture,
//     required this.authProvider,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       gender: json['gender'] ?? '',
//       currency: json['currency'] ?? '',
//       profilePicture: json['profilePicture'],
//       authProvider: json['authProvider'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'gender': gender,
//       'currency': currency,
//       'profilePicture': profilePicture,
//       'authProvider': authProvider,
//     };
//   }
// }
















// class LoginResponse {
//   final bool success;
//   final String message;
//   final String? token;
//   final UserData? user;
//
//   LoginResponse({
//     required this.success,
//     required this.message,
//     this.token,
//     this.user,
//   });
//
//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       token: json['token'],
//       user: json['user'] != null ? UserData.fromJson(json['user']) : null,
//     );
//   }
// }
//
// class UserData {
//   final String id;
//   final String name;
//   final String email;
//   final String? phone;
//
//   UserData({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.phone,
//   });
//
//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'],
//     );
//   }
// }
