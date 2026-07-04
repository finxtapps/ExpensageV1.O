import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../component/customHeader.dart';
import '../theme/header_Color.dart';
import '../providerListner/theme_notifier.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    // Get all countries from country_picker package
    allCountries = CountryService().getAll();
    filteredCountries = allCountries;
  }

  void filterCountries(String query) {
    setState(() {
      filteredCountries = allCountries
          .where((country) =>
      country.name.toLowerCase().contains(query.toLowerCase()) ||
          country.countryCode
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          country.phoneCode.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient:
              themeProvider.currentTheme == 'Pink'
                  ? HeaderColor.pinkGradient
                  : themeProvider.currentTheme == 'Teal'
                  ? HeaderColor.greenGradient
                  : themeProvider.currentTheme == 'Blue'
                  ? HeaderColor.blueGradient
                  : themeProvider.currentTheme == 'Orange'
                  ? HeaderColor.orangeGradient
                  : HeaderColor.darkGradient,
              borderRadius:  BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
            child: SafeArea(
              top: false,
              child:CustomHeader(title: 'location'.tr(),),

            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "select_your_current_location".tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              "sms_registration_confirmation".tr(),
              // "We require your area code and location for SMS registration confirmation.",
              style: TextStyle(color:isDarkMode?Colors.black: Colors.grey[600], fontSize:isDarkMode?1: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "find_your_country".tr(),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color:Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: filterCountries,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    leading: Text(country.flagEmoji, style: TextStyle(fontSize: 24)),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: country.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:isDarkMode?Colors.white: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Radio<Country>(
                      value: country,
                      groupValue: selectedCountry,
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                  ),



                );
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(10),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width*.4,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:isDarkMode?Color(0xFFD44D5C) :Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 3),
                  ),
                  onPressed: () {
                    if (selectedCountry != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                            Text("Selected: ${selectedCountry!.name}")),
                      );
                    }
                  },
                  child: Text("save".tr(), style: TextStyle(fontSize: 18,color:Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
