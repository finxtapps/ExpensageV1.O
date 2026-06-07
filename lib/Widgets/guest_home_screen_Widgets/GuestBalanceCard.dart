// guest_balance_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providerListner/currency_notifier.dart';

class GuestBalanceCard extends StatelessWidget {
  const GuestBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🔒 Safe dummy values
    const int income = 0;
    const int expense = 0;
    const int monthlyBudget = 0;

    return Container(
      height: 195.h,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFFD44D5C)
              : Colors.white.withOpacity(0.9),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'monthly_budget'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down,
                      color: Colors.white, size: 20.sp),
                ],
              ),
              Icon(Icons.more_horiz,
                  color: Colors.white, size: 24.sp),
            ],
          ),

          SizedBox(height: 10),

          Consumer<CurrencyNotifier>(
            builder: (_, currencyProvider, __) {
              return Text(
                '${currencyProvider.currency} $monthlyBudget',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),

          SizedBox(height: 18.h),

          Row(
            children: [
              _buildTile(
                icon: Icons.arrow_downward,
                title: 'income'.tr(),
                amount: income,
                isDarkMode: isDarkMode,
              ),
              SizedBox(width: 15.w),
              _buildTile(
                icon: Icons.arrow_upward,
                title: 'expenses'.tr(),
                amount: expense,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required int amount,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFFD44D5C)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 16.5.sp),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.3.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Consumer<CurrencyNotifier>(
                builder: (_, currencyProvider, __) {
                  return Text(
                    '${currencyProvider.currency} $amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
