import 'package:flutter/material.dart';

// Updated seed color to match the blue from the app images
const Color _seedColor = Color(0xFF007AFF);

@immutable
class MaterialColors extends ThemeExtension<MaterialColors> {
  const MaterialColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  @override
  MaterialColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return MaterialColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  MaterialColors lerp(covariant MaterialColors? other, double t) {
    if (other is! MaterialColors) return this;
    
    return MaterialColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
    );
  }

  static const light = MaterialColors(
    success: Color(0xFF146C2E),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFA6F2A6),
    onSuccessContainer: Color(0xFF002204),
    warning: Color(0xFFFF9500),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFE5B4),
    onWarningContainer: Color(0xFF332600),
    info: Color(0xFF007AFF),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFD1E4FF),
    onInfoContainer: Color(0xFF001D36),
  );

  static const dark = MaterialColors(
    success: Color(0xFF8BD68B),
    onSuccess: Color(0xFF003A0B),
    successContainer: Color(0xFF00531C),
    onSuccessContainer: Color(0xFFA6F2A6),
    warning: Color(0xFFFFB366),
    onWarning: Color(0xFF4A2800),
    warningContainer: Color(0xFFCC7A00),
    onWarningContainer: Color(0xFFFFE5B4),
    info: Color(0xFF66B3FF),
    onInfo: Color(0xFF003258),
    infoContainer: Color(0xFF005299),
    onInfoContainer: Color(0xFFD1E4FF),
  );
}

