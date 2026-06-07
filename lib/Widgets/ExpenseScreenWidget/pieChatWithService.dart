import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../Api_Models/top_category_model.dart';
import '../../Api_Services/top_category_service.dart';
import '../../component/Pie_chart_time _filter.dart';
import '../../theme/header_Color.dart';
import '../../providerListner/theme_notifier.dart';

class PieServiceChartWidget extends StatefulWidget {
  final bool active;
  const PieServiceChartWidget({super.key, this.active = false});

  @override
  State<PieServiceChartWidget> createState() =>
      _PieServiceChartWidgetState();
}

class _PieServiceChartWidgetState extends State<PieServiceChartWidget>
    with SingleTickerProviderStateMixin {

  String selectedFilter = 'Yearly';

  late final AnimationController _controller;
  late final Animation<double> _animation;

  final TopCategoryService _service = TopCategoryService();

  TopCategoryResponse? _apiResponse;
  bool _isLoading = false;

  final List<List<Color>> _gradientColors = [
    [Colors.blueAccent, Colors.lightBlueAccent],
    [Colors.greenAccent, Colors.tealAccent],
    [Colors.purpleAccent, Colors.deepPurpleAccent],
    [Colors.pinkAccent, Colors.redAccent],
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _fetchData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.active) {
        _controller.reset();
        _startAnimation();
      }
    });
  }

  @override
  void dispose() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PieServiceChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _controller.reset();
      _startAnimation();
    }
  }

  void _startAnimation() => _controller.forward(from: 0);

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    String? period;

    switch (selectedFilter) {
      case 'Monthly':
        period = 'monthly';
        break;
      case 'Weekly':
        period = 'weekly';
        break;
      case 'Yearly':
        period = 'yearly';
        break;
      case 'Lifetime':
        period = null;
        break;
    }

    final result = await _service.getTopCategories(period: period);

    if (!mounted) return;

    setState(() {
      _apiResponse = result;
      _isLoading = false;
    });

    if (result != null) {
      _controller.reset();
      _startAnimation();
    }
  }

  List<_ChartData> _getChartData() {
    final values = _apiResponse?.data ?? [];
    if (values.isEmpty) return [];

    double maxPercentage = 0;

    for (var e in values) {
      if (e.percentage > maxPercentage) {
        maxPercentage = e.percentage.toDouble();
      }
    }

    return values.map((item) {
      double animatedValue =
          item.percentage.toDouble() * _animation.value;

      if (animatedValue < 0.1) animatedValue = 0.1;

      return _ChartData(
        item.category,
        animatedValue,
        _gradientColors[
        values.indexOf(item) % _gradientColors.length],
        highlight: item.percentage.toDouble() == maxPercentage,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {

        final hasData =
            _apiResponse != null && _apiResponse!.data.isNotEmpty;

        final chartData = hasData ? _getChartData() : [];
        final highest = hasData ? _apiResponse!.highestExpense : null;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
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
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Container(
                height: 270.h,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [

                    /// HEADER
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'categories'.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        CustomPieChartTimeFilter(
                          selectedOption: selectedFilter,
                          onChanged: (value) {
                            setState(() => selectedFilter = value);
                            _fetchData();
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    /// CONTENT
                    Expanded(
                      child: Stack(
                        children: [

                          /// 1️⃣ Initial Load
                          if (_apiResponse == null)
                            const Center(
                              child: CircularProgressIndicator(),
                            )

                          /// 2️⃣ Data Available
                          else if (hasData)
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [

                                /// LEFT SIDE
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10.r),
                                          color: isDarkMode
                                              ? Colors.white12
                                              : Colors.white30,
                                        ),
                                        child: Text(
                                          '🔥 Highest Expense:\n'
                                              '${highest?.category ?? ''} (${highest?.percentage ?? 0}%)',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                                ? Colors.orangeAccent
                                                : Colors.white,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 25.h),

                                      ...List.generate(chartData.length,
                                              (i) {
                                            final data = chartData[i];

                                            return Padding(
                                              padding:
                                              EdgeInsets.symmetric(vertical: 2.h),
                                              child: Row(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 10.w,
                                                    height: 10.w,
                                                    decoration:
                                                    BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient:
                                                      LinearGradient(
                                                          colors: data
                                                              .gradientColors),
                                                    ),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  Text(
                                                    data.category,
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: isDarkMode
                                                          ? Colors.white70
                                                          : Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    '${data.value.toStringAsFixed(0)}%',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: isDarkMode
                                                          ? Colors.white54
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),

                                /// RIGHT SIDE GAUGE
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [

                                      SfRadialGauge(
                                        axes: List.generate(
                                            chartData.length, (i) {
                                          final data = chartData[i];

                                          return RadialAxis(
                                            minimum: 0,
                                            maximum: 100,
                                            startAngle: 0,
                                            endAngle: 360,
                                            showTicks: false,
                                            showLabels: false,
                                            radiusFactor: 0.9 - (i * 0.13),
                                            axisLineStyle: AxisLineStyle(
                                              thickness: 7.r,
                                              color: isDarkMode
                                                  ? Colors.white12
                                                  : Colors.white30,
                                              cornerStyle:
                                              CornerStyle.bothCurve,
                                            ),
                                            pointers: [
                                              RangePointer(
                                                value: data.value,
                                                width: 8.r,
                                                cornerStyle:
                                                CornerStyle.bothCurve,
                                                gradient: SweepGradient(
                                                    colors:
                                                    data.gradientColors),
                                                enableAnimation: true,
                                                animationDuration: 900,
                                              ),
                                            ],
                                          );
                                        }),
                                      ),

                                      Container(
                                        padding: EdgeInsets.all(12.w),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              blurRadius: 8,
                                              offset:
                                              const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.account_balance_wallet_rounded,
                                          size: 35.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )

                          /// 3️⃣ No Data
                          else
                            Center(
                              child: Text(
                                "No data available",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ),

                          /// 4️⃣ Overlay Loader on Filter Change
                          if (_isLoading && _apiResponse != null)
                            Container(
                              color: Colors.black.withOpacity(0.2),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChartData {
  _ChartData(this.category, this.value, this.gradientColors,
      {this.highlight = false});

  final String category;
  final double value;
  final List<Color> gradientColors;
  final bool highlight;
}






























// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// import '../../Api_Models/top_category_model.dart';
// import '../../Api_Services/top_category_service.dart';
// import '../../component/Pie_chart_time _filter.dart';
// import '../../theme/header_Color.dart';
// import '../../theme/theme_notifier.dart';
//
//
//
// class PieServiceChartWidget extends StatefulWidget {
//   final bool active;
//   const PieServiceChartWidget({super.key, this.active = false});
//
//   @override
//   State<PieServiceChartWidget> createState() =>
//       _PieServiceChartWidgetState();
// }
//
// class _PieServiceChartWidgetState extends State<PieServiceChartWidget>
//     with SingleTickerProviderStateMixin {
//
//   String selectedFilter = 'Yearly';
//
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//
//   final TopCategoryService _service = TopCategoryService();
//
//   TopCategoryResponse? _apiResponse;
//   bool _isLoading = false;
//
//   final List<List<Color>> _gradientColors = [
//     [Colors.blueAccent, Colors.lightBlueAccent],
//     [Colors.greenAccent, Colors.tealAccent],
//     [Colors.purpleAccent, Colors.deepPurpleAccent],
//     [Colors.pinkAccent, Colors.redAccent],
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//
//     _animation =
//         CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
//
//     _fetchData();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.active) {
//         _controller.reset();
//         _startAnimation();
//       }
//     });
//   }
//
//
//
//
//   @override
//   void dispose() {
//     if (_controller.isAnimating) {
//       _controller.stop();
//     }
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didUpdateWidget(covariant PieServiceChartWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.active && !oldWidget.active) {
//       _controller.reset();
//       _startAnimation();
//     }
//   }
//
//
//
//   void _startAnimation() => _controller.forward(from: 0);
//
//   Future<void> _fetchData() async {
//     setState(() => _isLoading = true);
//
//     String? period;
//
//     switch (selectedFilter) {
//       case 'Monthly':
//         period = 'monthly';
//         break;
//       case 'Weekly':
//         period = 'weekly';
//         break;
//       case 'Yearly':
//         period = 'yearly';
//         break;
//       case 'Lifetime':
//         period = null;
//         break;
//     }
//
//     final result = await _service.getTopCategories(period: period);
//
//     if (!mounted) return;
//
//     setState(() {
//       _apiResponse = result;
//       _isLoading = false;
//     });
//
//     if (result != null) {
//       _controller.reset();
//       _startAnimation();
//     }
//   }
//
//
//
//
//
//   List<_ChartData> _getChartData() {
//     final values = _apiResponse?.data ?? [];
//
//     if (values.isEmpty) return [];
//
//     double maxPercentage = 0;
//
//     for (var e in values) {
//       if (e.percentage > maxPercentage) {
//         maxPercentage = e.percentage.toDouble();
//       }
//     }
//
//     return values.map((item) {
//       double animatedValue =
//           item.percentage.toDouble() * _animation.value;
//
//       if (animatedValue < 0.1) animatedValue = 0.1;
//
//       return _ChartData(
//         item.category,
//         animatedValue,
//         _gradientColors[
//         values.indexOf(item) % _gradientColors.length],
//         highlight: item.percentage.toDouble() == maxPercentage,
//       );
//     }).toList();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode =
//         Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, _) {
//         final hasData =
//             _apiResponse != null && _apiResponse!.data.isNotEmpty;
//
//         final chartData = hasData ? _getChartData() : [];
//
//         final highest = hasData ? _apiResponse!.highestExpense : null;
//      //   ✅ 1️⃣ Loading State
//      //    if (_isLoading) {
//      //      return
//         //      const Center(
//      //        child: CircularProgressIndicator(),
//      //      );
//      //    }
//         //
//         // // ✅ 2️⃣ Null ya Empty Data
//         // if (_apiResponse == null || _apiResponse!.data.isEmpty) {
//         //   return const Center(
//         //     child: Text("No data available"),
//         //   );
//         // }
//         //
//       //   final chartData = _getChartData();
//         //
//       //  final highest = _apiResponse!.highestExpense;
//         //
//         // // ✅ 3️⃣ Highest null check
//         // if (highest == null) {
//         //   return const Center(
//         //     child: Text("No highest expense found"),
//         //   );
//         // }
//
//
//
//
//
//         return Container(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           decoration: BoxDecoration(
//             gradient: themeProvider.currentTheme == 'Pink'
//                 ? HeaderColor.pinkGradient
//                 : themeProvider.currentTheme == 'Teal'
//                 ? HeaderColor.greenGradient
//                 : themeProvider.currentTheme == 'Blue'
//                 ? HeaderColor.blueGradient
//                 : themeProvider.currentTheme == 'Orange'
//                 ? HeaderColor.orangeGradient
//                 : HeaderColor.darkGradient,
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 height: 270.h,
//                 padding: EdgeInsets.all(6.w),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context)
//                       .colorScheme
//                       .primary
//                       .withOpacity(.2),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Column(
//                   children: [
//
//                     Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'categories'.tr(),
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             color: isDarkMode
//                                 ? Colors.white
//                                 : Colors.black87,
//                           ),
//                         ),
//                         CustomPieChartTimeFilter(
//                           selectedOption: selectedFilter,
//                           onChanged: (value) {
//                             setState(() => selectedFilter = value);
//                             _fetchData();
//                           },
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: 8.h),
//
//                     Expanded(
//                       child: Stack(
//                         children: [
//
//                           /// ✅ MAIN CONTENT (Always visible if data exists)
//                           if (hasData)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Flexible(
//                                   fit: FlexFit.loose,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//
//                                       Container(
//                                         padding: const EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.r),
//                                           color: isDarkMode
//                                               ? Colors.white12
//                                               : Colors.white30,
//                                         ),
//                                         child: Text(
//                                           '🔥 Highest Expense:\n'
//                                               '${highest?.category ?? ''} (${highest?.percentage ?? 0}%)',
//                                           style: TextStyle(
//                                             fontSize: 14.sp,
//                                             fontWeight: FontWeight.bold,
//                                             color: isDarkMode
//                                                 ? Colors.orangeAccent
//                                                 : Colors.white,
//                                           ),
//                                         ),
//                                       ),
//
//                                       SizedBox(height: 25.h),
//
//                                       ...List.generate(chartData.length, (i) {
//                                         final data = chartData[i];
//
//                                         return Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 2.h),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Container(
//                                                 width: 10.w,
//                                                 height: 10.w,
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   gradient: LinearGradient(
//                                                       colors: data.gradientColors),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 6.w),
//                                               Text(
//                                                 data.category,
//                                                 style: TextStyle(
//                                                   fontSize: 13.sp,
//                                                   color: isDarkMode
//                                                       ? Colors.white70
//                                                       : Colors.black87,
//                                                 ),
//                                               ),
//                                               SizedBox(width: 4.w),
//                                               Text(
//                                                 '${data.value.toStringAsFixed(0)}%',
//                                                 style: TextStyle(
//                                                   fontSize: 12.sp,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: isDarkMode
//                                                       ? Colors.white54
//                                                       : Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }),
//                                     ],
//                                   ),
//                                 ),
//
//                                 Flexible(
//                                   fit: FlexFit.loose,
//                                   child: Stack(
//                                     alignment: Alignment.center,
//                                     children: [
//
//                                       SfRadialGauge(
//                                         axes: List.generate(chartData.length, (i) {
//                                           final data = chartData[i];
//
//                                           return RadialAxis(
//                                             minimum: 0,
//                                             maximum: 100,
//                                             startAngle: 0,
//                                             endAngle: 360,
//                                             showTicks: false,
//                                             showLabels: false,
//                                             radiusFactor: 0.9 - (i * 0.13),
//                                             axisLineStyle: AxisLineStyle(
//                                               thickness: 7.r,
//                                               color: isDarkMode
//                                                   ? Colors.white12
//                                                   : Colors.white30,
//                                               cornerStyle: CornerStyle.bothCurve,
//                                             ),
//                                             pointers: [
//                                               RangePointer(
//                                                 value: data.value,
//                                                 width: 8.r,
//                                                 cornerStyle: CornerStyle.bothCurve,
//                                                 gradient: SweepGradient(
//                                                     colors: data.gradientColors),
//                                                 enableAnimation: true,
//                                                 animationDuration: 900,
//                                               ),
//                                             ],
//                                           );
//                                         }),
//                                       ),
//
//                                       Container(
//                                         padding: EdgeInsets.all(12.w),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(0.15),
//                                               blurRadius: 8,
//                                               offset: const Offset(2, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Icon(
//                                           Icons.account_balance_wallet_rounded,
//                                           size: 35.sp,
//                                           color: Theme.of(context).colorScheme.primary,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             )
//                           else
//                             Center(
//                               child: Text(
//                                 "No data available",
//                                 style: TextStyle(
//                                   color: isDarkMode
//                                       ? Colors.white70
//                                       : Colors.black54,
//                                 ),
//                               ),
//                             ),
//
//                           /// ✅ LOADER OVERLAY
//                           if (_isLoading)
//                             Container(
//                               color: Colors.black.withOpacity(0.2),
//                               child: const Center(
//                                 child: CircularProgressIndicator(),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _ChartData {
//   _ChartData(this.category, this.value, this.gradientColors,
//       {this.highlight = false});
//
//   final String category;
//   final double value;
//   final List<Color> gradientColors;
//   final bool highlight;
// }


