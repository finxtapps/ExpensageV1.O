import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../Api_Services/Add_transaction_Services.dart';
import '../../providerListner/DashboardProvider.dart';
import '../../providerListner/addTransactionProvider.dart';
import '../../shared_prefrence/SharedPrefrenceMethods.dart';
import 'upload_button.dart';

class AddTransactionFormSection extends StatefulWidget {
  final VoidCallback onAdded;
  const AddTransactionFormSection({super.key, required this.onAdded});

  @override
  State<AddTransactionFormSection> createState() =>
      _AddTransactionFormSectionState();
}

class _AddTransactionFormSectionState extends State<AddTransactionFormSection> {
  ImagePicker _picker = ImagePicker();
  TextEditingController _itemController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  XFile? _selectedImage;
  bool _isLoading = false;
  String? _transactionType;

  /// NEW
  String selectedIconName = "receipt_long_outlined";
  String selectedCategory = "others"; // NEW CATEGORY

  Future<void> _pickImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('select_image_source'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('camera'.tr()),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('gallery'.tr()),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    }
  }

  /// ---------------- SAVE PROCESS ----------------
  Future<void> _processSave() async {
    final item = _itemController.text.trim();
    final amount = _amountController.text.trim();

    if (item.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("please_fill_all_fields".tr())),
      );
      return;
    }

    if (_transactionType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("please_select_income_or_expense".tr())),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = SharedPreferenceMethods();

      final token = await prefs.getToken() ?? "";
      final userId = await prefs.getUserId() ?? "";

      if (token.isEmpty || userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("user_not_logged_in".tr()),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      File? invoiceFile;
      if (_selectedImage != null) {
        invoiceFile = File(_selectedImage!.path);
      }

      final service = TransactionService();

      /// 🔥 NEW — category and icon both sending
      bool success = await service.createTransaction(
        token: token,
        userId: userId,
        item: item,
        amount: int.parse(amount),
        invoiceFile: invoiceFile,
        type: _transactionType!.toLowerCase(),
        icon: selectedIconName,
        category: selectedCategory,
      );

      if (success) {
       // widget.onAdded();

        final prefs = SharedPreferenceMethods();
        final token = await prefs.getToken();
        final userId = await prefs.getUserId();

        if (token != null && userId != null) {
          context.read<TransactionProvider>()
              .fetchTransactions(userId, token);
        }

        context.read<DashboardProvider>()
            .refreshAll();




        Navigator.pop(context); // back to list screen

      }

      _itemController.clear();
      _amountController.clear();
      setState(() {
        _selectedImage = null;
        _transactionType = null;
        selectedIconName = "receipt_long_outlined";
        selectedCategory = "others"; // RESET
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isDarkMode
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                border: Border.all(
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  /// Dynamic icon field
                  DynamicIconTextField(
                    controller: _itemController,
                    isDarkMode: isDarkMode,

                    /// NEW — 2 parameters return
                    onIconChanged: (name, category) {
                      selectedIconName = name;
                      selectedCategory = category;
                    },
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money,
                            size: 22,
                            color:
                            isDarkMode ? Colors.white : Colors.grey[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'enter_amount'.tr(),
                              hintStyle: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.grey[500]),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context)
                                        .colorScheme
                                        .primary),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildTransactionTypeChips(),



                  const SizedBox(height: 15),

                  Text(
                    'add_invoice'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.16,
                    width: double.infinity,
                    child: UploadButton(
                      selectedImage: _selectedImage,
                      onPressed: () async {
                        await _pickImage();
                      },
                    ),
                  ),

                  if (_selectedImage != null) _buildSelectedImageInfo(),
                  const SizedBox(height: 20),

                  _buildBottomButtons(context, isDarkMode),
                ],
              ),
            ),

            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImageInfo() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(Icons.image_outlined,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedImage!.name,
                  style:
                  TextStyle(fontSize: 14, color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context, bool isDarkMode) {
    return Row(
      children: [

        Expanded(
          child: ElevatedButton(
            onPressed: _processSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? const Color(0xFFD44D5C)
                  : Theme.of(context).colorScheme.secondary,
              padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 2,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.08,
              child:  Center(
                child: Text(
                  'save'.tr(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ----------------  transaction type ----------------

  Widget _buildTransactionTypeChips() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FormField<String>(
      validator: (value) {
        if (_transactionType == null) {
          return "Please select transaction type";
        }
        return null;
      },
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "select_type".tr(),
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label:  Text("expenses".tr()),
                    selected: _transactionType == "Expense",
                    selectedColor: Colors.red.shade400,
                    backgroundColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: _transactionType == "Expense"
                          ? Colors.white
                          : (isDarkMode ? Colors.white : Colors.black),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _transactionType = "Expense";
                      });
                      field.didChange("Expense");
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label:  Text("income".tr()),
                    selected: _transactionType == "Income",
                    selectedColor: Colors.green.shade500,
                    backgroundColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: _transactionType == "Income"
                          ? Colors.white
                          : (isDarkMode ? Colors.white : Colors.black),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _transactionType = "Income";
                      });
                      field.didChange("Income");
                    },
                  ),
                ),
              ],
            ),

            /// ❌ Error Message
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }



}

