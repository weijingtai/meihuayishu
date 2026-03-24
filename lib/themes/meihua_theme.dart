import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:common/app_colors.dart';

/// 梅花易数中国风主题
class MeiHuaTheme {
  // 使用 common 中的颜色
  static Color get primaryColor => const Color(0xFF2A9D8F);
  static Color get backgroundColor => AppColors.backgroundLight;
  static Color get surfaceColor => Colors.white;
  static Color get textColor => AppColors.textPrimaryLight;
  static Color get secondaryTextColor => AppColors.textSecondaryLight;

  // 中国传统色
  static const Color paperWhite = Color(0xFFF7F5F0);      // 宣纸白
  static const Color inkBlack = Color(0xFF2C2C2C);        // 墨黑
  static const Color cinnabarRed = Color(0xFFE63946);     // 朱砂红
  static const Color jadeGreen = Color(0xFF2A9D8F);       // 翠绿
  static const Color goldYellow = Color(0xFFF4A261);      // 金黄
  static const Color skyBlue = Color(0xFF457B9D);         // 天青

  /// 获取亮色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: jadeGreen,
        secondary: cinnabarRed,
        surface: paperWhite,
        onSurface: inkBlack,
      ),
      scaffoldBackgroundColor: paperWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: paperWhite,
        foregroundColor: inkBlack,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansSc(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: inkBlack,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: jadeGreen,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.notoSansSc(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: inkBlack,
          textStyle: GoogleFonts.notoSansSc(
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: GoogleFonts.notoSansScTextTheme(),
    );
  }

  /// 获取暗色主题
  static ThemeData get darkTheme {
    const darkSurface = Color(0xFF2A2A2A);
    const darkBackground = Color(0xFF1A1A1A);
    const darkText = Color(0xFFEFEFEF);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: jadeGreen,
        secondary: cinnabarRed,
        surface: darkSurface,
        onSurface: darkText,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkText,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansSc(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
      ),
      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: jadeGreen,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.notoSansSc(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkText,
          textStyle: GoogleFonts.notoSansSc(
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: GoogleFonts.notoSansScTextTheme(ThemeData.dark().textTheme),
    );
  }
}
