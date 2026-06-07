import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../component/customHeader.dart';
import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class SetPinAndFingerprintScreen extends StatefulWidget {
  const SetPinAndFingerprintScreen({super.key});

  @override
  State<SetPinAndFingerprintScreen> createState() =>
      _SetPinAndFingerprintScreenState();
}

class _SetPinAndFingerprintScreenState
    extends State<SetPinAndFingerprintScreen> {
  bool _isFingerprintEnabled = false;
  bool _isPinCreated = false;

  final LocalAuthentication _auth = LocalAuthentication();

  /// 🔐 Fingerprint verification before PIN change
  Future<void> _verifyFingerprintAndChangePin() async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Verify fingerprint to change PIN',
        biometricOnly: true,
      );

      if (!mounted) return;

      if (authenticated) {
        Navigator.pushNamed(context, '/changePin');
      }
    } catch (e) {
      // Authentication failed / cancelled
    }
  }

  /// 🔹 Load settings
  Future<void> _loadSecurityStatus() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isPinCreated = prefs.getBool('isPinCreated') ?? false;
      _isFingerprintEnabled =
          prefs.getBool('fingerprintEnabledByUser') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSecurityStatus();
  }

  @override
  void dispose() {
    _auth.stopAuthentication();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
      isDarkMode ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          /// HEADER
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
              child:CustomHeader(title: 'Security and Privacy',),

            ),
          ),

          Divider(
            color: isDarkMode ? Colors.white : Colors.transparent,
            thickness: 1.h,
          ),

          /// 🔐 CHANGE PIN (Fingerprint Protected)
          InkWell(
            onTap: () {
              if (_isPinCreated) {
                if (_isFingerprintEnabled) {
                  _verifyFingerprintAndChangePin();
                } else {
                  Navigator.pushNamed(context, '/changePin');
                }
              } else {
                Navigator.pushNamed(context, '/pin');
              }
            },
            child: _buildContentBox(
              title: _isPinCreated ? 'Change PIN' : 'PIN',
              subtitle:
              _isPinCreated ? 'Set new PIN' : 'Set four digit PIN',
              icon: Icons.arrow_forward_ios,
              verified: false,
            ),
          ),

          /// 👆 FINGERPRINT STATUS
          InkWell(
            onTap: _isFingerprintEnabled
                ? null
                : () {
              Navigator.pushNamed(context, '/fingerprint');
            },
            child: _buildContentBox(
              title: _isFingerprintEnabled
                  ? 'Fingerprint is verified'
                  : 'Fingerprint',
              subtitle: _isFingerprintEnabled
                  ? ''
                  : 'Scan and save your fingerprint',
              icon:
              _isFingerprintEnabled ? Icons.check : Icons.arrow_forward_ios,
              verified: _isFingerprintEnabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool verified,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.08.sw,
        vertical: 0.04.sh,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: verified ? Colors.green : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: verified ? Colors.white : Colors.grey,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}
