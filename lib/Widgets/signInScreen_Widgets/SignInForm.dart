import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Api_Services/google_signup_login.dart';
import '../../Api_Services/linkedIn_signIn_linkedIn.dart';
import '../../Api_Services/signIn_service.dart';
import '../../Screens/custom_popUp_Screen.dart';
import '../../Screens/wrapper.dart';




class SignInForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignInForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GoogleAuthService googleAuthService = GoogleAuthService();
  bool _isPasswordVisible = false;
  bool _isGoogleLoading = false;
  bool _isLinkedInLoading = false; // optional (agar future me chahiye)
  bool _isLoading = false; // 🔹 loading indicator
  final LoginAuthService _authService = LoginAuthService(); // 🔹 API service

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final isTablet = screenWidth > 600;
      return ScreenUtilInit(
        designSize: isTablet ? const Size(834, 1194) : const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          return Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * .125),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                  child: Form(
                    key: widget.formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 38,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Enter your details below",
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[100]!
                                  : Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),
                        _buildInputField(
                          controller: widget.emailController,
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),
                        _buildInputField(
                          controller: widget.passwordController,
                          hintText: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        const SizedBox(height: 40),
                        _buildSignInButton(context),
                        const SizedBox(height: 15),
                        Text(
                          "Forgot your Password?",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 50),
                        _buildDivider(),
                        const SizedBox(height: 28),
                        _buildSocialButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // 🔹 Custom TextField builder (unchanged)
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    String? errorText;

    return StatefulBuilder(
      builder: (context, setState) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        final bool isPasswordField = hintText == 'Password';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.grey[400]!, width: 1.5.w),
              ),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center, //
                controller: controller,
                obscureText: isPasswordField
                    ? !_isPasswordVisible
                    : obscureText,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: isDarkMode
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                    size: 22.w,
                  ),
                  isCollapsed: true, // ⭐ IMPORTANT

                  // 👁️ Suffix Eye Icon (ONLY for password)
                  suffixIcon: isPasswordField
                      ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: isDarkMode?Colors.grey[500]:Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                      : null,

                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  errorStyle: const TextStyle(height: 0),
                ),
                validator: (value) {
                  String? message;
                  if (value == null || value.isEmpty) {
                    message = 'This field is required';
                  } else if (hintText == 'Email' && !value.contains('@')) {
                    message = 'Please enter a valid email';
                  }
                  setState(() => errorText = message);
                  return null;
                },
              ),
            ),
            if (errorText != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
          ],
        );
      },
    );
  }


  // 🔹 Sign In Button with Dio implementation
  Widget _buildSignInButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .4,
      height: MediaQuery.of(context).size.width * .13,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        )
            : const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // 🔹 Actual login function

  Future<void> _handleSignIn() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final response = await _authService.loginUser(
      context: context,
      email: widget.emailController.text.trim(),
      password: widget.passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (response == null) {
      // Already handled by service (snackbar shown)
      return;
    }
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.grey[300])),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'or sign in with',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        Expanded(child: Container(height: 1, color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            "assets/images/icon_Images/icons8-google-480.png",
            'Google',
            Colors.white,
            Colors.black87,
            isLoading: _isGoogleLoading, // 👈 important
            onPressed: () async {
              setState(() => _isGoogleLoading = true);

              final msg =
              await googleAuthService.signInWithGoogle(context);

              setState(() => _isGoogleLoading = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg ?? "Something went wrong")),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSocialButton(
            "assets/images/icon_Images/icons8-linkedin-480.png",
            'LinkedIn',
            Colors.white,
            Colors.black87,
            isLoading: false, // 👈 always false
            onPressed: () async {
              // final msg =
              // await LinkedInAuthService().signInWithLinkedIn(context);
              //
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text(msg ?? "Something went wrong")),
              // );
              CustomPopup.show(
                  context: context,
                  title: "coming_soon".tr(),
                  message: "feature_under_development".tr()
                // "This feature is currently under development and will be available soon.",
              );


            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      String image,
      String text,
      Color backgroundColor,
      Color textColor, {
        required Future<void> Function() onPressed,
        required bool isLoading,
      }) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: isLoading ? null : () async => await onPressed(),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: Colors.grey[300]!, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 24, width: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
