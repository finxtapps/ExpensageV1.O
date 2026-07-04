import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providerListner/profile_notifier.dart';
import '../../shared_prefrence/SharedPrefrenceMethods.dart';

class HomeHeader extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;

  const HomeHeader({super.key, required this.notifications});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final bool isLoading = false;
  String name = "";
  String? profileImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserName();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good_morning'.tr();
    } else if (hour < 17) {
      return 'Good_afternoon'.tr();
    } else if (hour < 21) {
      return 'Good_evening'.tr();
    } else {
      return 'Good_night'.tr();
    }
  }

  Future<void> _loadUserName() async {
    final _userName = await SharedPreferenceMethods().getUserName();
    final img = await SharedPreferenceMethods().getUserImageFilename();

    setState(() {
      name = _userName ?? "";
      profileImage = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    int unreadCount = widget.notifications
        .where((e) => (e["isRead"] ?? false) == false)
        .length;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  // Profile Picture
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Consumer<ProfileNotifier>(
                      builder: (context, profile, child) {
                        return CircleAvatar(
                          backgroundImage: profile.profileImageProvider,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Greeting Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getGreeting()},",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ],
                    ),
                  ),
                  // Notification Icon
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notification');
                        },
                        child: Icon(
                          Icons.notifications,
                          color: isDarkMode ? Color(0xFFD44D5C) : Colors.white,
                        ),
                      ),

                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // InkWell(
                  //   onTap: (){
                  //     Navigator.pushNamed(context, '/notification');
                  //   },
                  //   child: Container(
                  //     padding:  EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //       color:isDarkMode? Color(0xFFD44D5C): Colors.white.withOpacity(0.2),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: const Icon(
                  //       Icons.notifications_outlined,
                  //       color: Colors.white,
                  //       size: 24,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
