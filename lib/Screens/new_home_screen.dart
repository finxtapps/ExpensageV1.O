// new_home_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Api_Services/getBudgetStream.dart';
import '../Api_Services/monthlyBudgetServices.dart';
import '../Api_Services/notification_storage.dart';
import '../Widgets/home_Screen_Widegets/Income_Help_Banner.dart';
import '../Widgets/home_Screen_Widegets/balance_card.dart';
import '../Widgets/home_Screen_Widegets/home_header.dart';
import '../component/transaction_list.dart';
import '../providerListner/addTransactionProvider.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}
class _NewHomeScreenState extends State<NewHomeScreen>
    with SingleTickerProviderStateMixin {

  final GlobalKey _filterIconKey = GlobalKey();

  String selectedFilter = "Lifetime";
  List<Map<String, dynamic>> notifications = [];

  late AnimationController _controller;
  final ValueNotifier<int> _budgetNotifier = ValueNotifier<int>(0);

  Offset? _buttonOffset; // will calculate in initState
  late BudgetStreamService _budgetStreamService;
  bool _budgetReady = false;
  @override
  void initState() {
    super.initState();
    loadNotifications();
    _initBudgetService();
    _controller =
    AnimationController(duration: const Duration(seconds: 4), vsync: this)
      ..repeat();

    // Delay offset calculation until first frame (need MediaQuery)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _buttonOffset = Offset(
          size.width - 80, // 80 px from left → roughly button width from right
          size.height - 150, // 150 px from top → roughly bottom padding
        );
      });
    });
  }



  Future<void> loadNotifications() async {
    notifications = await NotificationStorage.getNotifications();
    setState(() {});
  }


  @override
  void dispose() {
    _controller.dispose();
    _budgetNotifier.dispose();
    super.dispose();
  }

  late final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  Future<void> _initBudgetService() async {
    final token = await SharedPreferenceMethods().getToken();
    final userId = await SharedPreferenceMethods().getUserId();

    _budgetStreamService = BudgetStreamService(
      token: token!,
      userId: userId!,
    );
    bool _isLoggedIn = false;

    Future<void> _initBudgetService() async {
      final prefs = SharedPreferenceMethods();
      final token = await prefs.getToken();
      final userId = await prefs.getUserId();

      if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
        debugPrint("🟡 USER NOT LOGGED IN → Guest Mode");

        setState(() {
          _isLoggedIn = false;
          _budgetReady = true;
        });
        return;
      }

      _budgetStreamService = BudgetStreamService(
        token: token,
        userId: userId,
      );

      setState(() {
        _isLoggedIn = true;
        _budgetReady = true;
      });
    }

    setState(() {
      _budgetReady = true;
    });
  }

  void _showFilterDrawer() {
    final options = ['Lifetime'.tr(), 'Weekly'.tr(), 'Monthly'.tr(), 'Yearly'.tr()];

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

  void _showBudgetForm() {
    final TextEditingController _controller = TextEditingController();
    bool _isLoading = false;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("set_monthly_budget".tr()),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration:  InputDecoration(hintText: "enter_amount".tr()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              print("hhhhhhhhhhhhhhh Cancel clicked");
              Navigator.of(ctx).pop();
            },
            child:  Text("cancel".tr(),
              style: TextStyle(color: isDarkMode? Colors.white:Theme.of(context).primaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              final int? value = int.tryParse(_controller.text);
              print("hhhhhhhhhhhhhhh Entered value: ${_controller.text}");

              if (value == null) {
                print("hhhhhhhhhhhhhhh Invalid number entered");
                return;
              }

              setState(() => _isLoading = true);
              print("hhhhhhhhhhhhhhh Loading started");

              try {
                /// 🔐 Get token & userId
                final prefs = SharedPreferenceMethods();

                final token = await prefs.getToken() ?? "";
                final userId = await prefs.getUserId() ?? "";

                print("hhhhhhhhhhhhhhh Token: $token");
                print("hhhhhhhhhhhhhhh UserId: $userId");

                if (token.isEmpty || userId.isEmpty) {
                  print("hhhhhhhhhhhhhhh User not logged in");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("user_not_logged_in".tr()),
                      backgroundColor: Colors.red,
                    ),
                  );

                  setState(() => _isLoading = false);
                  return;
                }

                /// 📤 POST API CALL
                print("hhhhhhhhhhhhhhh Calling updateBudget API");

                final budgetService = BudgetService(token: token);

                final budget = await budgetService.updateBudget(
                  userId: userId,
                  totalBudget: value,
                );

                print(
                  "hhhhhhhhhhhhhhh API Response totalBudget: ${budget.totalBudget}",
                );

                /// 💾 SAVE totalBudget in SharedPreferences (INT)
                await prefs.saveUserMonthlyBudget(budget.totalBudget.toString());

                print(
                  "hhhhhhhhhhhhhhh totalBudget saved in SharedPreferences: ${budget.totalBudget}",
                );

                /// 🔄 Update UI
                //_budgetNotifier.value = budget.totalBudget;
                _budgetStreamService.updateLocalBudget(budget.totalBudget);

                print("hhhhhhhhhhhhhhh BudgetNotifier updated");

                Navigator.of(ctx).pop();
                print("hhhhhhhhhhhhhhh Dialog closed");
              } catch (e) {
                print("hhhhhhhhhhhhhhh ERROR: $e");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                setState(() => _isLoading = false);
                print("hhhhhhhhhhhhhhh Loading stopped");
              }
            },
            child:  Text("save".tr(),
              style: TextStyle(color: isDarkMode? Colors.white:Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (!_budgetReady) {
      return const SizedBox(); // prevent crash
    }

    final mediaHeight = MediaQuery.of(context).size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (_buttonOffset == null) {
      return const SizedBox();
    }


    return Scaffold(
      backgroundColor: isDarkMode
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  SizedBox(height: mediaHeight * 0.3, child: HomeHeader( notifications: notifications,)),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30, top: mediaHeight * 0.22),
                    child: BalanceCard(
                      budgetStreamService: _budgetStreamService,
                      // budgetStreamService: _budgetStreamService,
                      //  budgetNotifier: _budgetNotifier
                    ),
                  ),
                  IncomeHelpBanner(heroTag: "homeHelpFormHero"),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: mediaHeight * 0.465),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [


                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'transaction_history'.tr(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final prefs =
                              SharedPreferenceMethods();
                              final token =
                              await prefs.getToken();
                              final userId =
                              await prefs.getUserId();

                              if (token != null &&
                                  userId != null) {
                                context
                                    .read<TransactionProvider>()
                                    .fetchTransactions(
                                    userId, token);
                              }
                            },
                            child: Padding(
                              padding:
                              const EdgeInsets.only(
                                  right: 12),
                              child: Text(
                                "refresh".tr(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            key: _filterIconKey,
                            onTap: _showFilterDrawer,
                            child: const Icon(
                              Icons.filter_alt,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      // color: isDarkMode
                      //     ? Color(0xFFD44D5C)
                      //     :Theme.of(context).scaffoldBackgroundColor,
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
                ],
              ),
            ),
          ),

          // Draggable Floating Button
          Positioned(
            left: _buttonOffset!.dx,
            top: _buttonOffset!.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add, color: Colors.white),
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
                    : Theme.of(context).colorScheme.primary,                onPressed: _showBudgetForm,
                child:  Icon(Icons.add,color: Colors.white,),
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
              color:isDarkMode? Color(0xFFD44D5C): Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Text(option),
          ],
        ),
      ),
    );
  }



}
