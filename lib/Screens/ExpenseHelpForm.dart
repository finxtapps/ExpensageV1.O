import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

import '../Api_Services/expense_help_form_services.dart';
import '../component/header_appbar.dart';

class HelpInManageExpenseForm extends StatefulWidget {
  const HelpInManageExpenseForm({super.key});

  @override
  State<HelpInManageExpenseForm> createState() =>
      _HelpInManageExpenseFormState();
}

class _HelpInManageExpenseFormState extends State<HelpInManageExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _MobileNumberController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();

  File? _uploadedFile;

  // ✅ File Picker
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _uploadedFile = File(result.files.single.path!);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "File uploaded: ${_uploadedFile!.path.split('/').last}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.teal,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("error_picking_file".tr(args: [e.toString()])),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ======================================================
  // 🔥 Submit Form + API Integration (File Optional)
  // ======================================================
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final service = ManageExpenseService();

        final result = await service.submitExpense(
          fullName: _nameController.text.trim(),
          email: _EmailController.text.trim(),
          phone: _MobileNumberController.text.trim(),
          annualExpense: int.parse(_expenseController.text.trim()),
          expenseProofFile: _uploadedFile, // 🔥 Optional Now
        );

        if (result != null && result.success == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );

          _nameController.clear();
          _EmailController.clear();
          _MobileNumberController.clear();
          _expenseController.clear();
          setState(() => _uploadedFile = null);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("something_went_wrong".tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("error".tr(args: [e.toString()])),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? Colors.black
          : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          HeaderAppbar(
            title: "help_in_manage_expense".tr(),
            titleSize: true,
            back_btn: true,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      /// "enter_expense_details".tr(),
                      Text(
                        "enter_expense_details".tr(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      buildInputField(
                        controller: _nameController,
                        label: "full_name".tr(),
                        icon: Icons.person,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 20.h),

                      buildInputField(
                        controller: _EmailController,
                        label: "email".tr(),
                        icon: Icons.email,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 20.h),

                      buildInputField(
                        controller: _MobileNumberController,
                        label: "mobile_number".tr(),
                        isNumberInput: true,
                        icon: Icons.phone,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 20.h),

                      buildInputField(
                        controller: _expenseController,
                        label: "annual_expense".tr(),
                        isNumberInput: true,
                        icon: Icons.money,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 25.h),

                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: isDarkMode?Colors.grey[900]:Colors.white,
                            border:
                            Border.all(color: Colors.orangeAccent),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.upload_file,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Theme.of(context)
                                      .colorScheme
                                      .primary),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  _uploadedFile != null
                                      ? _uploadedFile!.path.split('/').last
                                      : "upload_expense_proof".tr(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),

                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:isDarkMode?Color(0xFFD44D5C):
                            Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: Text(
                            "submit".tr(),
                            style: TextStyle(
                                fontSize: 18.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    bool isNumberInput = false,
    String? Function(String?)? validator,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType:
      isNumberInput ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color:
          isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.orangeAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode? Colors.orangeAccent:Theme.of(context).colorScheme.primary),
        ),
        fillColor: isDarkMode?Colors.grey[900]:Colors.white,
        filled: true,
      ),
      validator: validator ??
              (value) =>
          value!.trim().isEmpty ? "This field is required" : null,
    );
  }
}













// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:file_picker/file_picker.dart';
//
// import '../Api_Services/expense_help_form_services.dart';
// import '../component/header_appbar.dart';
//
// class HelpInManageExpenseForm extends StatefulWidget {
//   const HelpInManageExpenseForm({super.key});
//
//   @override
//   State<HelpInManageExpenseForm> createState() =>
//       _HelpInManageExpenseFormState();
// }
//
// class _HelpInManageExpenseFormState extends State<HelpInManageExpenseForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _expenseController = TextEditingController();
//   final TextEditingController _MobileNumberController = TextEditingController();
//   final TextEditingController _EmailController = TextEditingController();
//
//   File? _uploadedFile;
//
//   // ✅ File Picker
//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx'],
//       );
//
//       if (result != null && result.files.single.path != null) {
//         setState(() {
//           _uploadedFile = File(result.files.single.path!);
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "File uploaded: ${_uploadedFile!.path.split('/').last}",
//               style: const TextStyle(color: Colors.white),
//             ),
//             backgroundColor: Colors.teal,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error picking file: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   // ======================================================
//   // 🔥 Submit Form + API Integration (FILE + FIELDS)
//   // ======================================================
//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_uploadedFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please upload your Expense Proof Document'),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//         return;
//       }
//
//       try {
//         final service = ManageExpenseService();
//
//         final result = await service.submitExpense(
//           fullName: _nameController.text.trim(),
//           email: _EmailController.text.trim(),
//           phone: _MobileNumberController.text.trim(),
//           annualExpense: int.parse(_expenseController.text.trim()),
//           expenseProofFile: _uploadedFile!, // 🔥 FILE SENDING
//         );
//
//         if (result != null && result.success == true) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 result.message,
//                 style: const TextStyle(color: Colors.white),
//               ),
//               backgroundColor: Colors.green,
//             ),
//           );
//
//           _nameController.clear();
//           _EmailController.clear();
//           _MobileNumberController.clear();
//           _expenseController.clear();
//           setState(() => _uploadedFile = null);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Something went wrong!"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: isDarkMode
//           ? Colors.black
//           : Theme.of(context).scaffoldBackgroundColor,
//       body: Column(
//         children: [
//           const HeaderAppbar(
//             title: "Help in Manage Expense",
//             titleSize: true,
//             back_btn: true,
//           ),
//
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(20.w),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20.h),
//                       Text(
//                         "Enter Expense Details",
//                         style: TextStyle(
//                           fontSize: 22.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 30.h),
//
//                       buildInputField(
//                         controller: _nameController,
//                         label: "Full Name",
//                         icon: Icons.person,
//                         isDarkMode: isDarkMode,
//                       ),
//                       SizedBox(height: 20.h),
//
//                       buildInputField(
//                         controller: _EmailController,
//                         label: "Email",
//                         icon: Icons.email,
//                         isDarkMode: isDarkMode,
//                       ),
//                       SizedBox(height: 20.h),
//
//                       buildInputField(
//                         controller: _MobileNumberController,
//                         label: "Mobile Number",
//                         isNumberInput: true,
//                         icon: Icons.phone,
//                         isDarkMode: isDarkMode,
//                       ),
//                       SizedBox(height: 20.h),
//
//                       buildInputField(
//                         controller: _expenseController,
//                         label: "Annual Expense",
//                         isNumberInput: true,
//                         icon: Icons.money,
//                         isDarkMode: isDarkMode,
//                       ),
//                       SizedBox(height: 25.h),
//
//                       GestureDetector(
//                         onTap: _pickFile,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 16.h, horizontal: 12.w),
//                           decoration: BoxDecoration(
//                             border:
//                             Border.all(color: Colors.orangeAccent),
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.upload_file,
//                                   color: isDarkMode
//                                       ? Colors.white
//                                       : Theme.of(context)
//                                       .colorScheme
//                                       .primary),
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: Text(
//                                   _uploadedFile != null
//                                       ? _uploadedFile!.path.split('/').last
//                                       : "Upload Expense Proof (PDF/DOC)",
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     color: Colors.orangeAccent,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 40.h),
//
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50.h,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                             Theme.of(context).colorScheme.secondary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                           ),
//                           onPressed: _submitForm,
//                           child: Text(
//                             "Submit",
//                             style: TextStyle(
//                                 fontSize: 18.sp, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required bool isDarkMode,
//     bool isNumberInput = false,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType:
//       isNumberInput ? TextInputType.number : TextInputType.text,
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           icon,
//           color:
//           isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
//         ),
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.orangeAccent),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       validator: validator ??
//               (value) =>
//           value!.trim().isEmpty ? "This field is required" : null,
//     );
//   }
// }
//





















// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:file_picker/file_picker.dart';
//
// import '../component/header_appbar.dart';
//
// class HelpInManageExpenseForm extends StatefulWidget {
//   const HelpInManageExpenseForm({super.key});
//
//   @override
//   State<HelpInManageExpenseForm> createState() =>
//       _HelpInManageExpenseFormState();
// }
//
// class _HelpInManageExpenseFormState extends State<HelpInManageExpenseForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _expenseController = TextEditingController();
//   final TextEditingController _MobileNumberController = TextEditingController();
//   final TextEditingController _EmailController = TextEditingController();
//
//   File? _uploadedFile;
//
//   // ✅ File Picker
//   Future<void> _pickFile() async {
//     try {
//       // No manual permission needed — system picker handles it
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx'],
//       );
//
//       if (result != null && result.files.single.path != null) {
//         setState(() {
//           _uploadedFile = File(result.files.single.path!);
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "File uploaded: ${_uploadedFile!.path.split('/').last}",
//               style: const TextStyle(color: Colors.white),
//             ),
//             backgroundColor: Colors.teal,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error picking file: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   // ✅ Submit Form
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (_uploadedFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please upload your Expense Proof Document'),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//         return;
//       }
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Form submitted successfully! Our specialist will contact you soon.',
//           ),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 3),
//         ),
//       );
//
//       // Clear fields
//       _nameController.clear();
//       _expenseController.clear();
//       setState(() => _uploadedFile = null);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor:
//       isDarkMode ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
//       body: Column(
//         children: [
//           // ✅ Reusable Header
//           const HeaderAppbar(
//             title: "Help in Manage Expense",
//             titleSize: true,
//             back_btn: true,
//           ),
//
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(20.w),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20.h),
//                       Text(
//                         "Enter Expense Details",
//                         style: TextStyle(
//                           fontSize: 22.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 30.h),
//
//                       // ✅ Name Field
//
//                       buildInputField(
//                         controller: _nameController,
//                         label: "Full Name",
//                         icon: Icons.person,
//                         isDarkMode: isDarkMode,
//                       ),
//                       SizedBox(height: 20.h),
//                       buildInputField(
//                         controller: _EmailController,
//                         label: "Email",
//                         icon: Icons.email,
//                         isDarkMode: isDarkMode,
//                       ),
//                       SizedBox(height: 20.h),
//
//                       buildInputField(
//                         controller: _MobileNumberController,
//                         label: "Mobile Number",
//                         isNumberInput:true,
//                         icon: Icons.phone,
//                         isDarkMode: isDarkMode,
//                       ),SizedBox(height: 20.h),
//                       // ✅ Annual Expense Field
//                       buildInputField(
//                         controller: _expenseController,
//                         isNumberInput:true,
//                         label: "Annual Expense",
//                         icon: Icons.money,
//                         isDarkMode: isDarkMode,
//                       ),
//                       SizedBox(height: 25.h),
//
//                       // ✅ File Upload Container
//                       GestureDetector(
//                         onTap: _pickFile,
//                         child: Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.symmetric(
//                               vertical: 16.h, horizontal: 12.w),
//                           decoration: BoxDecoration(
//                             border: Border.all(color:_uploadedFile != null?Colors.orangeAccent: Colors.grey),
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.upload_file,
//                                   size: 24.sp,
//                                   color:isDarkMode?Colors.white:
//                                   Theme.of(context).colorScheme.primary),
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: Text(
//                                   _uploadedFile != null
//                                       ? _uploadedFile!.path.split('/').last
//                                       : "Upload Expense Proof (PDF/DOC)",
//                                   style: TextStyle(fontSize: 14.sp,
//                                     color: isDarkMode?Colors.orangeAccent:Theme.of(context).colorScheme.primary,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 40.h),
//
//                       // ✅ Submit Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50.h,
//                         child: ElevatedButton(
//                           onPressed: _submitForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                             Theme.of(context).colorScheme.secondary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                           ),
//                           child: Text(
//                             "Submit",
//                             style: TextStyle(
//                                 fontSize: 18.sp, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
//   Widget buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required bool isDarkMode,
//     bool isNumberInput = false,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: isNumberInput==true?TextInputType.phone:TextInputType.text,
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           icon,
//           color: isDarkMode?Colors.white:Theme.of(context).colorScheme.primary,
//         ),
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.orangeAccent),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.orangeAccent),
//         ),
//       ),
//       validator: validator ??
//               (value) =>
//           value == null || value.trim().isEmpty ? "This field is required" : null,
//     );
//   }
//
// }
