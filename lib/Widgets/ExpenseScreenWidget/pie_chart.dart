import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../component/time_filter.dart';
import '../../theme/header_Color.dart';
import '../../providerListner/theme_notifier.dart';

class RadialChartWidget extends StatefulWidget {
  final bool active;
  const RadialChartWidget({super.key, this.active = false});

  @override
  State<RadialChartWidget> createState() => _RadialChartWidgetState();
}

class _RadialChartWidgetState extends State<RadialChartWidget>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'Lifetime';
  DateTime? _selectedDate;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  final Map<String, List<double>> _chartData = {
    'Lifetime': [70, 55, 30, 80],
    'Weekly': [35, 63, 25, 40],
    'Monthly': [45, 30, 69, 25],
    'Yearly': [88, 60, 15, 25],
  };

  final Map<String, List<double>> _dateChartData = {
    '2025-09-01': [40, 20, 70, 50],
    '2025-09-02': [55, 45, 30, 80],
    '2025-09-03': [65, 25, 50, 40],
  };

  final List<List<Color>> _gradientColors = [
    [Colors.blueAccent, Colors.lightBlueAccent],
    [Colors.greenAccent, Colors.tealAccent],
    [Colors.purpleAccent, Colors.deepPurpleAccent],
    [Colors.pinkAccent, Colors.redAccent],
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.active) _startAnimation();
    });
  }

  @override
  void didUpdateWidget(covariant RadialChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _startAnimation();
    }
  }

  void _startAnimation() => _controller.forward(from: 0);

  List<_ChartData> _getChartData() {
    List<double> values = [];

    if (_selectedFilter == 'Date' && _selectedDate != null) {
      final key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      values = _dateChartData[key] ?? [0, 0, 0, 0];
    } else {
      values = _chartData[_selectedFilter]!;
    }

    double maxValue = values.reduce((a, b) => a > b ? a : b);

    return List.generate(values.length, (i) {
      double animatedValue = values[i] * _animation.value;
      if (animatedValue < 0.1) animatedValue = 0.1;

      return _ChartData(
        'category_number'.tr(args: ['${i + 1}']),
        animatedValue,
        _gradientColors[i % _gradientColors.length],
        highlight: values[i] == maxValue,
      );



    });
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            )
                : ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedFilter = 'Date';
        _startAnimation();
      });
    }
  }


  @override
  void dispose() {
    _controller.stop();   // stop animation first
    _controller.dispose(); // then dispose controller
    super.dispose();       // then call super
  }



  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final chartData = _getChartData();
        final maxData =
        chartData.reduce((a, b) => a.value > b.value ? a : b);

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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: .3,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'categories'.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color:
                            isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        TransactionTimeFilterDropdown(
                          selectedOption: _selectedFilter,
                          onChanged: (value) async {
                            if (value == 'Date') {
                              await _pickDate();
                            } else {
                              setState(() {
                                _selectedFilter = value;
                                _selectedDate = null;
                                _startAnimation();
                              });
                            }
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    /// CHART + INFO
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// LEFT INFO
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:  EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10.r),
                                  color: isDarkMode
                                      ? Colors.white12
                                      : Colors.white30,
                                ),
                                child: Text(
                                  '🔥 ${'hi_need_help'.tr()}\n'
                                      'Highest Expense:\n'
                                      '${maxData.category} (${maxData.value.toStringAsFixed(0)}%)',
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
                              ...List.generate(chartData.length, (i) {
                                final data = chartData[i];
                                return Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: 2.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                              colors: data.gradientColors),
                                          boxShadow: data.highlight
                                              ? [
                                            BoxShadow(
                                              color: data
                                                  .gradientColors.last
                                                  .withOpacity(0.6),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            )
                                          ]
                                              : [],
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
                                          fontWeight: data.highlight
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '${data.value.toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
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

                          /// RADIAL GAUGE (UNCHANGED)
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.translate(
                                  offset: Offset(10.w, 0),
                                  child: SfRadialGauge(
                                    axes: List.generate(chartData.length, (i) {
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
                                            cornerStyle:
                                            CornerStyle.bothCurve,
                                            width: 8.r,
                                            gradient: SweepGradient(
                                                colors:
                                                data.gradientColors),
                                            enableAnimation: true,
                                            animationDuration: 900,
                                          ),
                                          MarkerPointer(
                                            value: data.value,
                                            markerType:
                                            MarkerType.diamond,
                                            color:
                                            data.gradientColors.last,
                                            markerHeight: 14.r,
                                            markerWidth: 14.r,
                                            borderWidth: 1.5,
                                            borderColor: Colors.white
                                                .withOpacity(0.7),
                                            enableAnimation: true,
                                            animationDuration: 1200,
                                            elevation: 4,
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),

                                /// CENTER ICON
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.15),
                                          blurRadius: 8,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons
                                          .account_balance_wallet_rounded,
                                      size: 35.sp,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5.h),
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

  Color get color =>
      highlight ? gradientColors.last : gradientColors.first;
}



























// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:intl/intl.dart';
// import '../../component/time_filter.dart';
// import '../../theme/header_Color.dart';
// import '../../theme/theme_notifier.dart';
//
// class RadialChartWidget extends StatefulWidget {
//   final bool active;
//   const RadialChartWidget({super.key, this.active = false});
//
//   @override
//   State<RadialChartWidget> createState() => _RadialChartWidgetState();
// }
//
// class _RadialChartWidgetState extends State<RadialChartWidget>
//     with SingleTickerProviderStateMixin {
//   String _selectedFilter = 'Lifetime';
//   DateTime? _selectedDate;
//
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//
//   final Map<String, List<double>> _chartData = {
//     'Lifetime': [70, 55, 30, 80],
//     'Weekly': [35, 63, 25, 40],
//     'Monthly': [45, 30, 69, 25],
//     'Yearly': [88, 60, 15, 25],
//   };
//
//   final Map<String, List<double>> _dateChartData = {
//     '2025-09-01': [40, 20, 70, 50],
//     '2025-09-02': [55, 45, 30, 80],
//     '2025-09-03': [65, 25, 50, 40],
//   };
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
//     _controller =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.active) _startAnimation();
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant RadialChartWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.active && !oldWidget.active) {
//       _startAnimation();
//     }
//   }
//
//   void _startAnimation() => _controller.forward(from: 0);
//
//   List<_ChartData> _getChartData() {
//     List<double> values = [];
//     if (_selectedFilter == 'Date' && _selectedDate != null) {
//       final key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
//       values = _dateChartData[key] ?? [0, 0, 0, 0];
//     } else {
//       values = _chartData[_selectedFilter]!;
//     }
//
//     double maxValue = values.reduce((a, b) => a > b ? a : b);
//
//     return List.generate(values.length, (i) {
//       double animatedValue = values[i] * _animation.value;
//       if (animatedValue < 0.1) animatedValue = 0.1;
//       return _ChartData(
//         'Category ${i + 1}',
//         animatedValue,
//         _gradientColors[i % _gradientColors.length],
//         highlight: values[i] == maxValue,
//       );
//     });
//   }
//
//   Future<void> _pickDate() async {
//     DateTime now = DateTime.now();
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(now.year - 2),
//       lastDate: now,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: isDarkMode
//                 ? ColorScheme.dark(
//               primary: Colors.orange,
//               onPrimary: Colors.white,
//               surface: Colors.grey[900]!,
//               onSurface: Colors.white,
//             )
//                 : ColorScheme.light(
//               primary: Theme.of(context).colorScheme.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black87,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor:
//                 isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedFilter = 'Date';
//         _startAnimation();
//       });
//     } else {
//       setState(() {
//         _selectedFilter = 'Lifetime';
//         _selectedDate = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, _) {
//         final chartData = _getChartData();
//         final maxData = chartData.reduce((a, b) => a.value > b.value ? a : b);
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
//             boxShadow: [
//               BoxShadow(
//                 color: themeProvider.currentTheme == 'Pink'
//                     ? Colors.pinkAccent.withOpacity(0.4)
//                     : themeProvider.currentTheme == 'Teal'
//                     ? Colors.greenAccent.withOpacity(0.4)
//                     : themeProvider.currentTheme == 'Blue'
//                     ? Colors.lightBlueAccent.withOpacity(0.4)
//                     : themeProvider.currentTheme == 'Orange'
//                     ? Colors.orangeAccent.withOpacity(0.4)
//                     : Colors.white.withOpacity(0.1),
//                 spreadRadius: 3,
//                 blurRadius: 20,
//                 offset: const Offset(0, 8),
//               ),
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 spreadRadius: .3,
//                 blurRadius: 4,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 height: 270.h,
//                 padding: EdgeInsets.all(6.w),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary.withOpacity(.2),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Column(
//                   children: [
//                     /// Header (title + filter)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Categories',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             color: isDarkMode ? Colors.white : Colors.black87,
//                           ),
//                         ),
//                         TransactionTimeFilterDropdown(
//                           selectedOption: _selectedFilter,
//                           onChanged: (value) async {
//                             if (value == 'Date') {
//                               await _pickDate();
//                             } else {
//                               setState(() {
//                                 _selectedFilter = value;
//                                 _selectedDate = null;
//                                 _startAnimation();
//                               });
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: 10.h),
//
//                     /// Chart + Indicators Section
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           /// Left Indicators Section
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   color:
//                                   isDarkMode ? Colors.white12 : Colors.white30,
//                                 ),
//                                 padding: const EdgeInsets.all(10),
//                                 child: Text(
//                                   '🔥 Hi,\n Highest Expense:\n ${maxData.category} (${maxData.value.toStringAsFixed(0)}%)',
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     fontWeight: FontWeight.bold,
//                                     color: isDarkMode
//                                         ? Colors.orangeAccent
//                                         : Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 30.h),
//                               ...List.generate(chartData.length, (i) {
//                                 final data = chartData[i];
//                                 return Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 2.h),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Container(
//                                         width: 10.w,
//                                         height: 10.w,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: LinearGradient(
//                                               colors: data.gradientColors),
//                                           boxShadow: data.highlight
//                                               ? [
//                                             BoxShadow(
//                                               color: data.gradientColors.last
//                                                   .withOpacity(0.6),
//                                               blurRadius: 8,
//                                               spreadRadius: 1,
//                                             )
//                                           ]
//                                               : [],
//                                         ),
//                                       ),
//                                       SizedBox(width: 6.w),
//                                       Text(
//                                         data.category,
//                                         style: TextStyle(
//                                           fontSize: 13.sp,
//                                           color: isDarkMode
//                                               ? Colors.white70
//                                               : Colors.black87,
//                                           fontWeight: data.highlight
//                                               ? FontWeight.bold
//                                               : FontWeight.w500,
//                                         ),
//                                       ),
//                                       SizedBox(width: 4.w),
//                                       Text(
//                                         '${data.value.toStringAsFixed(0)}%',
//                                         style: TextStyle(
//                                           fontSize: 12.sp,
//                                           fontWeight: FontWeight.w500,
//                                           color: isDarkMode
//                                               ? Colors.white54
//                                               : Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }),
//                             ],
//                           ),
//
//                           /// Radial Chart + Center Icon Section
//                           Expanded(
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Transform.translate(
//                                   offset: Offset(10.w, 0),
//                                   child: SfRadialGauge(
//                                     axes: List.generate(chartData.length, (i) {
//                                       final data = chartData[i];
//                                       return RadialAxis(
//                                         minimum: 0,
//                                         maximum: 100,
//                                         startAngle: 0,
//                                         endAngle: 360,
//                                         showTicks: false,
//                                         showLabels: false,
//                                         radiusFactor: 0.9 - (i * 0.13),
//                                         axisLineStyle: AxisLineStyle(
//                                           thickness: 7.r,
//                                           color: isDarkMode
//                                               ? Colors.white12
//                                               : Colors.white30,
//                                           cornerStyle: CornerStyle.bothCurve,
//                                         ),
//                                         pointers: [
//                                           RangePointer(
//                                             value: data.value,
//                                             cornerStyle: CornerStyle.bothCurve,
//                                             width: 8.r,
//                                             gradient: SweepGradient(
//                                                 colors: data.gradientColors),
//                                             enableAnimation: true,
//                                             animationDuration: 900,
//                                           ),
//                                           MarkerPointer(
//                                             value: data.value,
//                                             markerType: MarkerType.diamond,
//                                             color: data.gradientColors.last,
//                                             markerHeight: 14.r,
//                                             markerWidth: 14.r,
//                                             borderWidth: 1.5,
//                                             borderColor:
//                                             Colors.white.withOpacity(0.7),
//                                             enableAnimation: true,
//                                             animationDuration: 1200,
//                                             elevation: 4,
//                                           ),
//                                         ],
//                                       );
//                                     }),
//                                   ),
//                                 ),
//
//                                 /// 💠 Center Icon
//                                 Center(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color:Colors.transparent,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color:
//                                           Colors.black.withOpacity(0.15),
//                                           blurRadius: 8,
//                                           offset: const Offset(2, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     padding: EdgeInsets.only(left:10.w),
//                                     child: Icon(
//                                       Icons.account_balance_wallet_rounded,
//                                       size: 35.sp,
//                                       color: Theme.of(context).colorScheme.secondary,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     SizedBox(height: 5.h),
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
//   _ChartData(this.category, this.value, this.gradientColors, {this.highlight = false});
//   final String category;
//   final double value;
//   final List<Color> gradientColors;
//   final bool highlight;
//
//   Color get color => highlight ? gradientColors.last : gradientColors.first;
// }



class uu{}






































// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:intl/intl.dart';
// import '../../component/time_filter.dart';
// import '../../theme/header_Color.dart';
// import '../../theme/theme_notifier.dart';
//
// class RadialChartWidget extends StatefulWidget {
//   final bool active;
//   const RadialChartWidget({super.key, this.active = false});
//
//   @override
//   State<RadialChartWidget> createState() => _RadialChartWidgetState();
// }
//
// class _RadialChartWidgetState extends State<RadialChartWidget>
//     with TickerProviderStateMixin {
//   String _selectedFilter = 'Lifetime';
//   DateTime? _selectedDate;
//
//   late final AnimationController _chartController;
//   late final Animation<double> _chartAnimation;
//
//   late final AnimationController _textController;
//   late final Animation<Offset> _textOffsetAnimation;
//   late final Animation<double> _textOpacityAnimation;
//   late final Animation<double> _textScaleAnimation;
//
//   final Map<String, List<double>> _chartData = {
//     'Lifetime': [70, 55, 30, 80],
//     'Weekly': [35, 63, 25, 40],
//     'Monthly': [45, 30, 69, 25],
//     'Yearly': [88, 60, 15, 25],
//   };
//
//   final Map<String, List<double>> _dateChartData = {
//     '2025-09-01': [40, 20, 70, 50],
//     '2025-09-02': [55, 45, 30, 80],
//     '2025-09-03': [65, 25, 50, 40],
//   };
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
//     _chartController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );
//     _chartAnimation = CurvedAnimation(
//       parent: _chartController,
//       curve: Curves.elasticOut,
//     );
//
//     _textController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _textOffsetAnimation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _textController,
//       curve: Curves.easeOutBack,
//     ));
//     _textOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _textController, curve: Curves.easeIn),
//     );
//     _textScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
//     );
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.active) _startAnimations();
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant RadialChartWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.active && !oldWidget.active) {
//       _startAnimations();
//     }
//   }
//
//   void _startAnimations() async {
//     _chartController.forward(from: 0);
//     _textController.reset();
//     await Future.delayed(const Duration(milliseconds: 1200));
//     _textController.forward();
//   }
//
//   List<_ChartData> _getChartData() {
//     List<double> values = [];
//     if (_selectedFilter == 'Date' && _selectedDate != null) {
//       final key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
//       values = _dateChartData[key] ?? [0, 0, 0, 0];
//     } else {
//       values = _chartData[_selectedFilter]!;
//     }
//
//     double maxValue = values.reduce((a, b) => a > b ? a : b);
//
//     return List.generate(values.length, (i) {
//       double animatedValue = values[i] * _chartAnimation.value;
//       if (animatedValue < 0.1) animatedValue = 0.1;
//
//       return _ChartData(
//         'Category ${i + 1}',
//         animatedValue,
//         _gradientColors[i % _gradientColors.length],
//         highlight: values[i] == maxValue,
//       );
//     });
//   }
//
//   Future<void> _pickDate() async {
//     DateTime now = DateTime.now();
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(now.year - 2),
//       lastDate: now,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: isDarkMode
//                 ? ColorScheme.dark(
//               primary: Colors.orange,
//               onPrimary: Colors.white,
//               surface: Colors.grey[900]!,
//               onSurface: Colors.white,
//             )
//                 : ColorScheme.light(
//               primary: Theme.of(context).colorScheme.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black87,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: isDarkMode
//                     ? Colors.white
//                     : Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedFilter = 'Date';
//         _startAnimations();
//       });
//     } else {
//       setState(() {
//         _selectedFilter = 'Lifetime';
//         _selectedDate = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final chartData = _getChartData();
//     final topCategory =
//     chartData.firstWhere((d) => d.highlight, orElse: () => chartData[0]);
//
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         gradient:
//         themeProvider.currentTheme == 'Pink'
//             ? HeaderColor.pinkGradient
//             : themeProvider.currentTheme == 'Green'
//             ? HeaderColor.greenGradient
//             : themeProvider.currentTheme == 'Blue'
//             ? HeaderColor.blueGradient
//             : themeProvider.currentTheme == 'Orange'
//             ? HeaderColor.orangeGradient
//             : HeaderColor.darkGradient,
//         // LinearGradient(
//         //   colors: [Colors.deepPurple.shade900, Colors.black87],
//         //   begin: Alignment.topLeft,
//         //   end: Alignment.bottomRight,
//         // ),
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black54,
//             blurRadius: 15,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Categories',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   shadows: [
//                     Shadow(
//                       color: Colors.black45,
//                       offset: Offset(1, 1),
//                       blurRadius: 2,
//                     ),
//                   ],
//                 ),
//               ),
//               TransactionTimeFilterDropdown(
//                 selectedOption: _selectedFilter,
//                 onChanged: (value) async {
//                   if (value == 'Date') {
//                     await _pickDate();
//                   } else {
//                     setState(() {
//                       _selectedFilter = value;
//                       _selectedDate = null;
//                       _startAnimations();
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           // Chart + Highest expense
//           SizedBox(
//             height: 250.h, // Slightly smaller
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 SfRadialGauge(
//                   axes: List.generate(chartData.length, (i) {
//                     final data = chartData[i];
//                     return RadialAxis(
//                       minimum: 0,
//                       maximum: 100,
//                       startAngle: 0,
//                       endAngle: 360,
//                       showTicks: false,
//                       showLabels: false,
//                       // ✅ Reduced radius for compact look
//                       radiusFactor: data.highlight ? 0.75 : 0.65 - (i * 0.08),
//                       axisLineStyle: AxisLineStyle(
//                         thickness: data.highlight ? 7.r : 7.r,
//                         color: Colors.white12,
//                         cornerStyle: CornerStyle.bothCurve,
//                       ),
//                       pointers: [
//                         RangePointer(
//                           value: data.value,
//                           width: data.highlight ? 12.r : 8.r,
//                           cornerStyle: CornerStyle.bothCurve,
//                           enableAnimation: true,
//                           animationDuration: 1000 + (i * 200),
//                           gradient: SweepGradient(
//                             colors: data.colors,
//                             stops: [0.0, 1.0],
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//                 // Center text
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '-\$4500',
//                       style: TextStyle(
//                         fontSize: 24.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                         shadows: [
//                           Shadow(
//                             color: Colors.black45,
//                             offset: Offset(2, 2),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     SlideTransition(
//                       position: _textOffsetAnimation,
//                       child: FadeTransition(
//                         opacity: _textOpacityAnimation,
//                         child: ScaleTransition(
//                           scale: _textScaleAnimation,
//                           child: Text(
//                             '🔥 Highest Expense: ${topCategory.category}',
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orangeAccent,
//                               shadows: [
//                                 Shadow(
//                                   color: Colors.black45,
//                                   offset: Offset(1, 1),
//                                   blurRadius: 2,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Indicator at bottom-left
//                 Positioned(
//                   bottom: 10.h,
//                   left: 10.w,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: List.generate(chartData.length, (i) {
//                       final data = chartData[i];
//                       return Padding(
//                         padding: EdgeInsets.symmetric(vertical: 2.h),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 12.w,
//                               height: 12.w,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: data.colors,
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                                 borderRadius: BorderRadius.circular(3.r),
//                               ),
//                             ),
//                             SizedBox(width: 6.w),
//                             Text(
//                               data.category,
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: Colors.white70,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ChartData {
//   _ChartData(this.category, this.value, this.colors, {this.highlight = false});
//   final String category;
//   final double value;
//   final List<Color> colors;
//   final bool highlight;
// }






















// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:intl/intl.dart';
// import '../../component/time_filter.dart';
//
// class RadialChartWidget extends StatefulWidget {
//   final bool active;
//   const RadialChartWidget({super.key, this.active = false});
//
//   @override
//   State<RadialChartWidget> createState() => _RadialChartWidgetState();
// }
//
// class _RadialChartWidgetState extends State<RadialChartWidget>
//     with SingleTickerProviderStateMixin {
//   String _selectedFilter = 'Lifetime';
//   DateTime? _selectedDate;
//
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//
//   final Map<String, List<double>> _chartData = {
//     'Lifetime': [70, 55, 30, 80],
//     'Weekly': [35, 63, 25, 40],
//     'Monthly': [45, 30, 69, 25],
//     'Yearly': [88, 60, 15, 25],
//   };
//
//   final Map<String, List<double>> _dateChartData = {
//     '2025-09-01': [40, 20, 70, 50],
//     '2025-09-02': [55, 45, 30, 80],
//     '2025-09-03': [65, 25, 50, 40],
//   };
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
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.active) _startAnimation();
//     });
//   }
//
//   void _startAnimation() {
//     _controller.forward(from: 0);
//   }
//
//   List<_ChartData> _getChartData() {
//     List<double> values = [];
//
//     if (_selectedFilter == 'Date' && _selectedDate != null) {
//       final key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
//       values = _dateChartData[key] ?? [0, 0, 0, 0];
//     } else {
//       values = _chartData[_selectedFilter]!;
//     }
//
//     double maxValue = values.reduce((a, b) => a > b ? a : b);
//
//     return List.generate(values.length, (i) {
//       double animatedValue = values[i] * _animation.value;
//       if (animatedValue < 0.1) animatedValue = 0.1;
//
//       return _ChartData(
//         'Category ${i + 1}',
//         animatedValue,
//         _gradientColors[i % _gradientColors.length],
//         highlight: values[i] == maxValue,
//       );
//     });
//   }
//
//   Future<void> _pickDate() async {
//     DateTime now = DateTime.now();
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(now.year - 2),
//       lastDate: now,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: isDarkMode
//                 ? ColorScheme.dark(
//               primary: Colors.orange,
//               onPrimary: Colors.white,
//               surface: Colors.grey[900]!,
//               onSurface: Colors.white,
//             )
//                 : ColorScheme.light(
//               primary: Theme.of(context).colorScheme.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black87,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: isDarkMode
//                     ? Colors.white
//                     : Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedFilter = 'Date';
//         _startAnimation();
//       });
//     } else {
//       setState(() {
//         _selectedFilter = 'Lifetime';
//         _selectedDate = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chartData = _getChartData();
//     final topCategory =
//     chartData.firstWhere((d) => d.highlight, orElse: () => chartData[0]);
//
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.black87, Colors.deepPurple.shade900],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.deepPurple.withOpacity(0.5),
//             blurRadius: 15,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Categories',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   shadows: [
//                     Shadow(
//                       color: Colors.black45,
//                       offset: Offset(1, 1),
//                       blurRadius: 2,
//                     ),
//                   ],
//                 ),
//               ),
//               TransactionTimeFilterDropdown(
//                 selectedOption: _selectedFilter,
//                 onChanged: (value) async {
//                   if (value == 'Date') {
//                     await _pickDate();
//                   } else {
//                     setState(() {
//                       _selectedFilter = value;
//                       _selectedDate = null;
//                       _startAnimation();
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           SizedBox(
//             height: 280.h,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 SfRadialGauge(
//                   axes: List.generate(chartData.length, (i) {
//                     final data = chartData[i];
//                     return RadialAxis(
//                       minimum: 0,
//                       maximum: 100,
//                       startAngle: 0,
//                       endAngle: 360,
//                       showTicks: false,
//                       showLabels: false,
//                       radiusFactor: data.highlight ? 1.0 : 0.9 - (i * 0.12),
//                       axisLineStyle: AxisLineStyle(
//                         thickness: data.highlight ? 14.r : 10.r,
//                         color: Colors.white12,
//                         cornerStyle: CornerStyle.bothCurve,
//                       ),
//                       pointers: [
//                         RangePointer(
//                           value: data.value,
//                           width: data.highlight ? 14.r : 10.r,
//                           cornerStyle: CornerStyle.bothCurve,
//                           enableAnimation: true,
//                           animationDuration: 1000 + (i * 200),
//                           gradient: SweepGradient(
//                             colors: data.colors,
//                             stops: [0.0, 1.0],
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '-\$4500',
//                       style: TextStyle(
//                         fontSize: 24.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                         shadows: [
//                           Shadow(
//                             color: Colors.black45,
//                             offset: Offset(2, 2),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 6.h),
//                     Text(
//                       'Highest Expense: ${topCategory.category}',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.orangeAccent,
//                         shadows: [
//                           Shadow(
//                             color: Colors.black45,
//                             offset: Offset(1, 1),
//                             blurRadius: 2,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ChartData {
//   _ChartData(this.category, this.value, this.colors, {this.highlight = false});
//   final String category;
//   final double value;
//   final List<Color> colors;
//   final bool highlight;
// }




























// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:intl/intl.dart';
// import '../../component/time_filter.dart';
//
// class RadialChartWidget extends StatefulWidget {
//   final bool active;
//   const RadialChartWidget({super.key, this.active = false});
//
//   @override
//   State<RadialChartWidget> createState() => _RadialChartWidgetState();
// }
//
// class _RadialChartWidgetState extends State<RadialChartWidget>
//     with SingleTickerProviderStateMixin {
//   String _selectedFilter = 'Lifetime';
//   DateTime? _selectedDate;
//
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//
//   /// Dummy chart data
//   final Map<String, List<double>> _chartData = {
//     'Lifetime': [70, 55, 30, 80],
//     'Weekly': [35, 63, 25, 40],
//     'Monthly': [45, 30, 69, 25],
//     'Yearly': [88, 60, 15, 25],
//   };
//
//   /// Dummy date-wise data
//   final Map<String, List<double>> _dateChartData = {
//     '2025-09-01': [40, 20, 70, 50],
//     '2025-09-02': [55, 45, 30, 80],
//     '2025-09-03': [65, 25, 50, 40],
//   };
//
//   final List<Color> _colors = [
//     Colors.blue,
//     Colors.green,
//     Colors.purple,
//     Colors.pink,
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutCubic,
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.active) _startAnimation();
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant RadialChartWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.active && !oldWidget.active) {
//       _startAnimation();
//     }
//   }
//
//   void _startAnimation() {
//     _controller.forward(from: 0);
//   }
//
//   List<_ChartData> _getChartData() {
//     List<double> values = [];
//
//     if (_selectedFilter == 'Date' && _selectedDate != null) {
//       final key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
//       values = _dateChartData[key] ?? [0, 0, 0, 0];
//     } else {
//       values = _chartData[_selectedFilter]!;
//     }
//
//     double maxValue = values.reduce((a, b) => a > b ? a : b);
//
//     return List.generate(values.length, (i) {
//       double animatedValue = values[i] * _animation.value;
//       if (animatedValue < 0.1) animatedValue = 0.1;
//
//       return _ChartData(
//         'Category ${i + 1}',
//         animatedValue,
//         _colors[i % _colors.length].withOpacity(values[i] == maxValue ? 1.0 : 0.7),
//         highlight: values[i] == maxValue,
//       );
//     });
//   }
//
//   /// ✅ Custom Date Picker
//   Future<void> _pickDate() async {
//     DateTime now = DateTime.now();
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(now.year - 2),
//       lastDate: now,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: isDarkMode
//                 ? ColorScheme.dark(
//               primary: Colors.orange,
//               onPrimary: Colors.white,
//               surface: Colors.grey[900]!,
//               onSurface: Colors.white,
//             )
//                 : ColorScheme.light(
//               primary: Theme.of(context).colorScheme.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black87,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: isDarkMode
//                     ? Colors.white
//                     : Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedFilter = 'Date';
//         _startAnimation();
//       });
//     } else {
//       setState(() {
//         _selectedFilter = 'Lifetime';
//         _selectedDate = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, _) {
//         final chartData = _getChartData();
//         final topCategory =
//         chartData.firstWhere((d) => d.highlight, orElse: () => chartData[0]);
//
//         return Container(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
//           decoration: BoxDecoration(
//             color: isDarkMode
//                 ? Theme.of(context).colorScheme.primary
//                 : Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.15),
//                 spreadRadius: 1,
//                 blurRadius: 12,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 height: 280.h,
//                 padding: EdgeInsets.all(8.w),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary.withOpacity(.15),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Categories',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             color: isDarkMode ? Colors.white : Colors.black87,
//                           ),
//                         ),
//                         TransactionTimeFilterDropdown(
//                           selectedOption: _selectedFilter,
//                           onChanged: (value) async {
//                             if (value == 'Date') {
//                               await _pickDate();
//                             } else {
//                               setState(() {
//                                 _selectedFilter = value;
//                                 _selectedDate = null;
//                                 _startAnimation();
//                               });
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12.h),
//                     Expanded(
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           SfRadialGauge(
//                             axes: List.generate(chartData.length, (i) {
//                               return RadialAxis(
//                                 minimum: 0,
//                                 maximum: 100,
//                                 startAngle: 0,
//                                 endAngle: 360,
//                                 showTicks: false,
//                                 showLabels: false,
//                                 radiusFactor: chartData[i].highlight
//                                     ? 1.0
//                                     : 0.9 - (i * 0.13),
//                                 axisLineStyle: AxisLineStyle(
//                                   thickness: chartData[i].highlight ? 12.r : 8.r,
//                                   color: isDarkMode
//                                       ? Colors.white12
//                                       : Colors.grey[300],
//                                   cornerStyle: CornerStyle.bothCurve,
//                                 ),
//                                 pointers: [
//                                   RangePointer(
//                                     value: chartData[i].value,
//                                     cornerStyle: CornerStyle.bothCurve,
//                                     width: chartData[i].highlight ? 12.r : 8.r,
//                                     color: chartData[i].color,
//                                     enableAnimation: true,
//                                     animationDuration: 1000 + (i * 200),
//                                   )
//                                 ],
//                               );
//                             }),
//                           ),
//                           Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   '-\$4500',
//                                   style: TextStyle(
//                                     fontSize: 22.sp,
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color(0xFFE57373),
//                                   ),
//                                 ),
//                                 SizedBox(height: 6.h),
//                                 Text(
//                                   'Highest Expense: ${topCategory.category}',
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.orangeAccent,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
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
//   _ChartData(this.category, this.value, this.color, {this.highlight = false});
//   final String category;
//   final double value;
//   final Color color;
//   final bool highlight;
// }


































//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:intl/intl.dart';
// import '../../component/time_filter.dart';
// import '../../theme/header_Color.dart';
// import '../../theme/theme_notifier.dart';
//
// class RadialChartWidget extends StatefulWidget {
//   final bool active;
//   const RadialChartWidget({super.key, this.active = false});
//
//   @override
//   State<RadialChartWidget> createState() => _RadialChartWidgetState();
// }
//
// class _RadialChartWidgetState extends State<RadialChartWidget>
//     with SingleTickerProviderStateMixin {
//   String _selectedFilter = 'Lifetime';
//   DateTime? _selectedDate;
//
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//
//   /// Dummy chart data
//   final Map<String, List<double>> _chartData = {
//     'Lifetime': [70, 55, 30, 80],
//     'Weekly': [35, 63, 25, 40],
//     'Monthly': [45, 30, 69, 25],
//     'Yearly': [88, 60, 15, 25],
//   };
//
//   /// Dummy date-wise data
//   final Map<String, List<double>> _dateChartData = {
//     '2025-09-01': [40, 20, 70, 50],
//     '2025-09-02': [55, 45, 30, 80],
//     '2025-09-03': [65, 25, 50, 40],
//   };
//
//   final List<Color> _colors = [
//     Colors.blue,
//     Colors.green,
//     Colors.purple,
//     Colors.pink,
//   ];
//   // final List<List<Color>> _gradientColors = [
//   //   [Colors.blueAccent, Colors.lightBlueAccent],
//   //   [Colors.greenAccent, Colors.tealAccent],
//   //   [Colors.purpleAccent, Colors.deepPurpleAccent],
//   //   [Colors.pinkAccent, Colors.redAccent],
//   // ];
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutCubic,
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.active) _startAnimation();
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant RadialChartWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.active && !oldWidget.active) {
//       _startAnimation();
//     }
//   }
//
//   void _startAnimation() {
//     _controller.forward(from: 0);
//   }
//
//   List<_ChartData> _getChartData() {
//     List<double> values = [];
//
//     if (_selectedFilter == 'Date' && _selectedDate != null) {
//       final key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
//       values = _dateChartData[key] ?? [0, 0, 0, 0];
//     } else {
//       values = _chartData[_selectedFilter]!;
//     }
//
//     return List.generate(values.length, (i) {
//       double animatedValue = values[i] * _animation.value;
//       if (animatedValue < 0.1) animatedValue = 0.1;
//       return _ChartData(
//         'Category ${i + 1}',
//         animatedValue,
//         _colors[i % _colors.length],
//       );
//     });
//   }
//
//   /// ✅ Custom Date Picker
//   Future<void> _pickDate() async {
//     DateTime now = DateTime.now();
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(now.year - 2),
//       lastDate: now, // ✅ Future date disable
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: isDarkMode
//                 ? ColorScheme.dark(
//               primary: Colors.orange, // ✅ current date highlight
//               onPrimary: Colors.white, // ✅ text color on highlighted date
//               surface: Colors.grey[900]!,
//               onSurface: Colors.white, // ✅ default text
//             )
//                 : ColorScheme.light(
//               primary: Theme.of(context).colorScheme.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black87,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: isDarkMode
//                     ? Colors.white // ✅ OK/Cancel button text white in dark mode
//                     : Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedFilter = 'Date';
//         _startAnimation();
//       });
//     } else {
//       // Cancel karne par Lifetime default
//       setState(() {
//         _selectedFilter = 'Lifetime';
//         _selectedDate = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, _) {
//         final chartData = _getChartData();
//
//         return Container(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           decoration: BoxDecoration(
//             gradient: themeProvider.currentTheme == 'Pink'
//                 ? HeaderColor.pinkGradient
//                 : themeProvider.currentTheme == 'Green'
//                 ? HeaderColor.greenGradient
//                 : themeProvider.currentTheme == 'Blue'
//                 ? HeaderColor.blueGradient
//                 : themeProvider.currentTheme == 'Orange'
//                 ? HeaderColor.orangeGradient
//                 : HeaderColor.darkGradient,
//             // color: isDarkMode
//             //     ? Theme.of(context).colorScheme.primary
//             //     : Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 1,
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 height: 260.h,
//                 padding: EdgeInsets.all(6.w),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primary.withOpacity(.2),
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Categories',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             color: isDarkMode ? Colors.white : Colors.black87,
//                           ),
//                         ),
//                         TransactionTimeFilterDropdown(
//                           selectedOption: _selectedFilter,
//                           onChanged: (value) async {
//                             if (value == 'Date') {
//                               await _pickDate(); // ✅ ab custom function call
//                             } else {
//                               setState(() {
//                                 _selectedFilter = value;
//                                 _selectedDate = null;
//                                 _startAnimation();
//                               });
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.h),
//                     Expanded(
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           SfRadialGauge(
//                             axes: List.generate(chartData.length, (i) {
//                               return RadialAxis(
//                                 minimum: 0,
//                                 maximum: 100,
//                                 startAngle: 0,
//                                 endAngle: 360,
//                                 showTicks: false,
//                                 showLabels: false,
//                                 radiusFactor: 0.9 - (i * 0.13),
//                                 axisLineStyle: AxisLineStyle(
//                                   thickness: 7.r,
//                                   color: isDarkMode
//                                       ? Colors.white12
//                                       : Colors.white30,
//                                   cornerStyle: CornerStyle.bothCurve,
//                                 ),
//                                 pointers: [
//                                   RangePointer(
//                                     value: chartData[i].value,
//                                     cornerStyle: CornerStyle.bothCurve,
//                                     width: 8.r,
//                                     color: chartData[i].color,
//                                     enableAnimation: true,
//                                     animationDuration: 900,
//                                   )
//                                 ],
//                               );
//                             }),
//                           ),
//                           Center(
//                             // child: Text(
//                             //   '-\$4500',
//                             //   style: TextStyle(
//                             //     fontSize: 20.sp,
//                             //     fontWeight: FontWeight.bold,
//                             //     color: const Color(0xFFE57373),
//                             //   ),
//                             // ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 5.h),
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
//   _ChartData(this.category, this.value, this.color);
//   final String category;
//   final double value;
//   final Color color;
// }

