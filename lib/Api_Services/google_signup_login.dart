import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../ulitity/NetworkManager.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${NetworkManager().baseUrl}auth",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  final SharedPreferenceMethods _prefs = SharedPreferenceMethods();

  Future<String> signInWithGoogle(BuildContext context) async {
    try {
      // 🔹 Google Sign-In
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        return "User cancelled login";
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 🔹 Firebase Login
      final userCredential =
      await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) return "Firebase user null";

      // 🔹 Backend call
      final response = await _dio.post(
        "/signin/google",
        data: {
          "name": user.displayName,
          "email": user.email,
          "googleId": user.uid,
          "photo": user.photoURL,
        },
      );

      final data = response.data;

      if (response.statusCode == 200) {
        final token = data["token"];
        final userData = data["user"];

        // ✅ SAVE DATA (same as signup)
        await _prefs.saveUserId(userData["id"].toString());
        await _prefs.saveToken(token);
        await _prefs.saveUserName(userData["name"]);
        await _prefs.saveUserEmail(userData["email"]);
        await _prefs.saveUserMobileNo(userData["phone"] ?? "");
        await _prefs.saveUserGender(userData["gender"] ?? "other");
        await _prefs.saveUserCurrency(userData["currency"] ?? "₹");
        await _prefs.saveIsUserLogin(true);

        // ✅ Navigate
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (route) => false);

        return "Google Login Success";
      } else {
        return "Backend Error";
      }
    } catch (e) {
      print("eeeee ❌ ERROR: $e");
      return e.toString(); // 👈 IMPORTANT
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}


























// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
//
// import '../Api_Models/SignUp_Model.dart';
// import 'SignUp_Service.dart';
//
// class GoogleAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: "https://expense-tracker-backend-48vm.onrender.com/api/auth",
//       headers: {
//         "Content-Type": "application/json",
//       },
//     ),
//   );
//
//   final SignUpAuthService _signUpService = SignUpAuthService();
//
//   // ================= GOOGLE LOGIN + SIGNUP =================
//   Future<String> signInWithGoogle(BuildContext context) async {
//     try {
//       // 🔹 Step 1: Google Sign In
//       final GoogleSignInAccount? googleUser =
//       await _googleSignIn.signIn();
//
//       if (googleUser == null) {
//         return "User cancelled login";
//       }
//
//       // 🔹 Step 2: Get Auth details
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       // 🔹 Step 3: Firebase Login
//       final UserCredential userCredential =
//       await _auth.signInWithCredential(credential);
//
//       final user = userCredential.user;
//
//       if (user == null) {
//         return "Firebase user null";
//       }
//
//       print("🔥 FIREBASE LOGIN SUCCESS");
//       print("Name: ${user.displayName}");
//       print("Email: ${user.email}");
//       print("UID: ${user.uid}");
//
//       // ================= SEND TO BACKEND =================
//       final response = await _dio.post(
//         "/google",
//         data: {
//           "name": user.displayName,
//           "email": user.email,
//           "googleId": user.uid,
//           "photo": user.photoURL,
//         },
//       );
//
//       final data = response.data;
//
//       print("📥 BACKEND RESPONSE: $data");
//
//       // ================= SAVE + NAVIGATE =================
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final token = data["token"];
//         final userData = data["user"];
//
//         if (token == null) {
//           return "Token missing from backend";
//         }
//
//         // 🔹 reuse existing signup save logic
//         await _signUpService.signupWithSaveAndNavigate(
//           SignupRequest(
//             name: user.displayName ?? "",
//             email: user.email ?? "",
//             password: user.uid, // dummy password
//             phone: "",
//             gender: "other",
//             currency: "₹",
//           ),
//           context,
//         );
//
//         return "Google Login Success";
//       } else {
//         return "Backend Error";
//       }
//     } catch (e) {
//       print("❌ GOOGLE SIGN-IN ERROR: $e");
//       return "Google Sign-In Failed";
//     }
//   }
//
//   // ================= LOGOUT =================
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }
// }





class g{}

















// import 'package:dio/dio.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class GoogleAuthService {
//   final Dio _dio = Dio();
//
//   // ✅ Android OAuth Client ID (Google Cloud Console se)
//   static const String _androidClientId =
//       "YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com";
//
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: _androidClientId,
//     scopes: ['email', 'profile'],
//   );
//
//   // ================= GOOGLE SIGN IN =================
//   Future<String?> signInWithGoogle() async {
//     try {
//       // 🔹 Start Google Login
//       final GoogleSignInAccount? googleUser =
//       await _googleSignIn.signIn();
//
//       if (googleUser == null) {
//         return "User cancelled login";
//       }
//
//       // 🔹 Authentication data
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//
//       final String? idToken = googleAuth.idToken;
//
//       if (idToken == null) {
//         return "Failed to get ID Token";
//       }
//
//       // 🔹 Basic user info
//       final String? fullName = googleUser.displayName;
//       final String email = googleUser.email;
//       final String? profileImage = googleUser.photoUrl;
//       final String googleId = googleUser.id;
//
//       print("GOOGLE LOGIN SUCCESS");
//       print("Name: $fullName");
//       print("Email: $email");
//       print("Google ID: $googleId");
//
//       // 🔹 Send ID TOKEN to backend
//       final response = await _dio.post(
//         "https://your-backend-url.com/api/auth/google",
//         data: {
//           "idToken": idToken,
//         },
//         options: Options(
//           headers: {
//             "Content-Type": "application/json",
//           },
//         ),
//       );
//
//       // 🔹 Backend response
//       final data = response.data;
//
//       // ================= SAVE DATA LOCALLY =================
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool("isLogin", true);
//       await prefs.setString("userName", fullName ?? "");
//       await prefs.setString("userEmail", email);
//       await prefs.setString("googleId", googleId);
//       await prefs.setString("profileImage", profileImage ?? "");
//       await prefs.setString("appToken", data['token']); // JWT from backend
//
//       return "Login Success";
//     } catch (e) {
//       print("Google Sign-In Error: $e");
//       return "Google Sign-In Failed";
//     }
//   }
//
//   // ================= LOGOUT =================
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }