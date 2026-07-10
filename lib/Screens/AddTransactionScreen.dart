
import 'package:flutter/material.dart';

// NOTE: These are app-specific widgets already in your project.
// If you don't have them, either create them or replace with your own widgets.
import '../Widgets/add_Transaction_Widgets/form_section.dart';

import '../widgets/add_Transaction_Widgets/header_section.dart';

class AddTransactionScreen extends StatefulWidget {


  const AddTransactionScreen({super.key, });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {

  bool _isSubmitting = false; // NEW: loading state

  // 🔥 Parent callback — ye TransactionList me pass hoga
  void _refreshTransactionList() {
    Navigator.pop(context, true); // return true to indicate refresh
  }
  onBackPressed(){
    Navigator.of(context).pop();

  }
  // CHANGE: Replaced simple snackbar-only method with full API integration.
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[50],
      body: SingleChildScrollView(
        child: Stack(
          children: [
            HeaderSection(onBackPressed: onBackPressed),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .25),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .8,
                child: AddTransactionFormSection(
                  onAdded: _refreshTransactionList,
                  // NEW: if your FormSection needs loading state, you can add a parameter for it.
                ),
              ),
            ),
            if (_isSubmitting)
            // NEW: simple overlay loading indicator
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



















// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../Widgets/add_Transaction_Widgets/form_section.dart';
// import '../Widgets/add_Transaction_Widgets/header_section.dart';
//
// class AddTransactionScreen extends StatefulWidget {
//   final VoidCallback onBackPressed;
//
//   const AddTransactionScreen({super.key, required this.onBackPressed});
//
//   @override
//   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// }
//
// class _AddTransactionScreenState extends State<AddTransactionScreen> {
//   final TextEditingController _itemController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   XFile? _selectedImage;
//
//   @override
//   void dispose() {
//     _itemController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final ImageSource? source = await showDialog<ImageSource>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Image Source'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Camera'),
//                 onTap: () => Navigator.of(context).pop(ImageSource.camera),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () => Navigator.of(context).pop(ImageSource.gallery),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//
//     if (source != null) {
//       final XFile? image = await _picker.pickImage(
//         source: source,
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
//       if (image != null) {
//         setState(() {
//           _selectedImage = image;
//         });
//       }
//     }
//   }
//
//   Future<void> _saveTransaction() async {
//     if (_itemController.text.isEmpty || _amountController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill in all fields'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Transaction saved!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//
//     _itemController.clear();
//     _amountController.clear();
//     setState(() => _selectedImage = null);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     print("\n  =+++++++++++++++++++++++++++++++++++++++++++Building AddTransactionScreen  \n"); // Add this
//     return Scaffold(
//       backgroundColor:isDarkMode ? Colors.black : Colors.grey[50],
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             HeaderSection(onBackPressed: widget.onBackPressed),
//             Padding(
//               padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*.25 ),
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height * .8,
//                 child: FormSection(
//                   itemController: _itemController,
//                   amountController: _amountController,
//                   selectedImage: _selectedImage,
//                   onPickImage: _pickImage,
//                   onSave: _saveTransaction,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }













//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import '../Widgets/add_Transaction_Widgets/form_section.dart';
// import '../Widgets/add_Transaction_Widgets/header_section.dart';
//
//
// class AddTransactionScreen extends StatefulWidget {
//
//   const AddTransactionScreen({super.key,});
//
//   @override
//   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// }
//
// class _AddTransactionScreenState extends State<AddTransactionScreen> with SingleTickerProviderStateMixin{
//   final TextEditingController _itemController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   XFile? _selectedImage;
//
//   @override
//   void dispose() {
//     _itemController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }
//
//
//
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: Stack(
//         children: [
//           Container(
//             child:
//               HeaderSection(onBackPressed: () => Navigator.of(context).pop()),
//
//
//           ),
//
//           Padding(
//             padding:  EdgeInsets.only(top: 240.0),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height*.6,
//               child: Container(
//                 child: FormSection(
//                   itemController: _itemController,
//                   amountController: _amountController,
//                   selectedImage: _selectedImage,
//                   onPickImage: _pickImage,
//                   onSave: _saveTransaction,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final ImageSource? source = await showDialog<ImageSource>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Select Image Source'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text('Camera'),
//                   onTap: () => Navigator.of(context).pop(ImageSource.camera),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: const Text('Gallery'),
//                   onTap: () => Navigator.of(context).pop(ImageSource.gallery),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//
//       if (source != null) {
//         final XFile? image = await _picker.pickImage(
//           source: source,
//           maxWidth: 1800,
//           maxHeight: 1800,
//           imageQuality: 85,
//         );
//
//         if (image != null) {
//           setState(() {
//             _selectedImage = image;
//           });
//
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Invoice image selected successfully!'),
//                 backgroundColor: Colors.green,
//                 duration: Duration(seconds: 2),
//               ),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error selecting image: ${e.toString()}'),
//             backgroundColor: const Color(0xFFEF5350),
//           ),
//         );
//       }
//     }
//   }
//
//   void _saveTransaction() {
//     if (_itemController.text.isEmpty || _amountController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill in all fields'),
//           backgroundColor: Color(0xFFEF5350),
//         ),
//       );
//       return;
//     }
//
//     if (_selectedImage != null) {
//       print('Selected image path: ${_selectedImage!.path}');
//       print('Selected image name: ${_selectedImage!.name}');
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Transaction saved successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//
//     _itemController.clear();
//     _amountController.clear();
//     setState(() {
//       _selectedImage = null;
//     });
//   }
// }
//
