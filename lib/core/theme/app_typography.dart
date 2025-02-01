import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      color: AppColors.lightText,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: AppColors.lightText,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
    ),
  );

  // static TextTheme darkTextTheme = TextTheme(
  //   displayLarge: GoogleFonts.poppins(
  //     fontSize: 32,
  //     fontWeight: FontWeight.bold,
  //     color: AppColors.darkText,
  //   ),
  //   displayMedium: GoogleFonts.poppins(
  //     fontSize: 28,
  //     fontWeight: FontWeight.bold,
  //     color: AppColors.darkText,
  //   ),
  //   displaySmall: GoogleFonts.poppins(
  //     fontSize: 24,
  //     fontWeight: FontWeight.w600,
  //     color: AppColors.darkText,
  //   ),
  //   headlineMedium: GoogleFonts.poppins(
  //     fontSize: 20,
  //     fontWeight: FontWeight.w600,
  //     color: AppColors.darkText,
  //   ),
  //   titleLarge: GoogleFonts.poppins(
  //     fontSize: 18,
  //     fontWeight: FontWeight.w600,
  //     color: AppColors.darkText,
  //   ),
  //   bodyLarge: GoogleFonts.poppins(
  //     fontSize: 16,
  //     color: AppColors.darkText,
  //   ),
  //   bodyMedium: GoogleFonts.poppins(
  //     fontSize: 14,
  //     color: AppColors.darkText,
  //   ),
  //   labelLarge: GoogleFonts.poppins(
  //     fontSize: 14,
  //     fontWeight: FontWeight.w600,
  //     color: AppColors.darkText,
  //   ),
  // );
}
