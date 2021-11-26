import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryColor)),
      textTheme: Theme.of(context).textTheme);

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
          color: Colors.black, iconTheme: IconThemeData(color: Colors.white)));

  static Color creamColor = const Color(0xfff5f5f5);
  static Color darkBlusishColor = const Color(0xff403b58);

  static Color primaryColor = const Color(0xff2F58E2);
  static Color bgColor = const Color(0xff2F58E2);
  static Color greyColor = const Color(0xffA2A3B9);
  static Color greenColor = const Color(0xff1AFF00);
  static Color redColor = const Color(0xffFF006F);
}
