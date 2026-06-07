import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

class LinkedInAuthService {
  final Dio _dio = Dio();

  final String clientId = "78dv2vav4wmfa3";
   final String clientSecret = "";
  final String redirectUrl = "https://www.linkedin.com/developers/tools/oauth/redirect";
    //  "com.finxtapp.expensage://callback";

  Future<String?> signInWithLinkedIn(BuildContext context) async {
    String? backendMessage;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LinkedInUserWidget(
          redirectUrl: redirectUrl,
          clientId: clientId,
          clientSecret: clientSecret,

          onGetUserProfile: (UserSucceededAction userData) async {
            final linkedinUser = userData.user;

            /// ACCESS TOKEN
            final token = linkedinUser.token?.accessToken;

            /// FIRST & LAST NAME
            final firstName = linkedinUser.firstName?.localized?.label ?? "";
            final lastName = linkedinUser.lastName?.localized?.label ?? "";

            /// FULL NAME
            final fullName = "$firstName $lastName".trim();

            /// EMAIL
            final email = linkedinUser.email?.elements?.first?.handleDeep?.emailAddress ?? "";

            /// PROFILE IMAGE
            final profilePic = linkedinUser.profilePicture
                ?.displayImageContent
                ?.elements
                ?.first
                ?.identifiers
                ?.first
                ?.identifier ??
                "";

            /// LINKEDIN USER ID
            final linkedInId = linkedinUser.userId;

            print("===== LINKEDIN USER DATA =====");
            print("ID: $linkedInId");
            print("Full Name: $fullName");
            print("Email: $email");
            print("Profile Pic: $profilePic");
            print("Access Token: $token");

            backendMessage = await sendToBackend(
              linkedInId: linkedInId,
              accessToken: token,
              fullName: fullName,
              email: email,
              profilePic: profilePic,
            );

            Navigator.pop(context);
          },

          onError: (UserFailedAction error) {
            backendMessage = "LinkedIn Login Error: ${error.toString()}";
          },
        ),
      ),
    );

    return backendMessage ?? "Something went wrong!";
  }

  /// SEND DATA TO BACKEND
  Future<String?> sendToBackend({
    required String? linkedInId,
    required String? accessToken,
    required String? fullName,
    required String? email,
    required String? profilePic,
  }) async {
    if (accessToken == null) return "No access token received";

    final res = await _dio.post(
      "https://your-backend-url.com/api/auth/linkedin",
      data: {
        "linkedInId": linkedInId,
        "accessToken": accessToken,
        "fullName": fullName,
        "email": email,
        "profilePic": profilePic,
      },
    );

    print("SERVER RESPONSE: ${res.data}");

    return res.data["message"] ?? "Login success";
  }
}

















// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:linkedin_login/linkedin_login.dart';
//
// class LinkedInAuthService {
//   final Dio _dio = Dio();
//
//   final String clientId = "YOUR_CLIENT_ID";
//   final String redirectUrl = "YOUR_REDIRECT_URL";
//
//   Future<void> signInWithLinkedIn(BuildContext context) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LinkedInUserWidget(
//           redirectUrl: redirectUrl,
//           clientId: clientId,
//           clientSecret: clientSecret,
//
//           onGetUserProfile: (UserSucceededAction userData) async {
//             final LinkedInTokenObject? token = userData.user.token;  // <-- NEW
//
//             if (token != null) {
//               print("ACCESS TOKEN: ${token.accessToken}");
//
//               await sendToBackend(token.accessToken);
//             }
//
//             Navigator.pop(context);
//           },
//
//           onError: (UserFailedAction error) {
//             print("LINKEDIN LOGIN ERROR: ${error.toString()}");
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<void> sendToBackend(String? accessToken) async {
//     if (accessToken == null) return;
//
//     final res = await _dio.post(
//       "https://your-backend-url.com/api/auth/linkedin",
//       data: {
//         "accessToken": accessToken,
//       },
//     );
//
//     print("SERVER RESPONSE: ${res.data}");
//   }
// }
