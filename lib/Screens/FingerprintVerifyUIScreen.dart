import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class FingerprintVerifyUIScreen extends StatefulWidget {
  const FingerprintVerifyUIScreen({super.key});

  @override
  State<FingerprintVerifyUIScreen> createState() =>
      _FingerprintVerifyUIScreenState();
}

class _FingerprintVerifyUIScreenState extends State<FingerprintVerifyUIScreen>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _auth = LocalAuthentication();

  late AnimationController _controller;
  late Animation<double> _lockRotation;
  late Animation<double> _lockScale;

  bool _isVerified = false;
  bool _isPinCreated = false; // Track if PIN exists

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _lockRotation = Tween<double>(begin: 0, end: -0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _lockScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _checkAndVerify();
  }

  /// 🔹 Check if PIN exists & fingerprint enabled
  Future<void> _checkAndVerify() async {
    final prefs = await SharedPreferences.getInstance();

    // 🔹 Check if PIN exists
    final pinCreated = prefs.getBool('isPinCreated') ?? false;

    setState(() {
      _isPinCreated = pinCreated; // update UI
    });

    final fingerprintEnabled = prefs.getBool("fingerprintEnabledByUser") ?? false;

    if (!fingerprintEnabled) {
      // Fingerprint disabled → go directly to home
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    _authenticate();
  }

  /// 🔹 Fingerprint authentication
  Future<void> _authenticate() async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Verify fingerprint to unlock',
        biometricOnly: true,
      );

      if (!mounted) return;

      if (authenticated) {
        _playUnlockAnimation();
        await Future.delayed(const Duration(milliseconds: 900));
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // In case of error/failure → just stay on screen
    }
  }

  /// 🔹 Play lock open animation
  void _playUnlockAnimation() {
    setState(() => _isVerified = true);
    _controller.forward();
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

    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🔐 LOCK ICON ANIMATION
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Transform.rotate(
                  angle: _isVerified ? _lockRotation.value : 0,
                  child: Transform.scale(
                    scale: _isVerified ? _lockScale.value : 1,
                    child: Icon(
                      _isVerified ? Icons.lock_open_rounded : Icons.lock_rounded,
                      size: 110.sp,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),

            /// 🔹 STATUS TEXT
            Text(
              _isVerified ? "Fingerprint verified" : "Verify with fingerprint",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 36.h),

            /// 🔹 FINGERPRINT ICON
            Icon(
              Icons.fingerprint,
              size: 70.sp,
              color: Colors.white.withOpacity(0.9),
            ),
            SizedBox(height: 52.h),

            /// 🔹 PIN FALLBACK BUTTON (only if PIN saved)
            if (_isPinCreated)
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/varifyPin');
                },
                child: Text(
                  "Use privacy PIN",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
