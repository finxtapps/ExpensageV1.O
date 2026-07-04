import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

import '../Api_Models/Income_tax_help_form_model.dart';
import '../Api_Services/income_tax_form_services.dart';
import '../component/header_appbar.dart';

class IncomeTextHelpForm extends StatefulWidget {
  const IncomeTextHelpForm({super.key});

  @override
  State<IncomeTextHelpForm> createState() => _IncomeTextHelpFormState();
}

class _IncomeTextHelpFormState extends State<IncomeTextHelpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _MobileNumberController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();

  File? _uploadedFile;

  bool _isLoading = false;

  // ========================== PICK FILE ==========================
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

  // ========================== SUBMIT FORM ==========================
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    IncomeTaxHelpModel model = IncomeTaxHelpModel(
      fullName: _nameController.text.trim(),
      email: _EmailController.text.trim(),
      phone: _MobileNumberController.text.trim(),
      annualIncome: int.parse(_incomeController.text.trim()),
    );

    final service = IncomeTaxHelpService();

    final response = await service.submitIncomeTaxHelp(
      model: model,
      incomeStatementFile: _uploadedFile, // optional
    );

    setState(() => _isLoading = false);

    if (response != null && response["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("form_submitted_successfully".tr()),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _nameController.clear();
      _incomeController.clear();
      _EmailController.clear();
      _MobileNumberController.clear();
      setState(() => _uploadedFile = null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Submission failed: ${response?['message'] ?? 'Unknown error'}"),
          backgroundColor: Colors.red,
        ),
      );
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
            title: "income_tax_help_form".tr(),
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
                      Text(
                        "Enter Your Details",
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
                        controller: _incomeController,
                        isNumberInput: true,
                        label: "annual_income".tr(),
                        icon: Icons.money,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 20.h),

                      // File Upload Box
                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: isDarkMode?Colors.grey[900]:Colors.white,
                            border: Border.all(
                                color: _uploadedFile != null
                                    ? Colors.orangeAccent
                                    : Colors.grey),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.upload_file,
                                  size: 24.sp,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.primary),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  _uploadedFile != null
                                      ? _uploadedFile!.path.split('/').last
                                      : "upload_annual_income_statement".tr(),
                                  style: TextStyle(fontSize: 14.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:isDarkMode?Color(0xFFD44D5C):
                            Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "Submit",
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

  // ========================== Reusable Input Field ==========================
  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    bool isNumberInput = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
      isNumberInput ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: isDarkMode
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.orangeAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent),
        ),
        fillColor: isDarkMode?Colors.grey[900]:Colors.white,
        filled: true,
      ),
      validator: validator ??
              (value) =>
          value == null || value.trim().isEmpty
              ? "This field is required"
              : null,
    );
  }
}



























// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../component/header_appbar.dart';
//
// class IncomeTextHelpForm extends StatefulWidget {
//   const IncomeTextHelpForm({super.key});
//
//   @override
//   State<IncomeTextHelpForm> createState() => _IncomeTextHelpFormState();
// }
//
// class _IncomeTextHelpFormState extends State<IncomeTextHelpForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _incomeController = TextEditingController();
//   final TextEditingController _MobileNumberController = TextEditingController();
//   final TextEditingController _EmailController = TextEditingController();
//
//   File? _uploadedFile;
//
//   // ✅ File picker with permission handling
//   Future<void> _pickFile() async {
//     try {
//       // ✅ For Android 13+ and iOS, no permission needed
//       if (Platform.isAndroid) {
//         var androidVersion = int.tryParse(
//           (await FilePicker.platform.getDirectoryPath()) ?? "0",
//         );
//       }
//
//       // Try file picker directly
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
//
//   // ✅ Submit function with validation
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (_uploadedFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please upload your Annual Income Statement'),
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
//       // Clear form
//       _nameController.clear();
//       _incomeController.clear();
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
//           // ✅ Custom Header Appbar
//           const HeaderAppbar(
//             title: "Income Tax Help Form",
//             titleSize:true,
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
//                         "Enter Your Details",
//                         style: TextStyle(
//                           fontSize: 22.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 30.h),
//
//                       // ✅ Name Field
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
//
//                       buildInputField(
//                         controller: _incomeController,
//                         isNumberInput:true,
//                         label: "Annual Income",
//                         icon: Icons.money,
//                         isDarkMode: isDarkMode,
//                       ),
//                       SizedBox(height: 20.h),
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
//                                   color:isDarkMode?Colors.white: Theme.of(context).colorScheme.primary),
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: Text(
//                                   _uploadedFile != null
//                                       ? _uploadedFile!.path.split('/').last
//                                       : "Upload Annual Income Statement (PDF/DOC)",
//                                   style: TextStyle(fontSize: 14.sp),
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
//                             style:
//                             TextStyle(fontSize: 18.sp, color: Colors.white),
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
//
//
//
//
//
// }
























// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:file_picker/file_picker.dart';
//
// import '../component/header_appbar.dart';
//
// class IncomeTextHelpForm extends StatefulWidget {
//   const IncomeTextHelpForm({super.key});
//
//   @override
//   State<IncomeTextHelpForm> createState() => _IncomeTextHelpFormState();
// }
//
// class _IncomeTextHelpFormState extends State<IncomeTextHelpForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _incomeController = TextEditingController();
//
//   File? _uploadedFile;
//
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );
//     if (result != null) {
//       setState(() {
//         _uploadedFile = File(result.files.single.path!);
//       });
//     }
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (_uploadedFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please upload your Annual Income Statement'),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//         return;
//       }
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Form submitted successfully! Our specialist will contact you soon.'),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 3),
//         ),
//       );
//
//       // Clear form
//       _nameController.clear();
//       _incomeController.clear();
//       setState(() => _uploadedFile = null);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
// backgroundColor:isDarkMode?Colors.black: Theme.of(context).scaffoldBackgroundColor,
//       body: Container(
//         child: Column(
//           children: [
//             HeaderAppbar(title: "IncomeTax Help Form",
//               back_btn: true,),
//             Padding(
//               padding: EdgeInsets.all(20.w),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20.h),
//                       Text(
//                         "Enter Your Details",
//                         style: TextStyle(
//                           fontSize: 22.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 30.h),
//
//                       // Name Field
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.person,color: Theme.of(context).colorScheme.primary,),
//                           labelText: "Full Name",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                         ),
//                         validator: (value) =>
//                         value == null || value.trim().isEmpty ? "This field is required" : null,
//                       ),
//                       SizedBox(height: 20.h),
//
//                       // Annual Income Field
//                       TextFormField(
//                         controller: _incomeController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.money,color: Theme.of(context).colorScheme.primary,),
//                           labelText: "Annual Income",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                         ),
//                         validator: (value) =>
//                         value == null || value.trim().isEmpty ? "This field is required" : null,
//                       ),
//                       SizedBox(height: 25.h),
//
//                       // File Upload Container
//                       GestureDetector(
//                         onTap: _pickFile,
//                         child: Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.upload_file, size: 24.sp, color:Theme.of(context).colorScheme.primary),
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: Text(
//                                   _uploadedFile != null
//                                       ? _uploadedFile!.path.split('/').last
//                                       : "Upload Annual Income Statement (PDF/DOC)",
//                                   style: TextStyle(fontSize: 14.sp),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 40.h),
//
//                       // Submit Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50.h,
//                         child: ElevatedButton(
//                           onPressed: _submitForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Theme.of(context).colorScheme.secondary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                           ),
//                           child: Text(
//                             "Submit",
//                             style: TextStyle(fontSize: 18.sp, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