final ThemeData materialLightTheme = ThemeData(
  useMaterial3: true,
  
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
    // Light blue-tinted backgrounds matching the app images
    surface: const Color(0xFFF7FAFC),
    onSurface: const Color(0xFF1C1C1E),
    surfaceVariant: const Color(0xFFEDF2F7),
    onSurfaceVariant: const Color(0xFF48484A),
    surfaceContainerLowest: const Color(0xFFFFFFFF),
    surfaceContainerLow: const Color(0xFFF9FBFC),
    surfaceContainer: const Color(0xFFF2F6F9),
    surfaceContainerHigh: const Color(0xFFEBF1F5),
    surfaceContainerHighest: const Color(0xFFE2EBF0),
    outline: const Color(0xFFC7C7CC),
    outlineVariant: const Color(0xFFD1D1D6),
    scrim: const Color(0xFF000000),
    // Blue accent colors matching the app
    primary: const Color(0xFF007AFF),
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: const Color(0xFFD1E4FF),
    onPrimaryContainer: const Color(0xFF001D36),
    secondary: const Color(0xFF5A5A5A),
    onSecondary: const Color(0xFFFFFFFF),
    secondaryContainer: const Color(0xFFE8E8E8),
    onSecondaryContainer: const Color(0xFF1A1A1A),
    // Warm beige for special containers (like AI insights)
    tertiary: const Color(0xFFB8860B),
    onTertiary: const Color(0xFFFFFFFF),
    tertiaryContainer: const Color(0xFFF5E6D3),
    onTertiaryContainer: const Color(0xFF2E1500),
    // Inverse colors
    inverseSurface: const Color(0xFF1A1A1A),
    onInverseSurface: const Color(0xFFF7FAFC),
    inversePrimary: const Color(0xFF66B3FF),
    // Error colors
    error: const Color(0xFFFF3B30),
    onError: const Color(0xFFFFFFFF),
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF410002),
  ),
  
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.50,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: Color(0xFF666666),
      fontFamily: 'Inter',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: Color(0xFF666666),
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: Color(0xFF999999),
      fontFamily: 'Inter',
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: Color(0xFF666666),
      fontFamily: 'Inter',
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: Color(0xFF666666),
      fontFamily: 'Inter',
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: Color(0xFF999999),
      fontFamily: 'Inter',
    ),
  ),
  
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(64, 40),
      maximumSize: const Size.fromHeight(40),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: const Color(0xFF007AFF),
      foregroundColor: const Color(0xFFFFFFFF),
    ),
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(64, 40),
      maximumSize: const Size.fromHeight(40),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: const Color(0xFFFFFFFF),
      foregroundColor: const Color(0xFF007AFF),
      side: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(64, 40),
      maximumSize: const Size.fromHeight(40),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: const BorderSide(color: Color(0xFF007AFF)),
      foregroundColor: const Color(0xFF007AFF),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(48, 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      foregroundColor: const Color(0xFF007AFF),
    ),
  ),
  
  cardTheme: const CardThemeData(
    elevation: 0,
    color: Color(0xFFFFFFFF),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(color: Color(0xFFF0F0F0), width: 1),
    ),
  ),
  
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleSpacing: 16,
    backgroundColor: Color(0xFFF7FAFC),
    surfaceTintColor: Colors.transparent,
    foregroundColor: Color(0xFF000000),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF000000),
      fontFamily: 'Inter',
    ),
  ),
  
  navigationBarTheme: const NavigationBarThemeData(
    height: 80,
    elevation: 0,
    backgroundColor: Color(0xFFF7FAFC),
    surfaceTintColor: Colors.transparent,
    indicatorColor: Color(0xFFD1E4FF),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  
  navigationDrawerTheme: const NavigationDrawerThemeData(
    elevation: 0,
    backgroundColor: Color(0xFFF7FAFC),
    surfaceTintColor: Colors.transparent,
  ),
  
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFEDF2F7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFF007AFF), width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  
  chipTheme: const ChipThemeData(
    side: BorderSide.none,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    backgroundColor: Color(0xFFEDF2F7),
    selectedColor: Color(0xFF007AFF),
    labelStyle: TextStyle(color: Color(0xFF666666)),
  ),
  
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 2,
    focusElevation: 4,
    hoverElevation: 4,
    highlightElevation: 6,
    backgroundColor: Color(0xFF007AFF),
    foregroundColor: Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  
  dialogTheme: const DialogThemeData(
    elevation: 8,
    backgroundColor: Color(0xFFF7FAFC),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  
  bottomSheetTheme: const BottomSheetThemeData(
    elevation: 8,
    backgroundColor: Color(0xFFF7FAFC),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
  
  menuTheme: const MenuThemeData(
    style: MenuStyle(
      elevation: WidgetStatePropertyAll(4),
      backgroundColor: WidgetStatePropertyAll(Color(0xFFF7FAFC)),
      surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),
  ),
  
  dividerTheme: const DividerThemeData(
    thickness: 1,
    space: 1,
    color: Color(0xFFE0E0E0),
  ),
  
  extensions: const <ThemeExtension<dynamic>>[
    MaterialColors.light,
  ],
);

final ThemeData materialDarkTheme = ThemeData(
  useMaterial3: true,
  
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
    surface: const Color(0xFF1A1A1A),
    onSurface: const Color(0xFFFFFFFF),
    surfaceVariant: const Color(0xFF2D2D2D),
    onSurfaceVariant: const Color(0xFFBBBBBB),
    surfaceContainerLowest: const Color(0xFF0F0F0F),
    surfaceContainerLow: const Color(0xFF1A1A1A),
    surfaceContainer: const Color(0xFF242424),
    surfaceContainerHigh: const Color(0xFF2D2D2D),
    surfaceContainerHighest: const Color(0xFF383838),
    outline: const Color(0xFF666666),
    outlineVariant: const Color(0xFF444444),
    inverseSurface: const Color(0xFFFFFFFF),
    onInverseSurface: const Color(0xFF1A1A1A),
    inversePrimary: const Color(0xFF007AFF),
    primary: const Color(0xFF66B3FF),
    onPrimary: const Color(0xFF000000),
    primaryContainer: const Color(0xFF003D6B),
    onPrimaryContainer: const Color(0xFFD1E4FF),
    secondary: const Color(0xFFBBBBBB),
    onSecondary: const Color(0xFF000000),
    secondaryContainer: const Color(0xFF444444),
    onSecondaryContainer: const Color(0xFFE0E0E0),
    tertiary: const Color(0xFFD4A574),
    onTertiary: const Color(0xFF2E1500),
    tertiaryContainer: const Color(0xFF5A4A3A),
    onTertiaryContainer: const Color(0xFFF5E6D3),
    error: const Color(0xFFFF6B6B),
    onError: const Color(0xFF000000),
    errorContainer: const Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
  ),
  
  // Copy most theme configurations from light theme but adjust colors
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(64, 40),
      maximumSize: const Size.fromHeight(40),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: const Color(0xFF66B3FF),
      foregroundColor: const Color(0xFF000000),
    ),
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(64, 40),
      maximumSize: const Size.fromHeight(40),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: const Color(0xFF2D2D2D),
      foregroundColor: const Color(0xFF66B3FF),
      side: const BorderSide(color: Color(0xFF444444)),
    ),
  ),
  
  cardTheme: const CardThemeData(
    elevation: 0,
    color: Color(0xFF242424),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(color: Color(0xFF444444), width: 1),
    ),
  ),
  
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleSpacing: 16,
    backgroundColor: Color(0xFF1A1A1A),
    surfaceTintColor: Colors.transparent,
    foregroundColor: Color(0xFFFFFFFF),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFFFFFF),
    ),
  ),
  
  navigationBarTheme: const NavigationBarThemeData(
    height: 80,
    elevation: 0,
    backgroundColor: Color(0xFF1A1A1A),
    surfaceTintColor: Colors.transparent,
    indicatorColor: Color(0xFF003D6B),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),
  
  // Inherit other theme configurations from light theme
  outlinedButtonTheme: materialLightTheme.outlinedButtonTheme,
  textButtonTheme: materialLightTheme.textButtonTheme,
  navigationDrawerTheme: materialLightTheme.navigationDrawerTheme,
  inputDecorationTheme: materialLightTheme.inputDecorationTheme,
  chipTheme: materialLightTheme.chipTheme,
  floatingActionButtonTheme: materialLightTheme.floatingActionButtonTheme,
  dialogTheme: materialLightTheme.dialogTheme,
  bottomSheetTheme: materialLightTheme.bottomSheetTheme,
  menuTheme: materialLightTheme.menuTheme,
  dividerTheme: materialLightTheme.dividerTheme,
  
  extensions: const <ThemeExtension<dynamic>>[
    MaterialColors.dark,
  ],
);