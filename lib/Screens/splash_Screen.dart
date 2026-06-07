import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn =
    await SharedPreferenceMethods().getUserLogin();
    final fingerprintEnabled =
        prefs.getBool("fingerprintEnabledByUser") ?? false;

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      if (isLoggedIn && fingerprintEnabled) {
        Navigator.pushReplacementNamed(context, '/varifyFingerPrint');
      } else if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/landingpage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return  Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
        ),
        child: Center(
          child: Text(
            "ExpenSage",
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}



















// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../shared_prefrence/SharedPrefrenceMethods.dart';
// import '../theme/header_Color.dart';
// import '../theme/theme_notifier.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginAndNavigate();
//   }
//
//   Future<void> _checkLoginAndNavigate() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final bool isLoggedIn =
//     await SharedPreferenceMethods().getUserLogin();
//
//     final bool isFingerprintEnabled =
//         prefs.getBool("fingerprintEnabledByUser") ?? false;
//
//     Timer(const Duration(seconds: 3), () {
//       if (!mounted) return;
//
//       if (isLoggedIn && isFingerprintEnabled) {
//         Navigator.pushReplacementNamed(context, '/varifyFingerPrint');
//       } else if (isLoggedIn) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/landingpage');
//       }
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: themeProvider.currentTheme == 'Pink'
//               ? HeaderColor.pinkGradient
//               : themeProvider.currentTheme == 'Teal'
//               ? HeaderColor.greenGradient
//               : themeProvider.currentTheme == 'Blue'
//               ? HeaderColor.blueGradient
//               : themeProvider.currentTheme == 'Orange'
//               ? HeaderColor.orangeGradient
//               : HeaderColor.darkGradient,
//         ),
//         child: Center(
//           child: Text(
//             "ExpenSage",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: MediaQuery.of(context).size.width * 0.12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





















// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../shared_prefrence/SharedPrefrenceMethods.dart';
// import '../theme/header_Color.dart';
// import '../theme/theme_notifier.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginAndNavigate();
//   }
//
//   Future<void> _checkLoginAndNavigate() async {
//     final isLoggedIn = await SharedPreferenceMethods().getUserLogin();
//
//     Timer(const Duration(seconds: 3), () {
//       if (isLoggedIn) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/landingpage');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: themeProvider.currentTheme == 'Pink'
//               ? HeaderColor.pinkGradient
//               : themeProvider.currentTheme == 'Teal'
//               ? HeaderColor.greenGradient
//               : themeProvider.currentTheme == 'Blue'
//               ? HeaderColor.blueGradient
//               : themeProvider.currentTheme == 'Orange'
//               ? HeaderColor.orangeGradient
//               : HeaderColor.darkGradient,
//         ),
//         child: Center(
//           child: Text(
//             "ExpenSage",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: MediaQuery.of(context).size.width * 0.12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



























// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../theme/header_Color.dart';
// import '../theme/theme_notifier.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Timer(Duration(seconds: 3), () {
// Navigator.pushReplacementNamed(context, '/landingpage');
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient:  themeProvider.currentTheme == 'Pink'
//               ? HeaderColor.pinkGradient
//               : themeProvider.currentTheme == 'Green'
//               ? HeaderColor.greenGradient
//               : themeProvider.currentTheme == 'Blue'
//               ? HeaderColor.blueGradient
//               : themeProvider.currentTheme == 'Orange'
//               ? HeaderColor.orangeGradient
//               : HeaderColor.darkGradient,
//         ),
//         child: Center(
//           child: Text("ExpenSage",style: TextStyle(color:Colors.white,fontSize: MediaQuery.of(context).size.width*.12,fontWeight: FontWeight.bold),),
//         ),
//       ),
//     );
//   }
// }
