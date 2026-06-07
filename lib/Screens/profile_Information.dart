import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../Widgets/profile_Info_Screen_Widgets/header_section.dart';
import '../Widgets/profile_Info_Screen_Widgets/menu_item.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import 'custom_popUp_Screen.dart';


class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {


  Future<void> _handleLogout(BuildContext context) async {
    final SharedPreferenceMethods _prefs = SharedPreferenceMethods();

    await _prefs.clearAllPrefs(); // clears all saved user info & login flag

    // Snackbar dikhao
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log out Successful')),
    );

    // Navigate to LandingPage
    Navigator.pushNamedAndRemoveUntil(context, "/landingpage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(

        child: Container(
          color: isDarkMode? Colors.black:Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              SizedBox(

                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ProfileHeaderSection(onBackPressed: () => Navigator.pop(context)),
                              SizedBox(
                                height: 5,
                              ),

                              Padding(
                                padding: EdgeInsets.only(

                                    top:MediaQuery.of(context).size.height * 0.265,
                                    left: MediaQuery.of(context).size.width * 0.09,
                                    right: MediaQuery.of(context).size.width * 0.09,
                                ),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.45,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDarkMode? Colors.black:Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.black,width: 1)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Column(
                                        children: [
                                           SizedBox(height:MediaQuery.of(context).size.height * 0.025),

                                             MenuItem(
                                              icon: Icons.person,
                                              title: 'personal_information'.tr(),
                                              onTap: () {
                                                Navigator.pushNamed(context, '/personal');
                                              },
                                            ),

                                          const SizedBox(height: 20),
                                          MenuItem(
                                            icon: Icons.diamond,
                                            title: 'invite_friends'.tr(),
                                            onTap: () {

                                              CustomPopup.show(
                                                context: context,
                                                title: "Coming Soon",
                                                message: "This feature is currently under development and will be available soon.",
                                              );

                                              // ScaffoldMessenger.of(context).showSnackBar(
                                              //   const SnackBar(content: Text('Invite friends tapped')),
                                              // );
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          MenuItem(
                                            icon: Icons.people,
                                            title: 'rate_us'.tr(),
                                            onTap: () {
                                              CustomPopup.show(
                                                context: context,
                                                title: "Coming Soon",
                                                message: "This feature is currently under development and will be available soon.",
                                              );

                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          MenuItem(
                                            icon: Icons.logout,
                                            title: 'log_out'.tr(),
                                            onTap: () {

                                              _handleLogout(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                   // BottomNavBar(selectedIndex: selectedIndex),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


















//
//
//
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../Api_Models/profile_model.dart';
// import '../Api_Services/profile_service.dart';
// import '../Widgets/profile_Info_Screen_Widgets/header_section.dart';
// import '../Widgets/profile_Info_Screen_Widgets/menu_item.dart';
//
// class ProfileInfoScreen extends StatefulWidget {
//   const ProfileInfoScreen({super.key});
//
//   @override
//   State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
// }
//
// class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
//   final ProfileService _service = ProfileService();
//   ProfileModel? _profile;
//   bool _isLoading = true;
//   String? _error;
//
//   // Replace this with your actual token management
//   final String _token = 'your_jwt_token_here';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }
//
//   Future<void> _loadProfile() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//
//     final result = await _service.fetchUserProfile(_token);
//     if (result != null) {
//       setState(() {
//         _profile = result;
//         _isLoading = false;
//       });
//     } else {
//       setState(() {
//         _error = 'Failed to load profile.';
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       body: SafeArea(
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _error != null
//             ? Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(_error!, style: const TextStyle(color: Colors.red)),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _loadProfile,
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         )
//             : SingleChildScrollView(
//           child: Container(
//             color: isDarkMode
//                 ? Colors.black
//                 : Theme.of(context).scaffoldBackgroundColor,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Stack(
//                               children: [
//                                 ProfileHeaderSection(
//                                   onBackPressed: () =>
//                                       Navigator.pop(context),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context)
//                                         .size
//                                         .height *
//                                         0.265,
//                                     left: MediaQuery.of(context)
//                                         .size
//                                         .width *
//                                         0.09,
//                                     right: MediaQuery.of(context)
//                                         .size
//                                         .width *
//                                         0.09,
//                                   ),
//                                   child: SizedBox(
//                                     height: MediaQuery.of(context)
//                                         .size
//                                         .height *
//                                         0.45,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: isDarkMode
//                                             ? Colors.black
//                                             : Colors.white,
//                                         borderRadius:
//                                         BorderRadius.circular(30),
//                                         border: Border.all(
//                                             color: Colors.black,
//                                             width: 1),
//                                       ),
//                                       child: Padding(
//                                         padding:
//                                         const EdgeInsets.all(30),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment
//                                               .center,
//                                           children: [
//                                             CircleAvatar(
//                                               radius: 40,
//                                               backgroundImage:
//                                               _profile!.profilePic
//                                                   .isNotEmpty
//                                                   ? NetworkImage(
//                                                   _profile!
//                                                       .profilePic)
//                                                   : null,
//                                               child: _profile!
//                                                   .profilePic
//                                                   .isEmpty
//                                                   ? const Icon(
//                                                 Icons.person,
//                                                 size: 40,
//                                               )
//                                                   : null,
//                                             ),
//                                             const SizedBox(height: 12),
//                                             Text(
//                                               _profile!.name,
//                                               style: const TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight:
//                                                   FontWeight.bold),
//                                             ),
//                                             Text(
//                                               _profile!.email,
//                                               style: const TextStyle(
//                                                   color: Colors.grey),
//                                             ),
//                                             Text(
//                                               _profile!.phone,
//                                               style: const TextStyle(
//                                                   color: Colors.grey),
//                                             ),
//                                             const SizedBox(height: 25),
//
//                                             /// Menu Items
//                                             MenuItem(
//                                               icon: Icons.person,
//                                               title:
//                                               'Personal Information',
//                                               onTap: () {
//                                                 Navigator.pushNamed(
//                                                     context,
//                                                     '/personal');
//                                               },
//                                             ),
//                                             const SizedBox(height: 20),
//                                             MenuItem(
//                                               icon: Icons.diamond,
//                                               title: 'Invite friends',
//                                               onTap: () {
//                                                 ScaffoldMessenger.of(
//                                                     context)
//                                                     .showSnackBar(
//                                                   const SnackBar(
//                                                     content: Text(
//                                                         'Invite friends tapped'),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             const SizedBox(height: 20),
//                                             MenuItem(
//                                               icon: Icons.people,
//                                               title: 'Rate us',
//                                               onTap: () {
//                                                 ScaffoldMessenger.of(
//                                                     context)
//                                                     .showSnackBar(
//                                                   const SnackBar(
//                                                     content: Text(
//                                                         'Rate us tapped'),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             const SizedBox(height: 20),
//                                             MenuItem(
//                                               icon: Icons.logout,
//                                               title: 'Log out',
//                                               onTap: () {
//                                                 ScaffoldMessenger.of(
//                                                     context)
//                                                     .showSnackBar(
//                                                   const SnackBar(
//                                                     content: Text(
//                                                         'Log out tapped'),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

