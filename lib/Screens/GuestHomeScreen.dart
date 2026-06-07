// guest_home_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Api_Services/notification_storage.dart';
import '../Widgets/guest_home_screen_Widgets/GuestBalanceCard.dart';
import '../Widgets/home_Screen_Widegets/Income_Help_Banner.dart';
import '../Widgets/home_Screen_Widegets/home_header.dart';
import '../component/transaction_list.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen>
    with SingleTickerProviderStateMixin {
  Offset? _buttonOffset;
  String selectedFilter = "Lifetime";

  List<Map<String, dynamic>> notifications = [];



  final GlobalKey _filterIconKey = GlobalKey();
  void _showFilterDrawer() {
    final options = ['Lifetime', 'Weekly', 'Monthly', 'Yearly'];

    final RenderBox renderBox =
    _filterIconKey.currentContext!.findRenderObject() as RenderBox;

    final Offset position = renderBox.localToGlobal(Offset.zero);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Filter",
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned(
              top: position.dy + renderBox.size.height + 8,
              right: 16, // right align with icon feel
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((option) {
                      return _buildFilterOption(option);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    loadNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _buttonOffset = Offset(size.width - 80, size.height - 150);
      });
    });
  }


  Future<void> loadNotifications() async {
    notifications = await NotificationStorage.getNotifications();
    setState(() {});
  }




  void _showLoginSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("please_login_to_continue".tr()),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_buttonOffset == null) return const SizedBox();

    final mediaHeight = MediaQuery.of(context).size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: mediaHeight * 0.3,
                    child:  HomeHeader(notifications: notifications ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 30,
                      top: mediaHeight * 0.22,
                    ),
                    child: const GuestBalanceCard(),
                  ),
                  const IncomeHelpBanner(),
                ],
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: mediaHeight * 0.465),
            child: SingleChildScrollView(
              child: Container(
                //   color: isDarkMode
                //       ?Colors.blue
                // //  Color(0xFFD44D5C)
                //       :Theme.of(context).scaffoldBackgroundColor,
                child: TransactionList(
                  selectedFilter: selectedFilter,
                  onFilterChanged: (value) {
                    setState(() {
                      selectedFilter = value;
                    });
                  },
                ),
              ),
            ),
          ),

          // Floating Button (same position, same UI)
          Positioned(
            left: _buttonOffset!.dx,
            top: _buttonOffset!.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: isDarkMode
                    ? Color(0xFFD44D5C)
                    : Theme.of(context).colorScheme.primary,              ),
              childWhenDragging: Container(
                color: isDarkMode
                    ? Color(0xFFD44D5C)
                    : Theme.of(context).colorScheme.primary,
              ),
              onDragEnd: (details) {
                setState(() {
                  _buttonOffset = details.offset;
                });
              },
              child: FloatingActionButton(
                backgroundColor: isDarkMode
                    ? Color(0xFFD44D5C)
                    : Theme.of(context).colorScheme.primary,

                onPressed: _showLoginSnack,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFilterOption(String option) {
    final isSelected = selectedFilter == option;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = option;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Text(option),
          ],
        ),
      ),
    );
  }

}
