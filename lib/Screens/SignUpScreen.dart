import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Widgets/signUpScreenWidgets/SignUpForm.dart';
import '../component/login_signup_Header.dart';
import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  HeaderColor headerColor = HeaderColor();
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
     return Scaffold(
       backgroundColor: isDarkMode?Colors.black:Theme.of(context).scaffoldBackgroundColor,
       body: Container(
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
         child: SafeArea(
           child: Column(
             children: [
               LoginSignupHeader(btn_title: 'Sign In'),
               const Padding(
                 padding: EdgeInsets.only(top: 10),
                 child: Text(
                   'ExpenSage',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 45,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ),
               /// 👇 Yeh part scrollable hoga
               Expanded(
                 child: Padding(
                   padding:isDarkMode
                       ?  EdgeInsets.symmetric(horizontal: 15.0)
                       :EdgeInsets.symmetric(horizontal: 0.0)
                   ,
                   child: Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(
                             MediaQuery.of(context).size.width * .25),
                         topRight: Radius.circular(
                             MediaQuery.of(context).size.width * .25),
                       ),
                       color: isDarkMode
                           ? Theme.of(context).colorScheme.secondary
                           : Colors.white.withOpacity(.15),
                     ),
                     margin: EdgeInsets.only(top: 8.h),

                     child: Padding(
                       padding:  EdgeInsets.only( left: 0.w,right: 0.w,
                         top: 15.h,

                       ),
                       child: Container(

                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(40.r),
                             topRight: Radius.circular(40.r),
                           ),
                           border: Border.all(
                             color: isDarkMode
                                 ? Color(0xFFD44D5C)
                                 : Colors.transparent,
                             width: 4.w,
                           ),
                         ),
                         child: SingleChildScrollView(
                           child: Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.only(
                                 topLeft: Radius.circular(
                                     MediaQuery.of(context).size.width * .25),
                                 topRight: Radius.circular(
                                     MediaQuery.of(context).size.width * .25),
                               ),
                               color: isDarkMode
                                   ? Theme.of(context).colorScheme.secondary
                                   : Colors.white.withOpacity(.15),
                             ),
                             child: Padding(
                               padding:  EdgeInsets.only(top: 0.0),
                               child: SignUpForm(
                                 formKey: _formKey,
                                 fullNameController: _fullNameController,
                                 emailController: _emailController,
                                 passwordController: _passwordController,
                                 phoneController: _phoneController,
                               ),
                             ),

                           ),//////////////////container tha
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     );
  }
}











// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uiproject/theme/header_Color.dart';
//
// import '../Widgets/signUpScreenWidgets/SignUpForm.dart';
// import '../component/login_signup_Header.dart';
// import '../theme/theme_notifier.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _phoneController = TextEditingController();
//
//   HeaderColor headerColor = HeaderColor();
//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: themeProvider.currentTheme == 'Pink'
//               ? HeaderColor.pinkGradient
//               : themeProvider.currentTheme == 'Green'
//               ? HeaderColor.greenGradient
//               : themeProvider.currentTheme == 'Blue'
//               ? HeaderColor.blueGradient
//               : themeProvider.currentTheme == 'Orange'
//               ? HeaderColor.orangeGradient
//               : HeaderColor.darkGradient,
//         ),
//
//         child: SafeArea(
//           child: Column(
//             children: [
//               LoginSignupHeader(btn_title: 'Sign In',),
//               // const HeaderSection(),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   'ExpenSage',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 45,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(MediaQuery.of(context).size.width * .25),
//                       topRight: Radius.circular(MediaQuery.of(context).size.width * .25),
//                     ),
//                     color:isDarkMode
//                         ? Theme.of(context).colorScheme.secondary
//                         : Colors.white.withOpacity(.1),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 3.0),
//                     child: SignUpForm(
//                       formKey: _formKey,
//                       fullNameController: _fullNameController,
//                       emailController: _emailController,
//                       passwordController: _passwordController,
//                       phoneController: _phoneController,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
