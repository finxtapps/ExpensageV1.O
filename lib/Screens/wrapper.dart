import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../Screens/expense_analysis_screen.dart';
import '../../Screens/new_home_screen.dart';
import '../../Screens/profile_Information.dart';
import '../../Screens/setting_Screen.dart';
import '../Widgets/ExpenseScreenWidget/expense_analysis_gate.dart';
import '../component/bottomBar/addButton.dart';
import '../../shared_prefrence/SharedPrefrenceMethods.dart';
import 'GuestHomeScreen.dart';


class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0; // Screen index
  int _navigationIndex = 0; // Navigation bar index

  late List<Widget> _screens;
  bool _isLoggedIn = false;
  bool _loading = true;


//com.expensag.release//package com.expensag.release
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity : FlutterActivity()


  @override
  void initState() {
    super.initState();
    _initScreens();
  }
  Future<void> _initScreens() async {
    final prefs = SharedPreferenceMethods();
    final token = await prefs.getToken();
    final userId = await prefs.getUserId();

    _isLoggedIn =
        token != null && token.isNotEmpty && userId != null && userId.isNotEmpty;

    _screens = [
      _isLoggedIn ? const NewHomeScreen() : const GuestHomeScreen(),
      ExpenseAnalysisGate(active: false),
      const SizedBox.shrink(),
      const ProfileInfoScreen(),
      const SettingsScreen(),
    ];

    setState(() {
      _loading = false;
    });
  }



  void _onTap(int index) {
    if (index == 2) {
      setState(() => _navigationIndex = _selectedIndex);
      return;
    }

    setState(() {
      _selectedIndex = index;
      _navigationIndex = index;

      // Update ExpenseAnalysisScreen active flag
      _screens[1] = ExpenseAnalysisScreen(active: index == 1);
    });
  }




  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar:
            CurvedNavigationBar(
              index: _navigationIndex,
              height: 60,
              items: [
                Icon(Icons.home_rounded,
                    size: MediaQuery.of(context).size.height * 0.052,
                    color: Colors.white),
                Icon(Icons.analytics_rounded,
                    size: MediaQuery.of(context).size.height * 0.052,
                    color: Colors.white),
                SizedBox(width: 0, height: 0), // dummy
                Icon(Icons.person_2_rounded,
                    size: MediaQuery.of(context).size.height * 0.052,
                    color: Colors.white),
                Icon(Icons.settings,
                    size: MediaQuery.of(context).size.height * 0.052,
                    color: Colors.white),
              ],
              color: _navigationIndex == 2
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.primary,
              buttonBackgroundColor: _navigationIndex == 2
                  ? Colors.transparent
                  : isDarkMode
                  ? Color(0xFFD44D5C)
                  : Theme.of(context).colorScheme.secondary,
              backgroundColor:
              isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
              animationCurve: Curves.easeInOut,
              animationDuration: _navigationIndex == 2
                  ? Duration.zero
                  : Duration(milliseconds: 600),
              onTap: _onTap,
            ),
            // 🔒 tumhara pura existing code yahin rahega
          ),

        AddButton(),
      ],
    );
  }

}






