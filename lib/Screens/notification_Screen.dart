import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Api_Services/notification_storage.dart';
import '../component/customHeader.dart';
import '../providerListner/theme_notifier.dart';
import '../theme/header_Color.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
    NotificationStorage.notifier.addListener(_reloadNotifications);

  }

  void _reloadNotifications() {
    loadNotifications();
  }


  @override
  void dispose() {
    NotificationStorage.notifier.removeListener(_reloadNotifications);
    super.dispose();
  }

  Future<void> loadNotifications() async {
    notifications = await NotificationStorage.getNotifications();

    if (mounted) {
      setState(() {});
    }
  }

  //
  // Future<void> loadNotifications() async {
  //   notifications =
  //   await NotificationStorage.getNotifications();
  //
  //   setState(() {});
  // }
 // ✅ Constructor
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;




    return Scaffold(
      backgroundColor:isDarkMode? Theme.of(context).colorScheme.primary: Colors.white,

      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: themeProvider.currentTheme == 'Pink'
                  ? HeaderColor.pinkGradient
                  : themeProvider.currentTheme == 'Teal'
                  ? HeaderColor.greenGradient
                  : themeProvider.currentTheme == 'Blue'
                  ? HeaderColor.blueGradient
                  : themeProvider.currentTheme == 'Orange'
                  ? HeaderColor.orangeGradient
                  : HeaderColor.darkGradient,
              borderRadius:  BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
            child: SafeArea(
                top: false,
                child: CustomHeader(title: 'Notifications',

                )

            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  await NotificationStorage.markAllAsRead();
                  loadNotifications();
                },
                child: Text("read_all".tr(),style: TextStyle(color: isDarkMode ? Color(0xFFD44D5C) : Theme.of(context).colorScheme.primary),),
              ),
            ],
          ),

          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    final isRead = item["isRead"] ?? false;

                    return GestureDetector(
                      onTap: () async {
                        if (!isRead) {
                          await NotificationStorage.markAsRead(index);
                          loadNotifications();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isRead
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                              : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isRead ?
                            isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary
                                :isDarkMode ? Color(0xFFD44D5C) : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item["title"] ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isRead ?
                                      isDarkMode?Colors.white :Colors.grey
                                          : isDarkMode ? Colors.white :Colors.black,
                                    ),
                                  ),
                                ),

                                // 🔴 unread dot
                                if (!isRead)
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration:  BoxDecoration(
                                      color: isDarkMode? Color(0xFFD44D5C) :Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(item["body"] ?? ""),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }
}
