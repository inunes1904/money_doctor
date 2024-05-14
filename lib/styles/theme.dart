import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneydoctor/styles/global.colors.dart';

class AppTheme {
  const AppTheme();
  static final ThemeData appTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: GlobalColors.backgroundColor,
    drawerTheme: const DrawerThemeData(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    brightness: Brightness.light,
    primaryColor: GlobalColors.primaryColor,
    cardColor: GlobalColors.white,
    canvasColor: GlobalColors.white,
    popupMenuTheme: const PopupMenuThemeData().copyWith(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: const CardTheme().copyWith(
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: GlobalColors.primaryColor,
        foregroundColor: GlobalColors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    ),
    dividerColor: GlobalColors.lightGrey,
    unselectedWidgetColor: GlobalColors.grey,
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: GlobalColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)))),
    appBarTheme: AppBarTheme(
      //backgroundColor: GlobalColors.white,
      backgroundColor: GlobalColors.navbarColor,
      titleTextStyle: const TextStyle(
        fontSize: 14,
        color: GlobalColors.textColor,
      ).apply(fontFamily: GoogleFonts.montserrat().fontFamily),
      iconTheme: const IconThemeData(
        color: GlobalColors.white,
      ),
      elevation: 0,
    ),
    bottomAppBarTheme: ThemeData.light().bottomAppBarTheme.copyWith(
          color: GlobalColors.white,
          elevation: 0,
        ),
    tabBarTheme: const TabBarTheme(
      labelStyle: TextStyle(color: GlobalColors.navbarColor),
      unselectedLabelColor: GlobalColors.darkgrey,
      unselectedLabelStyle: TextStyle(color: GlobalColors.darkgrey),
      labelColor: GlobalColors.primaryColor, // Adjusted to match pearl theme
      labelPadding: EdgeInsets.symmetric(vertical: 12),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: GlobalColors.primaryColor, // Adjusted to match pearl theme
        shape: CircleBorder()),
    iconTheme: const IconThemeData(
      color: GlobalColors.grey,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: GlobalColors.lightestGrey,
    ),
    dialogTheme: const DialogTheme(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)))),
    listTileTheme: ListTileThemeData(
        textColor: GlobalColors.black,
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.montserrat().fontFamily,
        )),
    datePickerTheme: const DatePickerThemeData(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      headerBackgroundColor: GlobalColors.navbarColor,
      headerForegroundColor: GlobalColors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 26,
        color: GlobalColors.mainColor,
        fontWeight: FontWeight.bold,
      ),

      // default inputs (Flutter) -> evitar utilizar
      titleMedium: TextStyle(
        fontSize: 14,
        color: GlobalColors.textColor,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        color: GlobalColors.mainColor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 20,
        color: GlobalColors.textColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 16,
        color: GlobalColors.textColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 12,
        color: GlobalColors.textColor,
        fontWeight: FontWeight.bold,
      ),
      displayLarge: TextStyle(
        fontSize: 16,
        color: GlobalColors.primaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: 14,
        color: GlobalColors.primaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: 12,
        color: GlobalColors.primaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: GlobalColors.textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: GlobalColors.textColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: GlobalColors.textColor,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        color: GlobalColors.textColor,
      ), // cor de label de Filterchip
      labelMedium: TextStyle(
        fontSize: 14,
        color: GlobalColors.primaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        color: GlobalColors.dangerColor,
      ),
    ).apply(fontFamily: GoogleFonts.montserrat().fontFamily),
    colorScheme: const ColorScheme(
      background: GlobalColors.white,
      onPrimary: GlobalColors.white,
      onBackground: GlobalColors.lightGrey, // underline menu
      onError: GlobalColors.white,
      onSecondary: GlobalColors.white,
      onSurface: GlobalColors.darkgrey, // icons
      error: GlobalColors.dangerColor,
      primary: GlobalColors.primaryColor, // Adjusted to match pearl theme
      primaryContainer: GlobalColors.mainColor,
      secondary: GlobalColors.secondaryColor,
      secondaryContainer: GlobalColors.darkgrey,
      surface: GlobalColors.white,
      brightness: Brightness.light,
      outline: GlobalColors.grey, // border inputs
    ),
  );
}
