import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomPieChartTimeFilter extends StatelessWidget {
  final String selectedOption;
  final ValueChanged<String> onChanged;

  const CustomPieChartTimeFilter({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // ❗ SAME options (logic safe)
    final List<String> options = [
      'Lifetime',
      'Monthly',
      'Yearly',
      'Weekly'

    ];

    return Container(
      // ✅ OLD HEIGHT (exact)
      height: MediaQuery.of(context).size.width * 0.07,

      // ✅ OLD PADDING (exact)
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),

      // ✅ OLD DECORATION (exact)
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 1.w),
        color: isDarkMode
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedOption,

          // ✅ OLD ICON (exact)
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 16.sp,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),

          // ✅ SAME ITEMS, ONLY TEXT TRANSLATED
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value.toLowerCase().tr(), // 🌍 localization
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            );
          }).toList(),

          // ✅ OLD onChanged (exact)
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
