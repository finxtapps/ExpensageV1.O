import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../ulitity/NetworkManager.dart';


class NotificationService {

  static Future<void> registerFCMToken() async {
    try {

      String? authToken =
      await SharedPreferenceMethods().getToken();

      if (authToken == null) {
        print("Auth Token Not Found");
        return;
      }

      String? fcmToken =
      await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        print("FCM Token Not Found");
        return;
      }

      print("FCM TOKEN => $fcmToken");

      final response = await Dio().post(
        "${NetworkManager().baseUrl}notifications/token/register",
        data: {
          "fcmToken": fcmToken,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
        ),
      );

      print("FCM REGISTER RESPONSE => ${response.data}");

    } catch (e) {
      print("FCM REGISTER ERROR => $e");
    }
  }

  static Future<void> removeFCMToken() async {
    try {

      String? authToken =
      await SharedPreferenceMethods().getToken();

      if (authToken == null) return;

      await Dio().delete(
        "${NetworkManager().baseUrl}notifications/token",
        options: Options(
          headers: {
            "Authorization": "Bearer $authToken",
          },
        ),
      );

    } catch (e) {
      print("REMOVE TOKEN ERROR => $e");
    }
  }
}