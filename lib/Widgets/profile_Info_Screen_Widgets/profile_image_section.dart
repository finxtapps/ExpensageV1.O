import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providerListner/profile_notifier.dart';
import '../../shared_prefrence/SharedPrefrenceMethods.dart';

class ProfileImageSection extends StatefulWidget {
  final String title;
 // final File? imageFile;

  const ProfileImageSection({
    super.key,
    required this.title,
  //  this.imageFile,
  });

  @override
  State<ProfileImageSection> createState() => _ProfileImageSectionState();
}

class _ProfileImageSectionState extends State<ProfileImageSection> {

  Uint8List? _image;
  bool _isLoading = true;
  String? profileImage;

  String name = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    final _userName = await SharedPreferenceMethods().getUserName();
    final img = await SharedPreferenceMethods().getUserImageFilename();

    setState(() {
      name = _userName ?? "";
      profileImage = img;
      _isLoading = false; // ⭐ important
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? const Color(0xFFD44D5C) : Colors.white,
                width: 3,
              ),
            ),
            child:Consumer<ProfileNotifier>(
              builder: (context, profile, child) {
                return ClipOval(
                  child: Image(
                    image: profile.profileImageProvider,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                );
              },
            )
          ),

          const SizedBox(height: 5),

          Text(
            name.isEmpty ? "User Name" : name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


