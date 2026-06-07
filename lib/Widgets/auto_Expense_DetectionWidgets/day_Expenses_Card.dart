import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'expense_item.dart';

class DayExpensesCard extends StatelessWidget {
  final String day;
  final List<ExpenseItem> expenses;

  const DayExpensesCard({super.key, required this.day, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r)),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$day (${expenses.length})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Icon(Icons.keyboard_arrow_up, size: 24.sp),
              ],
            ),
            SizedBox(height: 10.h),
            ...expenses.map((expense) => _buildExpenseRow(expense)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseRow(ExpenseItem expense) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: expense.statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(expense.icon,
                color: expense.statusColor, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expense ${expense.status}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: expense.statusColor,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  '${expense.time}   ${expense.minutesAgo}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (expense.showEdit)
            TextButton(
              onPressed: () {},
              child: Text(
                'Edit',
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp),
              ),
            )
          else
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(60.w, 30.h),
                    side: BorderSide(
                        color: Colors.grey.shade300, width: 1.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.close,
                          color: Colors.grey.shade600, size: 18.sp),
                      Text('Dismiss',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 12.sp)),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(60.w, 30.h),
                    side: BorderSide(color: Colors.green, width: 1.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check,
                          color: Colors.green, size: 18.sp),
                      Text('Review',
                          style: TextStyle(
                              color: Colors.green, fontSize: 12.sp)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
