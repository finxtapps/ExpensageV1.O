import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final VoidCallback onBackPressed;

  const HeaderSection({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity, // Use double.infinity for full width
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:isDarkMode?[
            Colors.black,
            Colors.black
          ]: [
            Theme.of(context).colorScheme.primary.withOpacity(.9),
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.35,top:30),
            child: SizedBox(
              child: Image.asset("assets/images/header-Image/headerImage.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*.48),
            child: SizedBox(
              child: Image.asset("assets/images/header-Image/headerImage.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*.8,top: 80),
            child: SizedBox(
              child: Image.asset("assets/images/header-Image/headerImage.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onBackPressed,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                  ),
                   SizedBox(
                     height: MediaQuery.of(context).size.height*.05,
                   ),
                   Center(
                    child: Text(
                      'add_transaction'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}













//
// import 'package:flutter/material.dart';
//
// class HeaderSection extends StatelessWidget {
//   final VoidCallback onBackPressed;
//
//   const HeaderSection({super.key, required this.onBackPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.height * .55,
//           height: 300,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Theme.of(context).colorScheme.primary.withOpacity(.6),
//                 Theme.of(context).colorScheme.secondary,
//               ],
//             ),
//             borderRadius:  BorderRadius.only(
//               bottomLeft: Radius.circular(80),
//               bottomRight: Radius.circular(80),
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: onBackPressed,
//                     child: const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(Icons.arrow_back, color: Colors.white, size: 28),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Center(
//                     child: Text(
//                       'Add transaction',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 32,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//






































// import 'package:flutter/material.dart';
//
// class HeaderSection extends StatelessWidget {
//   final VoidCallback onBackPressed;
//
//   const HeaderSection({Key? key, required this.onBackPressed}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.height * .45,
//           height: 300,
//           decoration:  BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Theme.of(context).colorScheme.primary.withOpacity(.6),
//                 Theme.of(context).colorScheme.secondary,
//
//               ],
//             ),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(80),
//               bottomRight: Radius.circular(80),
//             ),
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 60,
//                 right: -30,
//                 child: Container(
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.1),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 140,
//                 right: 60,
//                 child: Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.06),
//                   ),
//                 ),
//               ),
//               SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: onBackPressed,
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           child: const Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                             size: 28,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Center(
//                         child: const Text(
//                           'Add transaction',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 32,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }