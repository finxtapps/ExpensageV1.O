import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class CustomHeader extends StatefulWidget {
  final String title;
  final double fontsize;
  const CustomHeader({super.key, required this.title,this.fontsize=28});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return
      Container(
        decoration: BoxDecoration(
          // gradient: themeProvider.currentTheme == 'Pink'
          //     ? HeaderColor.pinkGradient
          //     : themeProvider.currentTheme == 'Teal'
          //     ? HeaderColor.greenGradient
          //     : themeProvider.currentTheme == 'Blue'
          //     ? HeaderColor.blueGradient
          //     : themeProvider.currentTheme == 'Orange'
          //     ? HeaderColor.orangeGradient
          //     : HeaderColor.darkGradient,
          borderRadius:  BorderRadius.only(
            bottomLeft: Radius.circular(40.r),
            bottomRight: Radius.circular(40.r),
          ),
        ),
        child: SafeArea(
          top: false,
        child: Padding(
          padding: EdgeInsets.only(
              top: 35.h,//20.h,
              left: 20.w,
              right: 20.w
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 20.w),
              Text(
                widget.title,
               // 'Security and Privacy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontsize.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
            ),
      );
  }
}
