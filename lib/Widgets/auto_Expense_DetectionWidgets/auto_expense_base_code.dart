// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
//
//
//
// class AutoExpenseDetectionScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFE53935), // Red color
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp), // Responsive icon size
//           onPressed: () {},
//         ),
//         title: Text(
//           'Auto Expense Detection',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp), // Responsive text size
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w), // Responsive padding
//             color: const Color(0xFFF5F5F5), // Light grey background for date picker
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back_ios, size: 20.sp), // Responsive icon size
//                   onPressed: () {},
//                 ),
//                 Text(
//                   '24 Mar- 30 Mar 2025',
//                   style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold), // Responsive text size
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.arrow_forward_ios, size: 20.sp), // Responsive icon size
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(10.w), // Responsive padding
//             child:  SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildFilterButton('All', Colors.red, true),
//                   _buildFilterButton('Detected', Colors.orange, false, icon: Icons.error_outline),
//                   _buildFilterButton('Saved', Colors.green, false, icon: Icons.check_circle_outline),
//                   _buildFilterButton('Dismissed', Colors.grey, false, icon: Icons.cancel_outlined),
//                 ],
//               ),
//             ),
//
//           ),
//           Expanded(
//             child: ListView(
//               children: [
//                 _buildDayExpenses(
//                     'Wednesday, 26 Mar 2025',
//                     [
//                       ExpenseItem(
//                           time: '9:45 am',
//                           minutesAgo: '17 mins',
//                           status: 'Detected',
//                           statusColor: Colors.green,
//                           icon: Icons.receipt_long,
//                           showEdit: true),
//                     ],
//                     1),
//                 _buildDayExpenses(
//                     'Tuesday, 25 Mar 2025',
//                     [
//                       ExpenseItem(
//                           time: '9:45 am',
//                           minutesAgo: '17 mins',
//                           status: 'Detected',
//                           statusColor: Colors.orange,
//                           icon: Icons.notifications_active),
//                     ],
//                     1),
//                 _buildDayExpenses(
//                     'Monday, 24 Mar 2025',
//                     [
//                       ExpenseItem(
//                           time: '5:31 pm',
//                           minutesAgo: '15 mins',
//                           status: 'Detected',
//                           statusColor: Colors.orange,
//                           icon: Icons.notifications_active),
//                       ExpenseItem(
//                           time: '11:45 am',
//                           minutesAgo: '12 mins',
//                           status: 'Detected',
//                           statusColor: Colors.orange,
//                           icon: Icons.notifications_active),
//                     ],
//                     2),
//                 _buildDayExpenses(
//                     'Sunday, 23 Mar 2025',
//                     [
//                       ExpenseItem(
//                           time: '9:45 am',
//                           minutesAgo: '17 mins',
//                           status: 'Detected',
//                           statusColor: Colors.orange,
//                           icon: Icons.notifications_active),
//                     ],
//                     1),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterButton(String text, Color color, bool isSelected, {IconData? icon}) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), // Responsive padding
//       decoration: BoxDecoration(
//         color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
//         borderRadius: BorderRadius.circular(20.r), // Responsive border radius
//         border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: 1.w), // Responsive border width
//       ),
//       child: Row(
//         children: [
//           if (icon != null)
//             Icon(
//               icon,
//               color: isSelected ? color : Colors.grey.shade600,
//               size: 18.sp, // Responsive icon size
//             ),
//           if (icon != null) SizedBox(width: 5.w), // Responsive SizedBox
//           Text(
//             text,
//             style: TextStyle(
//               color: isSelected ? color : Colors.grey.shade600,
//               fontWeight: FontWeight.bold,
//               fontSize: 14.sp, // Responsive text size
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDayExpenses(String day, List<ExpenseItem> expenses, int count) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h), // Responsive margin
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)), // Responsive border radius
//       elevation: 0,
//       child: Padding(
//         padding: EdgeInsets.all(15.w), // Responsive padding
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '$day($count)',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.sp, // Responsive text size
//                   ),
//                 ),
//                 Icon(Icons.keyboard_arrow_up, size: 24.sp), // Responsive icon size
//               ],
//             ),
//             SizedBox(height: 10.h), // Responsive SizedBox
//             ...expenses.map((expense) => _buildExpenseRow(expense)).toList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExpenseRow(ExpenseItem expense) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h), // Responsive padding
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8.w), // Responsive padding
//             decoration: BoxDecoration(
//               color: expense.statusColor.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(expense.icon, color: expense.statusColor, size: 20.sp), // Responsive icon size
//           ),
//           SizedBox(width: 10.w), // Responsive SizedBox
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Expense ${expense.status}',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: expense.statusColor,
//                     fontSize: 14.sp, // Responsive text size
//                   ),
//                 ),
//                 Text(
//                   '${expense.time}   ${expense.minutesAgo}',
//                   style: TextStyle(fontSize: 12.sp, color: Colors.grey), // Responsive text size
//                 ),
//               ],
//             ),
//           ),
//           if (expense.showEdit)
//             TextButton(
//               onPressed: () {},
//               child: Text(
//                 'Edit',
//                 style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold, fontSize: 14.sp), // Responsive text size
//               ),
//             )
//           else
//             Row(
//               children: [
//                 OutlinedButton(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     minimumSize: Size(60.w, 30.h), // Responsive size
//                     side: BorderSide(color: Colors.grey.shade300, width: 1.w), // Responsive border width
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), // Responsive border radius
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.close, color: Colors.grey.shade600, size: 18.sp), // Responsive icon size
//                       Text('Dismiss', style: TextStyle(color: Colors.grey, fontSize: 12.sp)), // Responsive text size
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 5.w), // Responsive SizedBox
//                 OutlinedButton(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     minimumSize: Size(60.w, 30.h), // Responsive size
//                     side: BorderSide(color: Colors.green, width: 1.w), // Responsive border width
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), // Responsive border radius
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.check, color: Colors.green, size: 18.sp), // Responsive icon size
//                       Text('Review', style: TextStyle(color: Colors.green, fontSize: 12.sp)), // Responsive text size
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class ExpenseItem {
//   final String time;
//   final String minutesAgo;
//   final String status;
//   final Color statusColor;
//   final IconData icon;
//   final bool showEdit;
//
//   ExpenseItem({
//     required this.time,
//     required this.minutesAgo,
//     required this.status,
//     required this.statusColor,
//     required this.icon,
//     this.showEdit = false,
//   });
// }
// ,,, iss code ko files me divide kro