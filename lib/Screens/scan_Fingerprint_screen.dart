import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/customHeader.dart';
import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class ScanFingerprintScreen extends StatefulWidget {
  const ScanFingerprintScreen({super.key});

  @override
  State<ScanFingerprintScreen> createState() => _ScanFingerprintScreenState();
}

class _ScanFingerprintScreenState extends State<ScanFingerprintScreen>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isAuthenticating = false;
  bool _isAuthenticated = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration.zero, _authenticate);
  }

  Future<void> _authenticate() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();

      if (!canCheck || !supported) {
        _show("biometric_not_supported".tr());
        return;
      }

      setState(() => _isAuthenticating = true);

      final authenticated = await _auth.authenticate(
        localizedReason: 'Scan fingerprint to enable',
        biometricOnly: true,
      );

      if (!mounted) return;

      if (authenticated) {
        setState(() => _isAuthenticated = true);
        _controller.repeat(reverse: true);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("fingerprintEnabledByUser", true);

        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _show("authentication_failed".tr());
      }
    } catch (e) {
      _show("fingerprint_error".tr());
    } finally {
      setState(() => _isAuthenticating = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _auth.stopAuthentication();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
//CustomHeader(title: 'Scan your fingerprint',
//                 fontsize: 25,),
    return Scaffold(
      body: Column(
        children: [
          // ---------- HEADER ----------
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
                child: CustomHeader(title: 'scan_your_fingerprint'.tr(),
                fontsize: 25,),

            ),
          ),


          // ---------- BODY ----------
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (_, __) {
                  return Transform.scale(
                    scale: _isAuthenticated ? _scaleAnimation.value : 1.0,
                    child: Icon(
                      Icons.fingerprint,
                      size: 120.sp,
                      color: _isAuthenticated
                          ? Colors.green
                          : (_isAuthenticating ? Colors.blue : Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),

          Text(
            _isAuthenticated
                ? "fingerprint_verified".tr()
                : _isAuthenticating
                ? "scanning_fingerprint".tr()
                : "place_your_finger_on_sensor".tr(),
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}


















// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../theme/header_Color.dart';
// import '../theme/theme_notifier.dart';
//
// class ScanFingerprintScreen extends StatefulWidget {
//   const ScanFingerprintScreen({super.key});
//
//   @override
//   State<ScanFingerprintScreen> createState() => _ScanFingerprintScreenState();
// }
//
// class _ScanFingerprintScreenState extends State<ScanFingerprintScreen>
//     with SingleTickerProviderStateMixin {
//   final LocalAuthentication _auth = LocalAuthentication();
//
//   bool _isAuthenticating = false;
//   bool _isAuthenticated = false;
//   bool _authCalled = false;
//
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller =
//         AnimationController(vsync: this, duration: const Duration(seconds: 1));
//
//     _scaleAnimation =
//         Tween<double>(begin: 1.0, end: 1.2).animate(
//           CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//         );
//
//     // 🔐 Auto trigger fingerprint once
//     if (!_authCalled) {
//       _authCalled = true;
//       Future.delayed(Duration.zero, _authenticate);
//     }
//   }
//
//   Future<void> _authenticate() async {
//     try {
//       final bool canCheck = await _auth.canCheckBiometrics;
//       final bool supported = await _auth.isDeviceSupported();
//
//       if (!canCheck || !supported) {
//         _showMessage("Biometric not supported");
//         return;
//       }
//
//       setState(() => _isAuthenticating = true);
//
//       final bool authenticated = await _auth.authenticate(
//         localizedReason: 'Scan your fingerprint to continue',
//         biometricOnly: true,
//       );
//
//       if (!mounted) return;
//
//       if (authenticated) {
//         setState(() => _isAuthenticated = true);
//         _controller.repeat(reverse: true);
//
//         // 🔐 Ensure flag remains true
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool("fingerprintEnabledByUser", true);
//
//         // Small delay for UX
//         await Future.delayed(const Duration(milliseconds: 800));
//
//         if (!mounted) return;
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         _showMessage("Authentication failed");
//       }
//     } catch (e) {
//       debugPrint("Fingerprint error: $e");
//       _showMessage("Fingerprint error");
//     } finally {
//       if (mounted) {
//         setState(() => _isAuthenticating = false);
//       }
//     }
//   }
//
//   void _showMessage(String msg) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }
//
//   @override
//   void dispose() {
//     _auth.stopAuthentication();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     return Scaffold(
//       body: Column(
//         children: [
//           // ---------- HEADER ----------
//           Container(
//             decoration: BoxDecoration(
//               gradient: themeProvider.currentTheme == 'Pink'
//                   ? HeaderColor.pinkGradient
//                   : themeProvider.currentTheme == 'Teal'
//                   ? HeaderColor.greenGradient
//                   : themeProvider.currentTheme == 'Blue'
//                   ? HeaderColor.blueGradient
//                   : themeProvider.currentTheme == 'Orange'
//                   ? HeaderColor.orangeGradient
//                   : HeaderColor.darkGradient,
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding:
//                 const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child:
//                       const Icon(Icons.arrow_back, color: Colors.white),
//                     ),
//                     const SizedBox(width: 16),
//                     const Text(
//                       'Scan your fingerprint',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // ---------- BODY ----------
//           Expanded(
//             child: Center(
//               child: AnimatedBuilder(
//                 animation: _scaleAnimation,
//                 builder: (_, __) {
//                   return Transform.scale(
//                     scale: _isAuthenticated ? _scaleAnimation.value : 1.0,
//                     child: Icon(
//                       Icons.fingerprint,
//                       size: 120,
//                       color: _isAuthenticated
//                           ? Colors.green
//                           : (_isAuthenticating
//                           ? Colors.blue
//                           : Colors.grey),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//           Text(
//             _isAuthenticated
//                 ? "Fingerprint Verified ✅"
//                 : _isAuthenticating
//                 ? "Scanning fingerprint..."
//                 : "Place your finger on sensor",
//             style: const TextStyle(fontSize: 16),
//           ),
//
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }
//

