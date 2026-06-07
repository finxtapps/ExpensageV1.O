import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool isSelected;
  final IconData? icon;

  const FilterButton(this.text, this.color, this.isSelected, {this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
            color: isSelected ? color : Colors.grey.shade300, width: 1.w),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon,
                color: isSelected ? color : Colors.grey.shade600,
                size: 18.sp),
          if (icon != null) SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? color : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
