import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class ChangeMpinScreen extends StatefulWidget {
  const ChangeMpinScreen({super.key});

  @override
  State<ChangeMpinScreen> createState() => _ChangeMpinScreenState();
}

class _ChangeMpinScreenState extends State<ChangeMpinScreen> {
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();

  final _oldPinFocusNode = FocusNode();
  final _newPinFocusNode = FocusNode();

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _oldPinFocusNode.dispose();
    _newPinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor:
      isDarkMode ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          /// ---------- HEADER ----------
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
            ),
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Create your new pin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                        MediaQuery.of(context).size.width * 0.065,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ---------- CONTENT ----------
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter Your Old PIN",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(height: 16),

                /// OLD PIN
                Pinput(
                  length: 4,
                  controller: _oldPinController,
                  focusNode: _oldPinFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(context).colorScheme.primary,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onCompleted: (_) {
                    FocusScope.of(context).requestFocus(_newPinFocusNode);
                  },
                ),

                const SizedBox(height: 32),

                const Text(
                  "Enter Your New PIN",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(height: 16),

                /// NEW PIN
                Pinput(
                  length: 4,
                  controller: _newPinController,
                  focusNode: _newPinFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(context).colorScheme.primary,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          /// ---------- SAVE BUTTON ----------
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? const Color(0xFFD44D5C)
                  : Theme.of(context).colorScheme.primary,
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final savedPin = prefs.getString('mpin');

              final oldPin = _oldPinController.text;
              final newPin = _newPinController.text;

              if (oldPin.length != 4 || newPin.length != 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("pin_must_be_4_digits".tr())),
                );
                return;
              }

              if (savedPin == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("no_existing_pin_found".tr())),
                );
                return;
              }

              /// 🔐 VERIFY OLD PIN
              if (oldPin != savedPin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("old_pin_incorrect".tr())),
                );
                return;
              }

              /// 💾 SAVE NEW PIN
              await prefs.setString('mpin', newPin);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("pin_changed_successfully".tr())),
              );

              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}























// import 'package:easy_localization/easy_localization.dart';
//import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../theme/header_Color.dart';
// import '../theme/theme_notifier.dart';
//
// class ChangeMpinScreen extends StatefulWidget {
//   const ChangeMpinScreen({super.key});
//
//   @override
//   State<ChangeMpinScreen> createState() => _ChangeMpinScreenState();
// }
//
// class _ChangeMpinScreenState extends State<ChangeMpinScreen> {
//   final _createPinController = TextEditingController();
//   final _reenterPinController = TextEditingController();
//
//   final _createPinFocusNode = FocusNode();
//   final _reenterPinFocusNode = FocusNode();
//
//   @override
//   void dispose() {
//     _createPinController.dispose();
//     _reenterPinController.dispose();
//     _createPinFocusNode.dispose();
//     _reenterPinFocusNode.dispose();
//     super.dispose();
//   }
//
//   Future<void> _saveMpin(String pin) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('mpin', pin);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//         fontSize: 22,
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//       ),
//       decoration: BoxDecoration(
//         color:isDarkMode?Theme.of(context).scaffoldBackgroundColor : Theme.of(context).colorScheme.primary,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//
//     return Scaffold(
//       backgroundColor:isDarkMode ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
//       body: Column(
//         children: [
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
//                 const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Text(
//                       'Create your new pin',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize:MediaQuery.of(context).size.width*.065,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Enter Your Old PIN",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey),
//                 ),
//                 const SizedBox(height: 16),
//                 Pinput(
//                   length: 4,
//                   controller: _createPinController,
//                   focusNode: _createPinFocusNode,
//                   defaultPinTheme: defaultPinTheme,
//                   focusedPinTheme: defaultPinTheme.copyWith(
//                     decoration: BoxDecoration(
//                       color:isDarkMode? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).colorScheme.primary,
//                       border: Border.all(
//                           color: Theme.of(context).colorScheme.secondary,
//                           width: 2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onCompleted: (_) {
//                     FocusScope.of(context).requestFocus(_reenterPinFocusNode);
//                   },
//                 ),
//                 const SizedBox(height: 32),
//                 const Text(
//                   "Enter Your New PIN",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey),
//                 ),
//                 const SizedBox(height: 16),
//                 Pinput(
//                   length: 4,
//                   controller: _reenterPinController,
//                   focusNode: _reenterPinFocusNode,
//                   defaultPinTheme: defaultPinTheme,
//                   focusedPinTheme: defaultPinTheme.copyWith(
//                     decoration: BoxDecoration(
//                       color:isDarkMode?Theme.of(context).scaffoldBackgroundColor : Theme.of(context).colorScheme.primary,
//                       border: Border.all(
//                           color:isDarkMode?Theme.of(context).scaffoldBackgroundColor : Theme.of(context).colorScheme.secondary,
//                           width: 2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onCompleted: (_) {
//                     if (_createPinController.text !=
//                         _reenterPinController.text) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("MPINs do not match")),
//                       );
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor:isDarkMode?Color(0xFFD44D5C) : Theme.of(context).colorScheme.primary,
//               padding:
//               const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () async {
//               if (_createPinController.text ==
//                   _reenterPinController.text &&
//                   _createPinController.text.length == 4) {
//                 await _saveMpin(_createPinController.text);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("MPIN saved successfully!")),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Please enter valid MPIN")),
//                 );
//               }
//             },
//             child: const Text(
//               "Save",
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
