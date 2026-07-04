import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class PinVerifyUIScreen extends StatefulWidget {
  const PinVerifyUIScreen({super.key});

  @override
  State<PinVerifyUIScreen> createState() => _PinVerifyUIScreenState();
}

class _PinVerifyUIScreenState extends State<PinVerifyUIScreen> {
  final List<TextEditingController> _pinControllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  String savedPin = '';
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPin();
    _focusNodes[0].requestFocus();
  }

  Future<void> _loadSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    savedPin = prefs.getString('mpin') ?? '';
  }

  void _checkPin() async {
    if (_isVerifying) return;
    final enteredPin =
    _pinControllers.map((controller) => controller.text).join();

    if (enteredPin.length < 4) return;

    _isVerifying = true;

    if (enteredPin == savedPin) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("pinVerified", true);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      for (var controller in _pinControllers) controller.clear();
      _focusNodes[0].requestFocus();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('invalid_pin'.tr())));
      _isVerifying = false;
    }
  }

  @override
  void dispose() {
    for (var controller in _pinControllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Color getBorderColor() {
      switch (themeProvider.currentTheme) {
        case 'Pink':
          return Colors.pink;
        case 'Teal':
          return Colors.teal;
        case 'Blue':
          return Colors.blue;
        case 'Orange':
          return Colors.orange;
        default:
          return Colors.grey.shade800;
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 20.h),
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Text(
                  'Enter 4-Digit PIN',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 60.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 45.w,
                child: TextField(
                  controller: _pinControllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  obscureText: true,
                  style:
                  TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                      BorderSide(color: getBorderColor(), width: 2.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                      BorderSide(color: getBorderColor(), width: 2.w),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 3) {
                      _focusNodes[index + 1].requestFocus();
                    }
                    if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }

                    if (_pinControllers.every((c) => c.text.isNotEmpty)) {
                      _checkPin();
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
