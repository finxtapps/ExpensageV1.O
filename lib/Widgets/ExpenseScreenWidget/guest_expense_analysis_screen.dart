import 'package:expensag/Widgets/ExpenseScreenWidget/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'ExpenseAnalysisHeader.dart';
import 'bar_chart.dart';

class GuestExpenseAnalysisScreen extends StatefulWidget {
  const GuestExpenseAnalysisScreen({super.key});

  @override
  State<GuestExpenseAnalysisScreen> createState() => _GuestExpenseAnalysisScreenState();
}

class _GuestExpenseAnalysisScreenState extends State<GuestExpenseAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: mediaHeight * 0.12,
                  child: const ExpenseanalysisHeader(),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaHeight * 0.125),
              child: SingleChildScrollView(
                child: Column(
                  children: [BarChartWidget(),
                    /// ✅ SAME UI FEEL, SAFE WIDGET
                    const RadialChartWidget(active: true),
                    SizedBox(height: 20.h),

                    /// CTA
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.15),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.lock_outline, size: 40),
                            SizedBox(height: 10.h),
                            Text(
                              "Login to view detailed expense analysis",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
