import 'dart:io';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../Api_Services/profile_service.dart';
import '../providerListner/currency_notifier.dart';
import '../providerListner/profile_notifier.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import 'package:provider/provider.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? _selectedGender;
  Currency? _selectedCurrency;
  String? _selectedCurrencySymbol; // ✅ ₹ $ ¥
  String? profileImageUrl;


  String name = "";
  String email = "";
  String phone = "";

  Future<void> _loadUserDetails() async {
    final _userName = await SharedPreferenceMethods().getUserName();
    final _userEmail = await SharedPreferenceMethods().getUserEmail();
    final _userMobileNo = await SharedPreferenceMethods().getUserMobileNo();
    final gender = await SharedPreferenceMethods().getUserGender();
    final currency = await SharedPreferenceMethods().getUserCurrency();
    final image = await SharedPreferenceMethods().getUserImageFilename();

    if (gender != null) {
      _selectedGender = gender[0].toUpperCase() + gender.substring(1);
    }

    setState(() {
      name = _userName ?? "";
      email = _userEmail ?? "";
      phone = _userMobileNo ?? "";
      _selectedCurrencySymbol = currency;

      profileImageUrl = image; // ⭐ IMPORTANT

      fullNameController.text = name;
      emailController.text = email;
      phoneController.text = phone;

      _isLoading = false;
    });
  }



  String countryCodeToEmoji(String countryCode) {
    if (countryCode.length != 2) return '';
    return String.fromCharCodes(
      countryCode.toUpperCase().codeUnits.map((codeUnit) => codeUnit + 127397),
    );
  }

  final ProfileService _profileService = ProfileService();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;

  /// -----------------------------------------------------------
  /// PICK IMAGE + SAVE TO SHARED PREF
  /// -----------------------------------------------------------
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);

                  // if (image != null) {
                  //   setState(() => _profileImage = File(image.path));
                  //
                  //   // ⭐ Save image to SharedPreferences
                  //   final bytes = await File(image.path).readAsBytes();
                  //   await SharedPreferenceMethods().saveUserImage(bytes);
                  //   print("Profile image saved from gallery!");
                  // }

                  if (image != null) {

                    setState(() => _profileImage = File(image.path));

                    final bytes = await File(image.path).readAsBytes();

                    await SharedPreferenceMethods().saveUserImage(bytes);

                    context.read<ProfileNotifier>().updateProfileImage(image.path);
                  }

                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.camera);

                  if (image != null) {
                    setState(() => _profileImage = File(image.path));

                    // ⭐ Save image to SharedPreferences
                    final bytes = await File(image.path).readAsBytes();
                    await SharedPreferenceMethods().saveUserImage(bytes);
                    print("Profile image saved from camera!");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// -----------------------------------------------------------
  /// UPDATE PROFILE
  /// -----------------------------------------------------------
  Future<void> _updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userId = await SharedPreferenceMethods().getUserId();

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final success = await _profileService.submitProfile(
      userId: userId,
      name: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      gender: _selectedGender,
      currency: _selectedCurrencySymbol,
      profilePic: _profileImage,
    );

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '✅ Profile updated successfully'
              : '❌ Failed to update profile',
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDarkMode ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, isDarkMode),
            _buildForm(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [Colors.black, Colors.black]
              : [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20, top: 10),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width * .08,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'profile'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 30),

              InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,

                  backgroundImage: !_isLoading
                      ? (_profileImage != null
                      ? FileImage(_profileImage!)
                      : (profileImageUrl != null && profileImageUrl!.isNotEmpty
                      ? NetworkImage(profileImageUrl!)
                      : const AssetImage("assets/images/boy.png")) as ImageProvider)
                      : null,

                  child: _isLoading
                      ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.grey,
                    ),
                  )
                      : null,
                ),
              ),


              // InkWell(
              //   onTap: _pickImage,
              //   child:CircleAvatar(
              //     radius: 55,
              //     backgroundImage: _profileImage != null
              //         ? FileImage(_profileImage!)
              //         : (profileImageUrl != null && profileImageUrl!.isNotEmpty
              //         ? NetworkImage(profileImageUrl!)
              //         : const AssetImage("assets/images/boy.png")) as ImageProvider,
              //   )
              // ),
              const SizedBox(height: 5),
              Text(
                'edit_picture'.tr(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration:
      BoxDecoration(color: isDarkMode ? Colors.black : Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildInputField(title: "Name", controller: fullNameController),
              const SizedBox(height: 20),
              _buildInputField(
                title: "email".tr(),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              _buildInputField(
                title: "phone_number".tr(),
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 18),
              _buildGenderDropdown(title: "gender".tr()),
              SizedBox(height: 18),
              _buildCurrencyDropdown(title: "currency".tr()),
              const SizedBox(height: 25),
              _buildSaveButton(context, isDarkMode),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String title,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String hintText="";
    if(title=="Name"){
      hintText=name;
    }if(title=="Email"){
      hintText=email;
    }if(title=="Phone number"){
      hintText=phone.length >= 10
          ? "${phone.substring(0,3)} ${phone.substring(3,6)} ${phone.substring(6)}"
          : phone;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 5),
          child: Text(
            title,
            style: TextStyle(
              color: isDarkMode? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color:isDarkMode?Theme.of(context).scaffoldBackgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(

            controller: controller,
            obscureText: obscureText,

            keyboardType: keyboardType,
            decoration:  InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isDarkMode) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .4,
      height: MediaQuery.of(context).size.height * .055,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode
              ? const Color(0xFFD44D5C)
              : Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          'save'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  Widget _buildGenderDropdown({required String title}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 5),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.primary.withOpacity(.1),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedGender, // can be null
            icon: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey[800],
              ),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.people_outline,
                color: isDarkMode
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                size: 22.w,
              ),
              border: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
            hint: Text(
              "select_gender".tr(),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),

            /// Logic value = English
            /// UI text = localized
            items: const ["Male", "Female", "Other"].map((gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(
                  gender.toLowerCase().tr(),
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),

            // ❌ no validator → optional
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
        ),
      ],
    );
  }





  Widget _buildCurrencyDropdown({required String title}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FormField<String>(
      validator: null, // ✅ currency optional
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 5),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).colorScheme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: InkWell(
                onTap: () {
                  showCurrencyPicker(
                    context: context,
                    showFlag: true,
                    showCurrencyName: true,
                    showCurrencyCode: true,
                    onSelect: (Currency currency) async {
                      setState(() {
                        _selectedCurrency = currency;
                        _selectedCurrencySymbol = currency.symbol;
                      });

                      // 🔹 Save to SharedPreferences
                      await SharedPreferenceMethods()
                          .saveUserCurrency(currency.symbol);

                      // 🔥 Notify whole app instantly
                      //////////////////////////////////
                      //////////////////////////////////
                      ///////////////////////////
                      //CurrencyNotifier.currency.value = currency.symbol;

                      context.read<CurrencyNotifier>().updateCurrency(currency.symbol);



                      field.didChange(currency.symbol);
                    },

                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        color: isDarkMode
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _selectedCurrency == null
                              ? "select_currency".tr()
                              : "${countryCodeToEmoji(_selectedCurrency!.code.substring(0, 2))}  ${_selectedCurrency!.code} - ${_selectedCurrency!.name}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: _selectedCurrency == null
                                ? (isDarkMode
                                ? Colors.white
                                : Colors.grey[600])
                                : (isDarkMode
                                ? Colors.white
                                : Colors.black),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Colors.grey[800]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
