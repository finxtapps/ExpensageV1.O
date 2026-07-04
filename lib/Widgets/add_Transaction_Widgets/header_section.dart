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


