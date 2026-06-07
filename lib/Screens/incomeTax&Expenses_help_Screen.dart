// income_text_help_form.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../component/header_appbar.dart';
import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class Money_Help_Option_screen extends StatelessWidget {
  const Money_Help_Option_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding:  EdgeInsets.only(left: 20.w,right: 20.w,bottom: 320.h),
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 0.285.sh, // covers ~85% of the screen height

          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:  BorderRadius.circular(
             30
            ),
          ),
          child: Column(
            children: [
              // 🟢 Handle bar
              Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10.h),

              // 🟢 Header
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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                   EdgeInsets.symmetric(vertical: 12.h, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        "income_help_form".tr(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon:  Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // 🧾 List content
              Container(

                child: Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(

                        leading:  Icon(Icons.money_rounded,
                        size: 28.sp,
                          color: isDarkMode?Colors.white : Colors.black,
                        ),
                        title:  Text('in_manage_expense'.tr(),style: TextStyle(fontSize: 16.sp,)),
                        trailing:  Icon(Icons.arrow_forward_ios_outlined,
                            size: 28.sp,
                          color: isDarkMode?Colors.white : Colors.black,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/expenseHelp');
                        },
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      ListTile(
                        leading:Icon(Icons.currency_exchange,
                        size: 28.sp,
                          color: isDarkMode?Colors.white : Colors.black,
                        ),
                       // FaIcon(FontAwesomeIcons.receipt, size: 28.sp),
                         // FaIcon(FontAwesomeIcons.fileInvoiceDollar, size: 28.sp),

                  // FaIcon(FontAwesomeIcons.moneyBillTransfer,
                        //     size: 28.sp
                        // ),
                        title:  Text('in_income_tax'.tr(),style: TextStyle(fontSize: 16.sp,)),
                        trailing:  Icon(Icons.arrow_forward_ios_outlined,
                            size: 28.sp,
                          color: isDarkMode?Colors.white : Colors.black,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/incomeTaxForm');
                        },
                      ),

                    ],
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
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
//
// import '../component/header_appbar.dart';
// import '../theme/header_Color.dart';
// import '../theme/theme_notifier.dart';
//
// class IncomeTextHelpForm extends StatefulWidget {
//   const IncomeTextHelpForm({super.key});
//
//   @override
//   State<IncomeTextHelpForm> createState() => _IncomeTextHelpFormState();
// }
//
// class _IncomeTextHelpFormState extends State<IncomeTextHelpForm> {
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return  Padding(
//       padding:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 40),
//       child: Container(
//
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: themeProvider.currentTheme == 'Pink'
//                       ? HeaderColor.pinkGradient
//                       : themeProvider.currentTheme == 'Green'
//                       ? HeaderColor.greenGradient
//                       : themeProvider.currentTheme == 'Blue'
//                       ? HeaderColor.blueGradient
//                       : themeProvider.currentTheme == 'Orange'
//                       ? HeaderColor.orangeGradient
//                       : HeaderColor.darkGradient,
//                 ),
//                 child: SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 20.0,
//                       horizontal: 20,
//                     ),
//                     child: HeaderAppbar(
//                       title: "Income Help Form",
//                       back_btn: true,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Form(
//                   child: Column(
//                     children: [
//                       Container(
//                         child: Column(
//                           children: [
//                             Container(
//                               child: ListTile(
//                                 leading: Icon(Icons.money_rounded),
//                                 title:  Text('In Manage Expence'),
//                                 onTap: () => Navigator,
//                                 trailing: Icon(Icons.arrow_forward_ios_outlined),
//                               ),
//                             ),
//
//                             Container(
//                               child: ListTile(
//                                 leading: FaIcon(FontAwesomeIcons.moneyBillTransfer),
//                                 title:  Text('In Incometax'),
//                                 onTap: () => Navigator,
//                                 trailing: Icon(Icons.arrow_forward_ios_outlined),
//                               ),
//                             ),
//                             Container(),
//                           ],
//                         ),
//                       ),
//
//                       // TextField(
//                       //   // controller: controller,
//                       //   // keyboardType: keyboardType,
//                       //   decoration: InputDecoration(
//                       //
//                       //     hintText: "enter name",
//                       //     hintStyle: TextStyle(color:isDarkMode?Colors.white : Colors.grey[500]),
//                       //     border: InputBorder.none,
//                       //     isDense: true,
//                       //     prefixIcon: Icon(Icons.person),
//                       //     contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                       //     enabledBorder: UnderlineInputBorder(
//                       //       borderSide: BorderSide(color:isDarkMode?Colors.white :Theme.of(context).colorScheme.primary),),
//                       //
//                       //     focusedBorder: UnderlineInputBorder(
//                       //       borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
//                       //     ),
//                       //
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//     );
//
//   }
// }
