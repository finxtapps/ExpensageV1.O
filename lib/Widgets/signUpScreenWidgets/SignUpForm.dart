import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Api_Models/SignUp_Model.dart';
import '../../Api_Services/SignUp_Service.dart';
import '../../Api_Services/google_signup_login.dart';
import '../../Api_Services/linkedIn_signIn_linkedIn.dart';
import '../../Screens/custom_popUp_Screen.dart';

class SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  const SignUpForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String? _selectedGender;
  bool _isPasswordVisible = false;
 // Currency? _selectedCurrency;
  //String? _selectedGender;
  String? _selectedCurrencySymbol; // ✅ ₹ $ ¥
  bool isValidator = false;
  bool _isGoogleLoading = false;
  bool _isLinkedInLoading = false; // optional (agar future me chahiye)
  bool _isLoading = false; // ✅ Loading state
  final SignUpAuthService _authService = SignUpAuthService(); // ✅ API service

  String countryCodeToEmoji(String countryCode) {
    if (countryCode.length != 2) return '';
    return String.fromCharCodes(
      countryCode.toUpperCase().codeUnits.map((codeUnit) => codeUnit + 127397),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final isTablet = screenWidth > 600;

        return ScreenUtilInit(
          designSize: isTablet ? const Size(834, 1194) : const Size(390, 844),
          minTextAdapt: true,
          builder: (context, child) {
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;

            return Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
                child: SingleChildScrollView(
                  child: Form(
                    key: widget.formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 8.h),
                        _buildInputField(
                          controller: widget.fullNameController,
                          hintText: 'Full name',
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 8.h),
                        _buildInputField(
                          controller: widget.emailController,
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 8.h),
                        _buildInputField(
                          controller: widget.passwordController,
                          hintText: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        SizedBox(height: 8.h),
                        _buildInputField(
                          controller: widget.phoneController,
                          hintText: 'Phone number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 8.h),
                        _buildGenderDropdown(),
                        SizedBox(height: 8.h),
                        _buildCurrencyDropdown(),
                        SizedBox(height: 20.h),
                        _buildSignUpButton(context),
                        SizedBox(height: 20.h),
                        _buildDivider(),
                        SizedBox(height: 20.h),
                        _buildSocialButtons(context),
                        isDarkMode
                            ? SizedBox(height: 100.h)
                            : SizedBox(height: screenHeight > 600 ? 88.h : 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ------------------ Currency Dropdown ------------------

  Widget _buildCurrencyDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FormField<String>(
      validator: (value) {
        if (_selectedCurrencySymbol == null) {
          return "Please select currency";
        }
        return null;
      },
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.grey[400]!, width: 1.5.w),
              ),
              child: InkWell(
                onTap: () {
                  showCurrencyPicker(
                    context: context,
                    showFlag: true,
                    showCurrencyName: true,
                    showCurrencyCode: false,
                    onSelect: (Currency currency) {
                      setState(() {
                        _selectedCurrencySymbol = currency.symbol; // ✅ SAVE
                      });
                      field.didChange(currency.symbol);
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        color: isDarkMode
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _selectedCurrencySymbol ?? "Select Currency",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: _selectedCurrencySymbol == null
                                ? (isDarkMode
                                ? Colors.white
                                : Colors.grey[600])
                                : (isDarkMode
                                ? Colors.white
                                : Colors.black),
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[400]!),
                    ],
                  ),
                ),
              ),
            ),

            if (field.hasError)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: Text(
                  field.errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
          ],
        );
      },
    );
  }



  Widget _buildGenderDropdown() {
    String? errorText;
    return StatefulBuilder(
      builder: (context, setState) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.grey[400]!, width: 1.5.w),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.people_outline,
                    color: isDarkMode
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                    size: 22.w,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  errorStyle: const TextStyle(height: 0),
                ),
                hint: Text(
                  "Select Gender",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
                padding: EdgeInsets.only(top: 12.h),
                items: ["Male", "Female", "Other"]
                    .map(
                      (gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender, style: TextStyle(fontSize: 14.sp)),
                  ),
                )
                    .toList(),
                validator: (value) {
                  String? message;
                  if (value == null || value.isEmpty) {
                    message = 'Please select gender';
                  }
                  setState(() => errorText = message);
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                    errorText = null;
                  });
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

  // ------------------ Input Field ------------------
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
                textAlignVertical: TextAlignVertical.center, // ⭐ IMPORTANT
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

  // ------------------ Sign Up Button (API Integrated) ------------------
  Widget _buildSignUpButton(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 150.w,
      height: 38.h,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
          if (widget.formKey.currentState!.validate()) {
            if (_selectedCurrencySymbol  == null || _selectedGender == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Please select both gender and currency."),
                ),
              );
              return;
            }

            setState(() => _isLoading = true);

            final req = SignupRequest(
              name: widget.fullNameController.text.trim(),
              email: widget.emailController.text.trim(),
              password: widget.passwordController.text.trim(),
              phone: widget.phoneController.text.trim(),
              gender: _selectedGender!.toLowerCase(),
              currency: _selectedCurrencySymbol!,
            );

            // ✅ Wait for signup and get success status
            bool isSuccess =
            await _authService.signupWithSaveAndNavigate(
                req, context);

            setState(() => _isLoading = false);

            if (isSuccess) {
              // ✅ Clear fields only if signup succeeded
              widget.fullNameController.clear();
              widget.emailController.clear();
              widget.passwordController.clear();
              widget.phoneController.clear();
            }
            // ❌ Do NOT clear fields if signup failed
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode
              ? const Color(0xFFD44D5C)
              : Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 3,
        ),
        child: _isLoading
            ? SizedBox(
          height: 20.h,
          width: 20.w,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.2,
          ),
        )
            : Text(
          'Sign up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ------------------ Divider + Social Buttons ------------------
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1.h, color: Colors.grey[300])),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'or sign up with',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ),
        Expanded(child: Container(height: 1.h, color: Colors.grey[300])),
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
            isLoading: _isGoogleLoading, // 👈 only google
            onPressed: () async {
              setState(() => _isGoogleLoading = true);

              final msg =
              await GoogleAuthService().signInWithGoogle(context);

              setState(() => _isGoogleLoading = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg)),
              );
            },
          ),
        ),
        SizedBox(width: 10.w),
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
                title: "Coming Soon",
                message: "This feature is currently under development and will be available soon.",
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
      height: 40.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : () async => await onPressed(),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: Colors.grey[300]!, width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
          height: 18.h,
          width: 18.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        )
            : Row(
          children: [
            SizedBox(
              height: 30.h,
              width: 30.w,
              child: Image.asset(image),
            ),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }



}

