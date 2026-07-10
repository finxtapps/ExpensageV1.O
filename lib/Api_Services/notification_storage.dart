import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class NotificationStorage {
  static const String key = "notifications";

  // UI Refresh Notifier
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  /// Save Notification
  static Future<void> saveNotification({
    required String title,
    required String body,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> notifications = prefs.getStringList(key) ?? [];

    notifications.insert(
      0,
      jsonEncode({
        "title": title,
        "body": body,
        "time": DateTime.now().toString(),
        "isRead": false,
      }),
    );

    await prefs.setStringList(key, notifications);

    print("Notification Saved");

    // Notify UI
    notifier.value++;
  }

  /// Get Notifications
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> notifications = prefs.getStringList(key) ?? [];

    return notifications
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();
  }

  /// Mark One As Read
  static Future<void> markAsRead(int index) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> notifications = prefs.getStringList(key) ?? [];

    List<Map<String, dynamic>> list = notifications
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();

    if (index < list.length) {
      list[index]["isRead"] = true;
    }

    await prefs.setStringList(
      key,
      list.map((e) => jsonEncode(e)).toList(),
    );

    notifier.value++;
  }

  /// Mark All As Read
  static Future<void> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> notifications = prefs.getStringList(key) ?? [];

    List<Map<String, dynamic>> list = notifications
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();

    for (var item in list) {
      item["isRead"] = true;
    }

    await prefs.setStringList(
      key,
      list.map((e) => jsonEncode(e)).toList(),
    );

    notifier.value++;
  }

  /// Clear Notifications
  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);

    notifier.value++;
  }
}











// class NotificationStorage {
//   static const String key = "notifications";
//
//
//
//
//   static Future<void> saveNotification({
//     required String title,
//     required String body,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     List<String> notifications = prefs.getStringList(key) ?? [];
//
//     notifications.insert(
//       0,
//       jsonEncode({
//         "title": title,
//         "body": body,
//         "time": DateTime.now().toString(),
//         "isRead": false,
//       }),
//     );
//
//     await prefs.setStringList(key, notifications);
//
//     print("Notification Saved");
//     print(await prefs.getStringList(key));
//   }
//
//
//
//
//
//
//   // static Future<void> saveNotification({
//   //   required String title,
//   //   required String body,
//   // }) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //
//   //   List<String> notifications = prefs.getStringList(key) ?? [];
//   //
//   //   notifications.insert(
//   //     0,
//   //     jsonEncode({
//   //       "title": title,
//   //       "body": body,
//   //       "time": DateTime.now().toString(),
//   //       "isRead": false, // ✅ NEW
//   //     }),
//   //   );
//   //
//   //   await prefs.setStringList(key, notifications);
//   // }
//
//   static Future<List<Map<String, dynamic>>> getNotifications() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     List<String> notifications = prefs.getStringList(key) ?? [];
//
//     return notifications
//         .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
//         .toList();
//   }
//
//   // ✅ Mark single as read
//   static Future<void> markAsRead(int index) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     List<String> notifications = prefs.getStringList(key) ?? [];
//
//     List<Map<String, dynamic>> list = notifications
//         .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
//         .toList();
//
//     list[index]["isRead"] = true;
//
//     await prefs.setStringList(
//       key,
//       list.map((e) => jsonEncode(e)).toList(),
//     );
//   }
//
//   // ✅ Read All
//   static Future<void> markAllAsRead() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     List<String> notifications = prefs.getStringList(key) ?? [];
//
//     List<Map<String, dynamic>> list = notifications
//         .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
//         .toList();
//
//     for (var item in list) {
//       item["isRead"] = true;
//     }
//
//     await prefs.setStringList(
//       key,
//       list.map((e) => jsonEncode(e)).toList(),
//     );
//   }
//
//   static Future<void> clearNotifications() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(key);
//   }
// }















// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationStorage {
//
//   static const String key = "notifications";
//
//   static Future<void> saveNotification({
//     required String title,
//     required String body,
//   }) async {
//
//     final prefs = await SharedPreferences.getInstance();
//
//     List<String> notifications =
//         prefs.getStringList(key) ?? [];
//
//     notifications.insert(
//       0,
//       jsonEncode({
//         "title": title,
//         "body": body,
//         "time": DateTime.now().toString(),
//       }),
//     );
//
//     await prefs.setStringList(
//       key,
//       notifications,
//     );
//   }
//
//   static Future<List<Map<String, dynamic>>>
//   getNotifications() async {
//
//     final prefs =
//     await SharedPreferences.getInstance();
//
//     List<String> notifications =
//         prefs.getStringList(key) ?? [];
//
//     return notifications
//         .map(
//           (e) => Map<String, dynamic>.from(
//         jsonDecode(e),
//       ),
//     )
//         .toList();
//   }
//
//
//
//   static Future<void> clearNotifications() async {
//     final prefs =
//     await SharedPreferences.getInstance();
//
//     await prefs.remove(key);
//   }
// }