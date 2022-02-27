import 'package:flutter/material.dart';
import 'package:ourpass/config/constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get _baseTheme => ThemeData(
        primaryColor: AppColors.kPrimary,
        scaffoldBackgroundColor: AppColors.kScaffold,
        fontFamily: Fonts.kPrimary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: const RoundedRectangleBorder(borderRadius: Corners.lgBorder),
            primary: AppColors.kPrimary,
            onPrimary: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.kDark,
          selectedItemColor: AppColors.kScaffold,
          unselectedItemColor: AppColors.kGrey,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        iconTheme: IconThemeData(
          color: AppColors.kGrey,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      );

  static ThemeData get defaultTheme =>
      _baseTheme.copyWith(brightness: Brightness.light);
}

class Fonts {
  static const kPrimary = "Inter";
}

class Insets {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 32;
}

class Corners {
  static const Radius smRadius = Radius.circular(Insets.sm);
  static const BorderRadius smBorder = BorderRadius.all(smRadius);

  static const Radius mdRadius = Radius.circular(Insets.md);
  static const BorderRadius mdBorder = BorderRadius.all(mdRadius);

  static const Radius lgRadius = Radius.circular(Insets.lg);
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);
}

class FontSizes {
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;
}

class IconSizes {
  static const double sm = 18;
  static const double md = 24;
  static const double lg = 32;
}
