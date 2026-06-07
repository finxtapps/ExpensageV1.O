import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../component/bar_Graph_time_filter.dart';
import '../../component/guest_time_filter.dart';

class GuestBarChartWidget extends StatefulWidget {
  const GuestBarChartWidget({super.key});

  @override
  State<GuestBarChartWidget> createState() => _GuestBarChartWidgetState();
}

class _GuestBarChartWidgetState extends State<GuestBarChartWidget> {
  /// ✅ Dropdown-safe default
  String selectedFilter = 'Lifetime';

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      format: 'point.x : ₹point.y',
      canShowMarker: false,
      textStyle: const TextStyle(color: Colors.white),
    );
  }

  /// 🔥 Chart Data Generator (FILTER SAFE)
  List<_ChartData> _getChartData() {
    DateTime now = DateTime.now();

    switch (selectedFilter) {
      case 'Lifetime':
        return [
          _ChartData((now.year - 1).toString(), 45000),
          _ChartData(now.year.toString(), 52000),
        ];

      case 'Monthly':
        return List.generate(30, (index) {
          DateTime date = now.subtract(Duration(days: 29 - index));
          return _ChartData(
            DateFormat('dd MMM').format(date),
            1000 + (index * 150),
          );
        });

      case 'Yearly':
        return List.generate(now.month, (index) {
          return _ChartData(
            DateFormat('MMM').format(DateTime(now.year, index + 1)),
            3000 + (index * 800),
          );
        });

    /// ✅ FALLBACK (never blank chart)
      default:
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final values = [1500, 2000, 1200, 2500, 1800, 3200, 3600];

        return List.generate(
          days.length,
              (i) => _ChartData(days[i], values[i].toDouble()),
        );

    }
  }

  double _getMaxY(List<_ChartData> data) {
    if (data.isEmpty) return 1000;
    final maxVal =
    data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    return maxVal + (maxVal * 0.2);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chartData = _getChartData();
    final maxY = _getMaxY(chartData);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isDarkMode
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context)
              .colorScheme
              .primary
              .withValues(alpha: .2),
        ),
        child: Column(
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'how_much_you_spend'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                GuestTimeFilter(
                  selectedOption: selectedFilter,
                  onChanged: (value) {
                    setState(() => selectedFilter = value);
                  },
                ),
              ],
            ),

            SizedBox(height: 10.h),

            /// Chart
            SizedBox(
              height: 250.h,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelRotation:
                  selectedFilter == 'Monthly' ? -45 : 0,
                  labelStyle: TextStyle(
                    color:
                    isDarkMode ? Colors.white : Colors.black54,
                    fontSize: 10.sp,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorGridLines:
                  const MajorGridLines(width: 0.3),
                  labelFormat: '₹ {value}',
                  maximum: maxY,
                  interval: (maxY / 5).clamp(1, double.infinity),
                ),
                series: [
                  ColumnSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.amount,
                    borderRadius: BorderRadius.circular(6.r),
                    color: const Color(0xFFD44D5C),
                    width: 0.6,
                    animationDuration: 1200,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String day;
  final double amount;
  _ChartData(this.day, this.amount);
}





























// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';
// import '../../component/bar_Graph_time_filter.dart';
// import '../../component/time_filter.dart';
//
// class GuestBarChartWidget extends StatefulWidget {
//   const GuestBarChartWidget({super.key});
//
//   @override
//   State<GuestBarChartWidget> createState() => _GuestBarChartWidgetState();
// }
//
// class _GuestBarChartWidgetState extends State<GuestBarChartWidget> {
//   String selectedFilter = 'Weekly';
//   DateTime? selectedDate;
//
//   late TooltipBehavior _tooltipBehavior;
//
//   @override
//   void initState() {
//     super.initState();
//     _tooltipBehavior = TooltipBehavior(
//       enable: true,
//       header: '',
//       format: 'point.x : \$point.y',
//       canShowMarker: false,
//       textStyle: const TextStyle(color: Colors.white),
//     );
//   }
//
//   /// 🔥 Chart Data Generator
//   List<_ChartData> _getChartData() {
//     DateTime now = DateTime.now();
//
//     if (selectedFilter == 'Lifetime') {
//       int currentYear = now.year;
//       int previousYear = now.year - 1;
//
//       return [
//         _ChartData(previousYear.toString(), 45000),
//         _ChartData(currentYear.toString(), 52000),
//       ];
//     }
//
//     if (selectedFilter == 'Monthly') {
//       return List.generate(30, (index) {
//         DateTime date = now.subtract(Duration(days: 29 - index));
//         String day = DateFormat('dd MMM').format(date);
//         double value = (1000 + (index * 150)).toDouble();
//         return _ChartData(day, value);
//       });
//     }
//
//     if (selectedFilter == 'Yearly') {
//       return List.generate(now.month, (index) {
//         String month = DateFormat('MMM').format(DateTime(now.year, index + 1));
//         double value = (3000 + (index * 800)).toDouble();
//         return _ChartData(month, value);
//       });
//     }
//
//     if (selectedFilter == 'Date' && selectedDate != null) {
//       return List.generate(6, (index) {
//         String slot = "${(index + 1) * 4}h"; // 4h slots
//         double value = (500 + (index * 200)).toDouble();
//         return _ChartData(slot, value);
//       });
//     }
//
//     // Default → Weekly
//     final values = [1500, 2000, 1200, 2500, 1800, 3200, 3600];
//     final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//
//     return List.generate(values.length, (index) {
//       return _ChartData(days[index], values[index].toDouble());
//     });
//   }
//
//   /// 🔥 Calculate max Y dynamically
//   double _getMaxY(List<_ChartData> data) {
//     if (data.isEmpty) return 1000; // fallback if no data
//     double maxVal = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
//     return maxVal + (maxVal * 0.2); // 20% extra space
//   }
//
//   /// 🔥 Date picker for "Date" filter
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
//         selectedDate = picked;
//         selectedFilter = 'Date';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final chartData = _getChartData();
//     final maxY = _getMaxY(chartData);
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       decoration: BoxDecoration(
//         color: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Container(
//         padding: EdgeInsets.all(6.w),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12.r),
//           color: isDarkMode
//               ? Theme.of(context).colorScheme.primary
//               : Theme.of(context).colorScheme.primary.withValues(alpha: .2),
//         ),
//         child: Column(
//           children: [
//             /// Header Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'how_much_you_spend'.tr(),
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w600,
//                     color: isDarkMode ? Colors.white : Colors.black87,
//                   ),
//                 ),
//
//                 BarGraphTimeFilter(
//                   selectedOption: selectedFilter,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedFilter = value;
//                     });
//                   },
//                 ),
//
//
//                 // TransactionTimeFilterDropdown(
//                 //   selectedOption: selectedFilter,
//                 //   onChanged: (newValue) async {
//                 //     if (newValue == 'Date') {
//                 //       await _pickDate();
//                 //     } else {
//                 //       setState(() {
//                 //         selectedDate = null;
//                 //         selectedFilter = newValue;
//                 //       });
//                 //     }
//                 //   },
//                 // ),
//               ],
//             ),
//             SizedBox(height: 10.h),
//
//             /// Chart
//             SizedBox(
//               height: 250.h,
//               child: SfCartesianChart(
//                 plotAreaBorderWidth: 0,
//                 tooltipBehavior: _tooltipBehavior,
//                 primaryXAxis: CategoryAxis(
//                   majorGridLines: const MajorGridLines(width: 0),
//                   labelRotation:
//                   (selectedFilter == 'Monthly' || selectedFilter == 'Date')
//                       ? -45
//                       : 0,
//                   labelStyle: TextStyle(
//                     color: isDarkMode ? Colors.white : Colors.black54,
//                     fontSize: 10.sp,
//                   ),
//                 ),
//                 primaryYAxis: NumericAxis(
//                   axisLine: const AxisLine(width: 0),
//                   majorGridLines: const MajorGridLines(width: 0.3),
//                   labelStyle: TextStyle(
//                     color: isDarkMode ? Colors.white : Colors.black54,
//                     fontSize: 10.sp,
//                   ),
//                   labelFormat: '₹ {value}',
//                   interval:
//                   (maxY > 0) ? (maxY / 5).clamp(1, double.infinity) : 1,
//                   maximum: (maxY > 0) ? maxY : 1000,
//                 ),
//                 series: <CartesianSeries<_ChartData, String>>[
//                   ColumnSeries<_ChartData, String>(
//                     dataSource: chartData,
//                     xValueMapper: (_ChartData data, _) => data.day,
//                     yValueMapper: (_ChartData data, _) => data.amount,
//                     borderRadius: BorderRadius.circular(6.r),
//                     color: const Color(0xFFD44D5C),
//                     width: 0.6,
//                     animationDuration: 1200, // ✅ enable animation here
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ChartData {
//   final String day;
//   final double amount;
//   _ChartData(this.day, this.amount);
// }
