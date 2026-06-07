import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Screens/incomeTax&Expenses_help_Screen.dart';

class IncomeHelpBanner extends StatefulWidget {
  final bool customPadding = false;
  const IncomeHelpBanner({super.key, customPadding});

  @override
  State<IncomeHelpBanner> createState() => _IncomeHelpBannerState();
}

class _IncomeHelpBannerState extends State<IncomeHelpBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showHelpOverlay(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Help Form",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5), // background blur
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: const Money_Help_Option_screen(), // ✅ no Hero needed here now
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final mediaHeight = MediaQuery.of(context).size.height;
    if (isDarkMode) {
      return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20, top: 120.h),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Hero(
                tag: "helpFormHero1",
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: widget.customPadding
                        ? const EdgeInsets.only(top: 8.0)
                        : const EdgeInsets.only(top: 0),
                    child: Container(
                      padding: isDarkMode
                          ? const EdgeInsets.all(3)
                          : const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: SweepGradient(
                          startAngle: 0.0,
                          endAngle: 3.14 * 2,
                          colors: [
                            const Color(0xFFD44D5C),
                            Colors.blue,
                            const Color(0xFFD44D5C),
                          ],

                          transform: GradientRotation(_controller.value * 6.28),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _showHelpOverlay(context),
                        child: Container(
                          height: 40.h,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDarkMode
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.payments,
                                size: 26,
                                color: isDarkMode
                                    ? const Color(0xFFD44D5C)
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                "hi_need_help".tr(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: isDarkMode
                                    ? const Color(0xFFD44D5C)
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20, top: 120.h),
        child: Hero(
          tag: "helpFormHero",
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: widget.customPadding
                  ? const EdgeInsets.only(top: 8.0)
                  : const EdgeInsets.only(top: 0),
              child: Container(
                padding: isDarkMode
                    ? const EdgeInsets.all(3)
                    : const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1.4.sp),
                  color: Colors.white.withOpacity(0.6),
                  // gradient: SweepGradient(
                  //   startAngle: 0.0,
                  //   endAngle: 3.14 * 2,
                  //   colors: isDarkMode
                  //       ? [
                  //     const Color(0xFFD44D5C),
                  //     Colors.blue,
                  //     const Color(0xFFD44D5C)
                  //   ]
                  //       : [
                  //     Colors.white.withOpacity(0.7),
                  //     Colors.white.withOpacity(0.7),
                  //     Colors.white.withOpacity(0.7)
                  //   ],
                  //   transform: GradientRotation(
                  //       _controller.value * 6.28),
                  // ),
                ),
                child: InkWell(
                  onTap: () => _showHelpOverlay(context),
                  child: Container(
                    height: 40.h,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isDarkMode
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Icon(Icons.attach_money),
                        Icon(
                          Icons.payments,
                          size: 26,
                          color: isDarkMode
                              ? const Color(0xFFD44D5C)
                              : Theme.of(context).colorScheme.primary,
                        ),
                        // Icon(Icons.account_balance_wallet),

                        // FaIcon(
                        //   FontAwesomeIcons.x,
                        //   size: 26,
                        //   color: isDarkMode
                        //       ? const Color(0xFFD44D5C)
                        //       : Theme.of(context).colorScheme.primary,
                        // ),

                        // FaIcon(
                        //   FontAwesomeIcons.handHoldingDollar,
                        //   color: isDarkMode
                        //       ? const Color(0xFFD44D5C)
                        //       : Theme.of(context)
                        //       .colorScheme
                        //       .primary,
                        // ),
                        Text(
                          "hi_need_help".tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: isDarkMode
                              ? const Color(0xFFD44D5C)
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
