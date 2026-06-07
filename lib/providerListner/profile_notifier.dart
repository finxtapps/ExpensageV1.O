import 'dart:io';
import 'package:flutter/material.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';

class ProfileNotifier extends ChangeNotifier {

  String? profileImage;
  String name = "";

  final SharedPreferenceMethods _prefs = SharedPreferenceMethods();

  /// LOAD USER DATA FROM SHARED PREF
  Future<void> loadProfile() async {

    final img = await _prefs.getUserImageFilename();
    final userName = await _prefs.getUserName();

    profileImage = img;
    name = userName ?? "";

    notifyListeners();
  }

  /// UPDATE PROFILE IMAGE (FROM GALLERY / CAMERA)
  Future<void> updateProfileImage(String imagePath) async {

    profileImage = imagePath;

    await _prefs.saveUserImageFilename(imagePath);

    notifyListeners();
  }

  /// UPDATE IMAGE FROM API LOGIN
  Future<void> updateProfileImageFromApi(String imageUrl) async {

    profileImage = imageUrl;

    await _prefs.saveUserImageFilename(imageUrl);

    notifyListeners();
  }

  /// AUTO IMAGE PROVIDER (FILE / NETWORK / ASSET)
  ImageProvider get profileImageProvider {

    if (profileImage == null || profileImage!.isEmpty) {
      return const AssetImage('assets/images/boy.png');
    }

    /// API IMAGE
    if (profileImage!.startsWith("http")) {
      return NetworkImage(profileImage!);
    }

    /// LOCAL FILE IMAGE
    return FileImage(File(profileImage!));
  }

}