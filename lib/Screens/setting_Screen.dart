import 'package:flutter/material.dart';

import '../Widgets/settingScreenWidgets/SettingsContent.dart';
import '../component/header_appbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ?  Theme.of(context).colorScheme.primary :
      Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [

          HeaderAppbar(title: "Settings",
            back_btn: false,),
          // const SettingsHeader(),
          Expanded(
            child: Column(
              children: [
                SettingsContent(
                  isDarkMode: isDarkMode,
                  onToggleDarkMode: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),

              ],
            )
          ),

         // BottomNavBar(selectedIndex: selectedIndex),
        ],
      ),
    );
  }
}