/// ---------------- Dynamic Icon TextField ----------------

class DynamicIconTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isDarkMode;

  /// UPDATED: returns iconName + category
  final Function(String iconName, String category)? onIconChanged;

  const DynamicIconTextField({
    super.key,
    required this.controller,
    required this.isDarkMode,
    this.onIconChanged,
  });

  @override
  State<DynamicIconTextField> createState() => _DynamicIconTextFieldState();
}

class _DynamicIconTextFieldState extends State<DynamicIconTextField> {
  IconData currentIcon = Icons.receipt_long_outlined;
  String currentIconName = "receipt_long_outlined";

  /// NEW
  String currentIconCategory = "others";

  final Map<String, Map<String, IconData>> categories = {

    // ----------------------- Entertainment -----------------------
    "entertainment": {
      "entertainment": Icons.local_activity,
      "games": Icons.local_activity,
      "movies": Icons.movie,

      "sports": Icons.sports_soccer,
      "movie": Icons.movie,
      "book": Icons.book,
      "music": Icons.music_note,
    },

    // ----------------------- Food and Drink -----------------------
    "food": {


      "burger": Icons.fastfood,
      "food": Icons.fastfood,
      "food":Icons.restaurant,
      "dining out": Icons.restaurant,
      "groceries": Icons.restaurant,
      "liquor": Icons.restaurant,
      "pizza": Icons.restaurant,
      "pasta": Icons.restaurant,
    },

    // ----------------------- Home -----------------------
    "home": {
      "electronics": Icons.devices,
      "furniture": Icons.chair_alt,
      "household supplies": Icons.cleaning_services,
      "maintenance": Icons.home_repair_service,
      "mortgage": Icons.house,
      "rent": Icons.home_work,
      "services": Icons.miscellaneous_services,
    },

    // ----------------------- Life -----------------------
    "life": {
      "childcare": Icons.child_friendly,
      "clothing": Icons.checkroom,
      "education": Icons.school,
      "gifts": Icons.card_giftcard,
      "insurance": Icons.health_and_safety,
      "medical expenses": Icons.medical_services,
      "stationery": Icons.edit,                 // ⭐ ADDED
      "taxes": Icons.attach_money,
    },

    // ----------------------- Transportation -----------------------
    "transportation": {
      "bicycle": Icons.pedal_bike,
      "bus/train": Icons.directions_bus,
      "car": Icons.directions_car,
      "gas/fuel": Icons.local_gas_station,
      "hotel": Icons.hotel,
      "parking": Icons.local_parking,
      "plane": Icons.flight,
      "taxi": Icons.local_taxi,
    },

    // ----------------------- Uncategorized -----------------------
    "uncategorized": {
      "general": Icons.category,
    },

    // ----------------------- Utilities -----------------------
    "utilities": {
      "cleaning": Icons.cleaning_services,
      "electricity": Icons.bolt,
      "heat/gas": Icons.local_fire_department,
      "trash": Icons.delete,
      "tv/phone/internet": Icons.wifi,
      "water": Icons.water_drop,
    },


    "vehicle": {
      "car": Icons.directions_car,
      "bike": Icons.pedal_bike,
      "bicycle": Icons.pedal_bike,
    },
    "electronics": {
      "mobile": Icons.smartphone,
      "phone": Icons.smartphone,
      "laptop": Icons.laptop_mac,
      "tablet": Icons.tablet_mac,
    },

    "gifts": {
      "gift": Icons.card_giftcard,
      "present": Icons.card_giftcard,
    },


  };


  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateIcon);
  }

  void _updateIcon() {
    final text = widget.controller.text.toLowerCase();

    IconData iconToSet = Icons.receipt_long_outlined;
    String iconNameToSet = "receipt_long_outlined";
    String detectedCategory = "others";

    outer:
    for (var categoryName in categories.keys) {
      final categoryItems = categories[categoryName]!;
      for (var entry in categoryItems.entries) {
        if (text.contains(entry.key)) {
          iconToSet = entry.value;
          iconNameToSet = entry.key;   // ✅ FIXED
          detectedCategory = categoryName;
          break outer;
        }
      }
    }

    if (iconToSet != currentIcon) {
      setState(() {
        currentIcon = iconToSet;
        currentIconName = iconNameToSet;
        currentIconCategory = detectedCategory;
      });

      if (widget.onIconChanged != null) {
        widget.onIconChanged!(currentIconName, currentIconCategory);
      }
    }
  }







  @override
  void dispose() {
    widget.controller.removeListener(_updateIcon);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ConstrainedBox(

        constraints: const BoxConstraints(minHeight: 56),
        child: Row(
          children: [
            Icon(
              currentIcon,
              size: 22,
              color: isDarkMode ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: widget.controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "enter_the_item".tr(),
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.grey[500],
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                        Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}


































// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import '../../Api_Services/Add_transaction_Services.dart';
// import '../../shared_prefrence/SharedPrefrenceMethods.dart';
// import 'upload_button.dart';
//
// class AddTransactionFormSection extends StatefulWidget {
//   final VoidCallback onAdded; //// 🔥 callback for parent to refresh list
//   const AddTransactionFormSection({super.key, required this.onAdded});
//
//   @override
//   State<AddTransactionFormSection> createState() =>
//       _AddTransactionFormSectionState();
// }
//
//
//
// class _AddTransactionFormSectionState extends State<AddTransactionFormSection> {
//   ImagePicker _picker = ImagePicker();
//   TextEditingController _itemController = TextEditingController();
//   TextEditingController _amountController = TextEditingController();
//
//   XFile? _selectedImage;
//   bool _isLoading = false;
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
//   /// ---------------- SAVE PROCESS ----------------
//   Future<void> _processSave() async {
//     final item = _itemController.text.trim();
//     final amount = _amountController.text.trim();
//
//     if (item.isEmpty || amount.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill in all fields")),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       final prefs = SharedPreferenceMethods();
//
//       final token = await prefs.getToken() ?? "";
//       final userId = await prefs.getUserId() ?? "";
//
//       if (token.isEmpty || userId.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("User not logged in"),
//             backgroundColor: Colors.red,
//           ),
//         );
//         setState(() => _isLoading = false);
//         return;
//       }
//
//       /// 🔥 Convert XFile to File (service expects File)
//       File? invoiceFile;
//       if (_selectedImage != null) {
//         invoiceFile = File(_selectedImage!.path);
//       }
//
//       /// 🔥 API CALL
//       final service = TransactionService();
//
//       bool success =await service.createTransaction(
//         token: token,
//         userId: userId,
//         item: item,
//         amount: int.parse(amount),
//         invoiceFile: invoiceFile,
//       );
//       // 🔥 On success, call parent callback to refresh TransactionList
//       if (success) {
//         widget.onAdded(); // refresh parent list
//       }
//
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(
//       //     content: Text("Transaction Added Successfully!"),
//       //     backgroundColor: Colors.green,
//       //   ),
//       // );
//
//       _itemController.clear();
//       _amountController.clear();
//       setState(() => _selectedImage = null);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return SingleChildScrollView(
//       physics: const NeverScrollableScrollPhysics(),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0),
//         child: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 color: isDarkMode ? Colors.black : Colors.white,
//                 border: Border.all(
//                     color: isDarkMode ? Colors.white : Colors.black),
//               ),
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//
//                   DynamicIconTextField(
//                     controller: _itemController,
//                     isDarkMode: isDarkMode,
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       children: [
//                         Icon(Icons.attach_money,
//                             size: 22,
//                             color:
//                             isDarkMode ? Colors.white : Colors.grey[700]),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: TextField(
//                             controller: _amountController,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               hintText: 'Enter the Amount',
//                               hintStyle: TextStyle(
//                                   color: isDarkMode
//                                       ? Colors.white
//                                       : Colors.grey[500]),
//                               border: InputBorder.none,
//                               isDense: true,
//                               contentPadding:
//                               const EdgeInsets.symmetric(vertical: 14),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: isDarkMode
//                                         ? Colors.white
//                                         : Theme.of(context)
//                                         .colorScheme
//                                         .primary),
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .secondary),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 50),
//
//                   Text(
//                     'Add invoice',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: isDarkMode ? Colors.white : Colors.grey,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   SizedBox(
//                     height: MediaQuery.of(context).size.width * 0.16,
//                     width: double.infinity,
//                     child: UploadButton(
//                       selectedImage: _selectedImage,
//                       onPressed: () async {
//                         await _pickImage();
//                       },
//                     ),
//                   ),
//
//                   if (_selectedImage != null) _buildSelectedImageInfo(),
//                   const SizedBox(height: 20),
//
//                   _buildBottomButtons(context, isDarkMode),
//                 ],
//               ),
//             ),
//
//
//
//             if (_isLoading)
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.black.withOpacity(0.25),
//                   child: const Center(child: CircularProgressIndicator()),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSelectedImageInfo() {
//     return Column(
//       children: [
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.image_outlined,
//                   size: 16, color: Colors.grey[600]),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   _selectedImage!.name,
//                   style:
//                   TextStyle(fontSize: 14, color: Colors.grey[700]),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBottomButtons(BuildContext context, bool isDarkMode) {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () {},
//             style: OutlinedButton.styleFrom(
//               padding:
//               const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//               side: BorderSide(
//                 color: isDarkMode ? Colors.white : Colors.black,
//                 width: 1.5,
//               ),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//             ),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.width * 0.08,
//               child: Center(
//                 child: Text(
//                   'Add more',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: isDarkMode
//                         ? const Color(0xFFD44D5C)
//                         : Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: _processSave,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isDarkMode
//                   ? const Color(0xFFD44D5C)
//                   : Theme.of(context).colorScheme.secondary,
//               padding:
//               const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//               elevation: 2,
//             ),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.width * 0.08,
//               child: const Center(
//                 child: Text(
//                   'Save',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
// // ---------------- Dynamic Icon TextField using Nested Map ----------------
// class DynamicIconTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final bool isDarkMode;
//
//   const DynamicIconTextField({
//     super.key,
//     required this.controller,
//     required this.isDarkMode,
//   });
//
//   @override
//   State<DynamicIconTextField> createState() => _DynamicIconTextFieldState();
// }
//
// class _DynamicIconTextFieldState extends State<DynamicIconTextField> {
//   IconData currentIcon = Icons.receipt_long_outlined;
//
//   // Nested Map: Category -> {keyword -> icon}
//   final Map<String, Map<String, IconData>> categories = {
//     "food": {
//       "pizza": Icons.fastfood,
//       "pasta": Icons.fastfood,
//       "burger": Icons.fastfood,
//       "food": Icons.fastfood,
//     },
//     "vehicle": {
//       "car": Icons.directions_car,
//       "bike": Icons.pedal_bike,
//       "bicycle": Icons.pedal_bike,
//     },
//     "electronics": {
//       "mobile": Icons.smartphone,
//       "phone": Icons.smartphone,
//       "laptop": Icons.laptop_mac,
//       "tablet": Icons.tablet_mac,
//     },
//     "entertainment": {
//       "movie": Icons.movie,
//       "book": Icons.book,
//       "music": Icons.music_note,
//     },
//     "gifts": {
//       "gift": Icons.card_giftcard,
//       "present": Icons.card_giftcard,
//     },
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_updateIcon);
//   }
//
//   void _updateIcon() {
//     final text = widget.controller.text.toLowerCase();
//     IconData iconToSet = Icons.receipt_long_outlined;
//
//     outerLoop:
//     for (var category in categories.values) {
//       for (var entry in category.entries) {
//         if (text.contains(entry.key)) {
//           iconToSet = entry.value;
//           break outerLoop; // pehla match hi use kare
//         }
//       }
//     }
//
//     if (iconToSet != currentIcon) {
//       setState(() {
//         currentIcon = iconToSet;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     widget.controller.removeListener(_updateIcon);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = widget.isDarkMode;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(minHeight: 56),
//         child: Row(
//           children: [
//             Icon(currentIcon,
//                 size: 22,
//                 color: isDarkMode ? Colors.white : Colors.grey[700]),
//             const SizedBox(width: 12),
//             Expanded(
//               child: TextField(
//                 controller: widget.controller,
//                 keyboardType: TextInputType.text,
//                 decoration: InputDecoration(
//                   hintText: "Enter the item",
//                   hintStyle: TextStyle(
//                       color: isDarkMode ? Colors.white : Colors.grey[500]),
//                   border: InputBorder.none,
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                         color: isDarkMode
//                             ? Colors.white
//                             : Theme.of(context).colorScheme.primary),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).colorScheme.secondary),
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
