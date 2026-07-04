import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Screens/custom_popUp_Screen.dart';
import '../../component/customHeader.dart';
import '../../providerListner/theme_notifier.dart';
import '../../theme/header_Color.dart';
import '../../theme/theme_button.dart';

/// 🔹 Language Model
class AppLanguage {
  final String name;
  final String code;
  final String flag;

  AppLanguage({
    required this.name,
    required this.code,
    required this.flag,
  });
}

/// 🔹 Supported Languages List
final List<AppLanguage> allLanguages = [
  AppLanguage(name: 'English', code: 'en', flag: '🇺🇸'),
  AppLanguage(name: 'Hindi', code: 'hi', flag: '🇮🇳'),
  AppLanguage(name: 'Arabic', code: 'ar', flag: '🇸🇦'),
  AppLanguage(name: 'French', code: 'fr', flag: '🇫🇷'),
  AppLanguage(name: 'German', code: 'de', flag: '🇩🇪'),
  AppLanguage(name: 'Spanish', code: 'es', flag: '🇪🇸'),
  AppLanguage(name: 'Chinese', code: 'zh', flag: '🇨🇳'),
  AppLanguage(name: 'Japanese', code: 'ja', flag: '🇯🇵'),
];

class SettingsContent extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const SettingsContent({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        color: isDarkMode
            ? Theme.of(context).primaryColor
            : const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // _buildSettingItem(
              //   context,
              //   icon: Icons.attach_money,
              //   title: 'Currency',
              //   hasArrow: true,
              //   onTap: () {
              //     Navigator.pushNamed(context, '/currency_select');
              //   },
              // ),

              //const SizedBox(height: 15),

              _buildSettingItem(
                context,
                icon: Icons.brightness_6,
                title: 'theme'.tr(),
                hasArrow: true,
                toggleValue: isDarkMode,
                onToggleChanged: onToggleDarkMode,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ThemePickerDialog(),
                  );
                },
              ),

              const SizedBox(height: 15),

              _buildSettingItem(
                context,
                icon: Icons.lock_outline,
                title: "security_and_privacy".tr(),
                hasArrow: true,
                onTap: () {
                  Navigator.pushNamed(context, '/set_pin_and_fingerprint');
                },
              ),

              const SizedBox(height: 15),

              /// 🌍 LANGUAGE (EasyLocalization Connected)
              _buildSettingItem(
                context,
                icon: Icons.language,
                title: 'language'.tr(),
                hasArrow: true,
                onTap: () {
                  _showLanguageBottomSheet(context);
                },
              ),

              const SizedBox(height: 15),

              _buildSettingItem(
                context,
                icon: Icons.location_on_outlined,
                title: 'location'.tr(),
                hasArrow: true,
                onTap: () {
                  Navigator.pushNamed(context, '/location');
                },
              ),

              const SizedBox(height: 15),

              _buildSettingItem(
                context,
                icon: Icons.help_outline,
                title: 'faq_and_support'.tr(),
                hasArrow: true,
                onTap: () {
                  CustomPopup.show(
                      context: context,
                      title: "coming_soon".tr(),
                      message: "feature_under_development".tr()
                    // "This feature is currently under development and will be available soon.",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable setting item (UNCHANGED UI)
  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        bool hasArrow = false,
        bool hasToggle = false,
        bool toggleValue = false,
        ValueChanged<bool>? onToggleChanged,
        VoidCallback? onTap,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: hasToggle ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).colorScheme.primary.withOpacity(.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isDarkMode ? Colors.white : Colors.black87, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: screenWidth * .042,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasArrow)
              Icon(Icons.chevron_right,
                  color: isDarkMode ? Colors.white : Colors.black54),
            if (hasToggle)
              _buildToggleSwitch(toggleValue, onToggleChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(
      bool toggleValue, ValueChanged<bool>? onToggleChanged) {
    return Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: toggleValue
              ? [Colors.blue.shade300, Colors.blue.shade600]
              : [Colors.orange.shade300, Colors.orange.shade600],
        ),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: toggleValue ? 30 : 0,
            child: GestureDetector(
              onTap: () {
                if (onToggleChanged != null) {
                  onToggleChanged(!toggleValue);
                }
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🌍 Language Picker (Currency-style, EasyLocalization)
  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LanguagePickerSheet(),
    );
  }
}

/// 🔹 Language Picker Sheet
class LanguagePickerSheet extends StatefulWidget {
  const LanguagePickerSheet({super.key});

  @override
  State<LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<LanguagePickerSheet> {
  late List<AppLanguage> filteredLanguages;
  AppLanguage? selectedLanguage;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      filteredLanguages = allLanguages;

      final currentCode = context.locale.languageCode;
      selectedLanguage =
          allLanguages.firstWhere((l) => l.code == currentCode);

      _initialized = true;
    }
  }

  void _filter(String query) {
    setState(() {
      filteredLanguages = allLanguages
          .where((l) =>
          l.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

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
              child: CustomHeader(title: 'language'.tr(),
                fontsize: 25,

              )

          ),
        ),

      //   SizedBox(height: 14.h),

        Padding(
          padding:  EdgeInsets.only(left: 12.w,right: 12.w,top:20.h),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'search_language'.tr(),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.black
                  : Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: _filter,
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: filteredLanguages.length,
            itemBuilder: (context, index) {
              final lang = filteredLanguages[index];
              final selected = selectedLanguage?.code == lang.code;

              return ListTile(
                leading:
                Text(lang.flag, style: const TextStyle(fontSize: 24)),
                title: Text(lang.name),
                trailing: selected
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() => selectedLanguage = lang);
                },
              );
            },
          ),
        ),

        Padding(
          padding:  EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: selectedLanguage == null
                ? null
                : () {
              context.setLocale(
                  Locale(selectedLanguage!.code));
              Navigator.pop(context);
            },
            child:  Text(
              'save'.tr(),
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}





















// import 'package:flutter/material.dart';
//
// import '../../theme/theme_notifier.dart';
//
// class SettingsContent extends StatelessWidget {
//   final bool isDarkMode;
//   final ValueChanged<bool> onToggleDarkMode;
//
//   const SettingsContent({
//     super.key,
//     required this.isDarkMode,
//     required this.onToggleDarkMode,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Expanded(
//       child: Container(
//         color:isDarkMode?Theme.of(context).primaryColor  :Color(0xFFF5F5F5),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//                _buildSettingItem(
//                   context,
//                   icon: Icons.attach_money,
//                   title: 'Currency',
//                   hasArrow: true,
//
//                   onTap: () {
//                     Navigator.pushNamed(context, '/currency_select');
//                   },
//                 ),
//
//
//              ////////////////////////////////////
//
//               ///////////////////////////////////////
//               const SizedBox(height: 15),
//               _buildSettingItem(
//                 context,
//                 icon: Icons.brightness_6,
//                 title: 'Theme',
//                 hasArrow: true,
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) =>  ThemePickerDialog(),
//                   );
//                 },
//                 toggleValue: isDarkMode,
//                 onToggleChanged: onToggleDarkMode,
//               ),
//               const SizedBox(height: 15),
//               _buildSettingItem(
//                 context,
//                 icon: Icons.lock_outline,
//                 title: 'Password',
//                 hasArrow: true,
//                 onTap: () {
//                   Navigator.pushNamed(context, '/set_pin_and_fingerprint');
//                 },
//               ),
//               const SizedBox(height: 15),
//               _buildSettingItem(
//                 context,
//                 icon: Icons.language,
//                 title: 'Language',
//                 hasArrow: true,
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Language settings would open here'),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 15),
//               InkWell(
//                 onTap: (){
//                   Navigator.pushNamed(context, '/location');
//                 },
//                 child: _buildSettingItem(
//                   context,
//                   icon: Icons.location_on_outlined,
//                   title: 'Location',
//                   hasArrow: true,
//                   onTap: () {
//                     Navigator.pushNamed(context, '/location');
//                   },
//                 ),
//               ),
//               const SizedBox(height: 15),
//               _buildSettingItem(
//                 context,
//                 icon: Icons.help_outline,
//                 title: 'FAQ and support',
//                 hasArrow: true,
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('FAQ and support would open here'),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 15),
//               // SizedBox(height: 80,
//               //   width: 200,
//               //   child: Builder(
//               //         builder: (context) => ThemeButton(), // ✅ Now has valid Provider context
//               //       ),
//               // )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSettingItem(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         bool hasArrow = false,
//         bool hasToggle = false,
//         bool toggleValue = false,
//         ValueChanged<bool>? onToggleChanged,
//         VoidCallback? onTap,
//       }) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return GestureDetector(
//       onTap: hasToggle ? null : onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         decoration: BoxDecoration(
//           color:isDarkMode? Theme.of(context).scaffoldBackgroundColor :Theme.of(context).colorScheme.primary.withOpacity(.2), // Light pink/beige color
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color:isDarkMode? Colors.white: Colors.black87,
//               size: 24,
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color:isDarkMode? Colors.white: Colors.black87,
//                   fontSize: screenWidth*.042,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             if (hasArrow)
//                Icon(
//                 Icons.chevron_right,
//                 color:isDarkMode? Colors.white: Colors.black54,
//                 size: screenWidth * 0.05,
//               ),
//             if (hasToggle)
//               _buildToggleSwitch(toggleValue, onToggleChanged),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildToggleSwitch(bool toggleValue, ValueChanged<bool>? onToggleChanged) {
//     return Container(
//       width: 60,
//       height: 30,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         gradient: LinearGradient(
//           colors: toggleValue
//               ? [Colors.blue.shade300, Colors.blue.shade600]
//               : [Colors.orange.shade300, Colors.orange.shade600],
//         ),
//       ),
//       child: Stack(
//         children: [
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 200),
//             left: toggleValue ? 30 : 0,
//             child: GestureDetector(
//               onTap: () {
//                 if (onToggleChanged != null) {
//                   onToggleChanged(!toggleValue);
//                 }
//               },
//               child: Container(
//                 width: 30,
//                 height: 30,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
