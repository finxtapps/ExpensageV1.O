import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Api_Models/Bar_graph_model.dart';
import '../../Api_Services/Bar_graph_services.dart';
import '../../component/bar_Graph_time_filter.dart';
import '../../providerListner/DashboardProvider.dart';
import '../../shared_prefrence/SharedPrefrenceMethods.dart';
import '../../providerListner/currency_notifier.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key}) : super(key: key);

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  String selectedFilter = 'Monthly';

  late TooltipBehavior _tooltipBehavior;
  BarGraphResponse? barGraphResponse;
  bool isLoading = true;

  final SharedPreferenceMethods _pref = SharedPreferenceMethods();

  /// ✅ Fixed 12-month order (SHORT FORM)
  static const List<String> _monthOrder = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  // void initState() {
  //   super.initState();
  //
  //   _tooltipBehavior = TooltipBehavior(
  //     enable: true,
  //     header: '',
  //     canShowMarker: false,
  //     textStyle: const TextStyle(color: Colors.white),
  //   );
  //
  //   _fetchBarGraphData();
  // }

  @override
  void initState() {
    super.initState();

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      textStyle: const TextStyle(color: Colors.white),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchBarGraph();
    });
  }

  /// 🌐 API CALL
  Future<void> _fetchBarGraphData() async {
    try {
      final service = BarGraphService();
      final response = await service.getBarGraphData();

      if (!mounted) return;
      setState(() {
        barGraphResponse = response;
      });
    } catch (e) {
      debugPrint('❌ BarGraph Error: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  /// 📊 Chart Data Mapper
  List<_ChartData> _getChartData() {
    if (barGraphResponse == null) return [];

    final data = barGraphResponse!.data;

    switch (selectedFilter) {
      case 'Weekly':
      case 'Week':
        return data.weeklyExpenses.entries
            .map((e) => _ChartData(e.key, e.value.toDouble()))
            .toList();

    /// ✅ MONTHLY → SHORT MONTH + FULL 12
      case 'Monthly':
      case 'Month':
        final Map<String, double> apiMonthData = {};

        data.monthlyExpenses.forEach((key, value) {
          final int monthIndex = _parseMonthIndex(key);
          final String shortMonth =
          DateFormat('MMM').format(DateTime(2024, monthIndex));

          apiMonthData[shortMonth] = value.toDouble();
        });

        return _monthOrder
            .map((m) => _ChartData(m, apiMonthData[m] ?? 0))
            .toList();

      case 'Yearly':
      case 'Year':
      case 'Lifetime':
        return data.yearlyTotal.entries
            .map((e) => _ChartData(e.key, e.value.toDouble()))
            .toList();

      default:
        return [];
    }
  }

  /// 🔢 Max Y Axis
  double _getMaxY(List<_ChartData> data) {
    if (data.isEmpty) return 1000;
    final maxVal =
    data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    return maxVal + (maxVal * 0.2);
  }

  /// 🧠 Month string → index converter
  int _parseMonthIndex(String month) {
    final m = month.toLowerCase();

    const map = {
      'jan': 1,
      'january': 1,
      'feb': 2,
      'february': 2,
      'mar': 3,
      'march': 3,
      'apr': 4,
      'april': 4,
      'may': 5,
      'jun': 6,
      'june': 6,
      'jul': 7,
      'july': 7,
      'aug': 8,
      'august': 8,
      'sep': 9,
      'september': 9,
      'oct': 10,
      'october': 10,
      'nov': 11,
      'november': 11,
      'dec': 12,
      'december': 12,
    };

    return map[m] ?? 1;
  }


  @override
  Widget build(BuildContext context) {

    final dashboardProvider =
    context.watch<DashboardProvider>();

    final barGraphResponse =
        dashboardProvider.barGraphResponse;

    final isLoading =
        dashboardProvider.isLoading;

    this.barGraphResponse = barGraphResponse;

    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final chartData = _getChartData();

    final maxY = _getMaxY(chartData);





    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final chartData = _getChartData();
    // final maxY = _getMaxY(chartData);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chartData.isEmpty) {
      return SizedBox(
        height: 250.h,
        child: const Center(child: Text('No data available')),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).colorScheme.primary.withOpacity(.2),
        ),
        child: Column(
          children: [
            /// HEADER
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
                CustomChartTimeFilter(
                  selectedOption: selectedFilter,
                  onChanged: (value) {
                    setState(() => selectedFilter = value);
                  },
                ),
              ],
            ),

            SizedBox(height: 10.h),

            /// 📈 CHART
            SizedBox(
              height: 250.h,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                tooltipBehavior: _tooltipBehavior,

                onTooltipRender: (TooltipArgs args) {
                  final int index = args.pointIndex!.toInt();
                  final currency = context.read<CurrencyNotifier>().currency;

                  final double yValue =
                      (args.dataPoints?[index].y as num?)?.toDouble() ?? 0.0;

                  args.text = '$currency ${yValue.toStringAsFixed(0)}';
                },



                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),

                  /// 🔥 FORCE ALL 12 MONTHS
                  interval: 1,
                  arrangeByIndex: true,
                  labelPlacement: LabelPlacement.onTicks,

                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black54,
                    fontSize: 10.sp,
                  ),
                ),




                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorGridLines: const MajorGridLines(width: 0.3),
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black54,
                    fontSize: 10.sp,
                  ),
                  axisLabelFormatter: (details) {
                    final currency =
                        context.read<CurrencyNotifier>().currency;
                    return ChartAxisLabel(
                      '$currency ${details.text}',
                      details.textStyle,
                    );
                  },
                  maximum: maxY,
                  interval: (maxY / 5).clamp(1, double.infinity),
                ),

                series: [
                  ColumnSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.amount,
                    borderRadius: BorderRadius.circular(6.r),
                    color:  Color(0xFFD44D5C),
                    width: 0.6,
                    animationDuration: 1200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 📦 Chart Model
class _ChartData {
  final String day;
  final double amount;

  _ChartData(this.day, this.amount);
}

