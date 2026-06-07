// signup_model.dart
import 'dart:convert';

class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String gender;
  final String currency;

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "phone": phone,
    "gender": gender,
    "currency": currency,
  };
}

class SignupResponse {
  final bool success;
  final String message;
  final String? token;
  final Map<String, dynamic>? user;

  SignupResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  factory SignupResponse.fromJson(dynamic json) {
    try {
      if (json is Map<String, dynamic>) {
        return SignupResponse(
          success: json["success"] ?? false,
          message: json["message"] ?? "Signup successful",
          token: json["data"]?["token"],
          user: json["data"]?["user"],
        );
      }

      return SignupResponse(success: false, message: "Invalid response");
    } catch (e) {
      return SignupResponse(success: false, message: "Parse error: $e");
    }
  }
}




















// import 'dart:convert';
//
// class SignupRequest {
//   final String name;
//   final String email;
//   final String password;
//   final String phone;
//   final String gender;
//   final String currency;
//
//   SignupRequest({
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.phone,
//     required this.gender,
//     required this.currency,
//   });
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "email": email,
//     "password": password,
//     "phone": phone,
//     "gender": gender,
//     "currency": currency,
//   };
// }
//
// class SignupResponse {
//   final bool success;
//   final String message;
//   final String? token;
//   final Map<String, dynamic>? userData;
//
//   SignupResponse({
//     required this.success,
//     required this.message,
//     this.token,
//     this.userData,
//   });
//
//   /// ✅ Updated version — handles both String and Map safely
//   factory SignupResponse.fromJson(dynamic json) {
//     try {
//       // Case 1: If backend returns a plain string message
//       if (json is String) {
//         final raw = json.trim();
//         if (raw.isEmpty) {
//           return SignupResponse(success: false, message: "Empty response");
//         }
//
//         // Try parsing string into JSON if possible
//         try {
//           final decoded = jsonDecode(raw);
//           return SignupResponse.fromJson(decoded);
//         } catch (_) {
//           // If not a valid JSON, treat as plain message
//           return SignupResponse(success: true, message: raw);
//         }
//       }
//
//       // Case 2: Normal Map response
//       if (json is Map<String, dynamic>) {
//         return SignupResponse(
//           success: json["success"] == true || json["status"] == true,
//           message: json["message"]?.toString() ??
//               json["msg"]?.toString() ??
//               "Signup successful.",
//           token: json["token"]?.toString(),
//           userData: json["user"] is Map<String, dynamic>
//               ? json["user"]
//               : (json["data"] is Map<String, dynamic> ? json["data"] : null),
//         );
//       }
//
//       // Case 3: Unexpected format
//       return SignupResponse(success: false, message: "Invalid response format.");
//     } catch (e) {
//       return SignupResponse(success: false, message: "Parse error: $e");
//     }
//   }
// }
//

























// // signup_model.dart
// class SignupRequest {
//   final String name;
//   final String email;
//   final String password;
//   final String phone;
//   final String gender;
//   final String currency;
//
//   SignupRequest({
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.phone,
//     required this.gender,
//     required this.currency,
//   });
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "email": email,
//     "password": password,
//     "phone": phone,
//     "gender": gender,
//     "currency": currency,
//   };
// }
//
// class SignupResponse {
//   final bool success;
//   final String message;
//   final String? token;
//   final Map<String, dynamic>? userData;
//
//   SignupResponse({
//     required this.success,
//     required this.message,
//     this.token,
//     this.userData,
//   });
//
//   factory SignupResponse.fromJson(Map<String, dynamic> json) {
//     return SignupResponse(
//       success: json["success"] ?? false,
//       message: json["message"] ?? '',
//       token: json["token"],
//       userData: json["user"],
//     );
//   }
// }
