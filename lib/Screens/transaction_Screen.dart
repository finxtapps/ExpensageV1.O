import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Widgets/auto_Expense_DetectionWidgets/day_Expenses_Card.dart';
import '../Widgets/auto_Expense_DetectionWidgets/expense_item.dart';
import '../Widgets/auto_Expense_DetectionWidgets/filter_Button.dart';
import '../component/header_appbar.dart';
import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class AutoExpenseDetectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Column(
        children: [
        HeaderAppbar(title: "Auto Expense Detection",
        back_btn: true,),

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
            padding:
            EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            color:  isDarkMode?Theme.of(context).primaryColor  :Color(0xFFF5F5F5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 20.sp),
                  onPressed: () {},
                ),
                Text(
                  '24 Mar- 30 Mar 2025',
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 20.sp),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterButton('All', Colors.red, true),
                  FilterButton('Detected', Colors.orange, false,
                      icon: Icons.error_outline),
                  FilterButton('Saved', Colors.green, false,
                      icon: Icons.check_circle_outline),
                  FilterButton('Dismissed', Colors.grey, false,
                      icon: Icons.cancel_outlined),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                DayExpensesCard(
                  day: 'Wednesday, 26 Mar 2025',
                  expenses: [
                    ExpenseItem(
                        time: '9:45 am',
                        minutesAgo: '17 mins',
                        status: 'Detected',
                        statusColor: Colors.green,
                        icon: Icons.receipt_long,
                        showEdit: true),
                  ],
                ),
                DayExpensesCard(
                  day: 'Tuesday, 25 Mar 2025',
                  expenses: [
                    ExpenseItem(
                        time: '9:45 am',
                        minutesAgo: '17 mins',
                        status: 'Detected',
                        statusColor: Colors.orange,
                        icon: Icons.notifications_active),
                  ],
                ),
                DayExpensesCard(
                  day: 'Monday, 24 Mar 2025',
                  expenses: [
                    ExpenseItem(
                        time: '5:31 pm',
                        minutesAgo: '15 mins',
                        status: 'Detected',
                        statusColor: Colors.orange,
                        icon: Icons.notifications_active),
                    ExpenseItem(
                        time: '11:45 am',
                        minutesAgo: '12 mins',
                        status: 'Detected',
                        statusColor: Colors.orange,
                        icon: Icons.notifications_active),
                  ],
                ),
                DayExpensesCard(
                  day: 'Sunday, 23 Mar 2025',
                  expenses: [
                    ExpenseItem(
                        time: '9:45 am',
                        minutesAgo: '17 mins',
                        status: 'Detected',
                        statusColor: Colors.orange,
                        icon: Icons.notifications_active),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
