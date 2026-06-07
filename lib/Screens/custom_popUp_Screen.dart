import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providerListner/theme_notifier.dart';
import '../theme/header_Color.dart';

class CustomPopup {

  static void show({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:isDarkMode?Theme.of(context).scaffoldBackgroundColor:Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                 Icon(
                  Icons.construction,
                  size: 60,
                  color: isDarkMode
                      ?Color(0xFFD44D5C)
                      :Theme.of(context).primaryColor,
                ),

                const SizedBox(height: 15),

                Text(
                  title,
                  style:  TextStyle(
                    color: isDarkMode?Colors.white:Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode?Colors.white:Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient:isDarkMode?HeaderColor.pinkGradient :themeProvider.currentTheme == 'Pink'
                          ? HeaderColor.pinkGradient
                          : themeProvider.currentTheme == 'Teal'
                          ? HeaderColor.greenGradient
                          : themeProvider.currentTheme == 'Blue'
                          ? HeaderColor.blueGradient
                          : themeProvider.currentTheme == 'Orange'
                          ? HeaderColor.orangeGradient
                          : HeaderColor.darkGradient,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}