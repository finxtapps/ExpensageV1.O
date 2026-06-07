import 'package:easy_localization/easy_localization.dart';
import 'package:expensag/Widgets/profile_Info_Screen_Widgets/profile_image_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/header_Color.dart';
import '../../providerListner/theme_notifier.dart';

class ProfileHeaderSection extends StatelessWidget {
  final VoidCallback onBackPressed;

  const ProfileHeaderSection({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height:MediaQuery.of(context).size.height * 0.35,/////////////////////
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        gradient:
        themeProvider.currentTheme == 'Pink'
      ? HeaderColor.pinkGradient
          : themeProvider.currentTheme == 'Teal'
      ? HeaderColor.greenGradient
          : themeProvider.currentTheme == 'Blue'
      ? HeaderColor.blueGradient
          : themeProvider.currentTheme == 'Orange'
      ? HeaderColor.orangeGradient
          : HeaderColor.darkGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 2),
          child: Column(
           // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [

                  Expanded(
                    child: Text(
                      'profile'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                 // const SizedBox(width: 24), // Balance the back button
                ],
              ),
              const SizedBox(height: 10),
              const ProfileImageSection(title: 'User name',),
              // SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}