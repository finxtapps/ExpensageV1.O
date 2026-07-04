import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Api_Models/transaction_History_model.dart';
import '../providerListner/addTransactionProvider.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../providerListner/theme_notifier.dart';

class TransactionList extends StatefulWidget {
  final bool scrolling;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const TransactionList({
    super.key,
    this.scrolling = false,
    required this.selectedFilter,
    required this.onFilterChanged,
  });
  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final GlobalKey _filterIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = SharedPreferenceMethods();
      final token = await prefs.getToken();
      final userId = await prefs.getUserId();

      if (token != null && userId != null) {
        context.read<TransactionProvider>().fetchTransactions(userId, token);
      }
    });
  }

  /// ---------------- ICON FUNCTION ----------------
  IconData getIconFromCategory(String? category) {
    if (category == null || category.isEmpty) {
      return Icons.category;
    }

    switch (category.toLowerCase().trim()) {
      case "food":
        return Icons.restaurant;
      case "entertainment":
        return Icons.local_activity;
      case "utilities":
        return Icons.bolt;
      case "other":
      case "others":
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }

  // ---------------- FILTER LOGIC ----------------
  List<TransactionData> _applyFilter(List<TransactionData> transactions) {
    if (widget.selectedFilter == "Lifetime"||widget.selectedFilter == "आजीवन") return transactions;

    final now = DateTime.now();
    DateTime startDate;

    switch (widget.selectedFilter) {
      case "أسبوعي": //ar
      case "wöchentlich"://de
      case "Weekly": //en
      case "semanal"://es
      case "hebdomadaire"://fr
      case "साप्ताहिक"://hi
      case "毎週"://ja
      case "每周"://zh



        startDate = now.subtract(const Duration(days: 7));
        break;
      case "Monthly": // en
      case "मासिक": // hi
      case "شهري": // ar
      case "monatlich": // de
      case "mensual": // es
      case "mensuel": // fr
      case "毎月": // ja
      case "每月": // zh
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;

    // Yearly
      case "Yearly": // en
      case "वार्षिक": // hi
      case "سنوي": // ar
      case "jährlich": // de
      case "anual": // es
      case "annuel": // fr
      case "毎年": // ja
      case "每年": // zh
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;

    // Lifetime
      case "Lifetime": // en
      case "आजीवन": // hi
      case "مدى الحياة": // ar
      case "lebenslang": // de
      case "de por vida": // es
      case "à vie": // fr
      case "生涯": // ja
      case "终身": // zh
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        return transactions;
    }

    return transactions.where((tx) {
      final txDate =
          DateTime.tryParse(tx.createdAt ?? "") ?? DateTime.now();
      return txDate.isAfter(startDate) ||
          txDate.isAtSameMomentAs(startDate);
    }).toList();
  }

  // ---------------- FILTER POPUP ----------------
  void _showFilterDrawer() {
    final options = ['Lifetime', 'Weekly', 'Monthly', 'Yearly'];

    final RenderBox renderBox =
    _filterIconKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filter',
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned(
              top: position.dy + renderBox.size.height + 5,
              right: MediaQuery.of(context).size.width -
                  position.dx -
                  renderBox.size.width,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((option) {
                      return ListTile(
                        dense: true,
                        title: Text(option),
                        trailing: widget.selectedFilter == option
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () {
                          widget.onFilterChanged(option);
                          Navigator.pop(context);
                        },
                      );
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

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final secondaryColor = themeProvider.themeData.colorScheme.secondary
              .withOpacity(0.1);
          return Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade500, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Consumer<TransactionProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final transactions = _applyFilter(provider.transactions);

                  if (transactions.isEmpty) {
                    return Center(child: Text("no_transactions_found".tr()));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: widget.scrolling ? true : false,
                    physics: widget.scrolling
                        ?
                        NeverScrollableScrollPhysics():AlwaysScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      final parsedDate =
                          DateTime.tryParse(transaction.createdAt ?? "") ??
                          DateTime.now();

                      final amount = (transaction.amount ?? 0).toDouble();

                      final amountColor =
                          transaction.type?.toLowerCase() == "income"
                          ? Colors.green
                          : Colors.red;

                      return Container(
                        height: screenWidth * 0.15,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Theme.of(context).scaffoldBackgroundColor
                              : secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.12,
                              child: Text(
                                DateFormat('MMM\nd').format(parsedDate),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Container(
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                getIconFromCategory(transaction.category),
                                size: screenWidth * 0.05,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: Text(transaction.title ?? "Unknown"),
                            ),
                            Text(
                              '\$${amount.toStringAsFixed(2)}',
                              style: TextStyle(color: amountColor),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
          // ],
          // ),
          // );
        },
      ),
    );
  }
}
