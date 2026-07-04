import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home_Screen_Widegets/Income_Help_Banner.dart';

class ExpenseanalysisHeader extends StatelessWidget {
  const ExpenseanalysisHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -30,
            right: 1,
            left: 1,

            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 50.0),
              child:  IncomeHelpBanner(
                customPadding: true,
                heroTag: "analysisHelpFormHero",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
