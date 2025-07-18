import 'package:flutter/material.dart';

/// App color palette for Digi Gold theme
class AppColors {
  // Primary Gold Colors
  static const Color primaryGold = Color(0xFFFFD700); // Gold
  static const Color lightGold = Color(0xFFFFF8DC); // Cornsilk
  static const Color darkGold = Color(0xFFB8860B); // Dark Goldenrod
  static const Color champagne = Color(0xFFF7E7CE); // Light champagne
  
  // Dark Green Colors
  static const Color primaryGreen = Color(0xFF006400); // Dark Green
  static const Color lightGreen = Color(0xFF228B22); // Forest Green
  static const Color darkGreen = Color(0xFF013220); // Very Dark Green
  static const Color emerald = Color(0xFF50C878); // Emerald Green
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGold = Color(0xFFB8860B);
  
  // Gradient Colors
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD700),
      Color(0xFFFFA500),
      Color(0xFFB8860B),
    ],
  );
  
  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF228B22),
      Color(0xFF006400),
      Color(0xFF013220),
    ],
  );
  
  static const LinearGradient goldGreenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD700),
      Color(0xFF228B22),
      Color(0xFF006400),
    ],
  );
}
