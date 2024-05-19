import 'package:flutter/material.dart';

var cardTitleStyle = const TextStyle(fontWeight: FontWeight.bold);

var colorScheme = const ColorScheme(
  brightness: Brightness.light,
  /*primary Colors.orange*/
  primary: Color(0xffE89907),
  onPrimary: Color(0xffFFFAF2),
  primaryContainer: Color(0xFFFCF0DA),
  onPrimaryContainer: Color(0xFF410001),
  /*secondary Colors.orangeAccent*/
  secondary: Color(0xffF9E1B6),
  onSecondary: Color(0xff231702),
  secondaryContainer: Color(0xFFFAD694),
  onSecondaryContainer: Color(0xff2c1512),
  /*tertiary - contrast */
  tertiary: Color(0xffA782FF),
  onTertiary: Color(0xffCFBFF6),
  tertiaryContainer: Color(0xff623CBD),
  onTertiaryContainer: Color(0xff30039C),
  /*error*/
  error: Color(0xFFba1a1a),
  onError: Colors.white,
  errorContainer: Color(0xfffdd9d7),
  onErrorContainer: Color(0xff231702),
  background: Color.fromARGB(255, 255, 253, 251),
  onBackground: Color(0xff231702),
  /*surface*/
  surface: Color(0xffF4F4F4),
  surfaceVariant: Color(0xFFFAFAFA),
  onSurface: Color(0xff231702),
  surfaceTint: Color(0xffE89907),
);

var colorSchemeDark = const ColorScheme(
  brightness: Brightness.light,
  /*primary Colors.orange*/
  primary: Color(0xffE89907),
  onPrimary: Colors.white,
  primaryContainer: Color.fromARGB(255, 43, 28, 2),
  onPrimaryContainer: Colors.white,
  /*secondary Colors.orangeAccent*/
  secondary: Color.fromARGB(255, 164, 110, 10),
  onSecondary: Color.fromARGB(255, 255, 255, 255),
  secondaryContainer: Color.fromARGB(255, 80, 54, 5),
  onSecondaryContainer: Color.fromARGB(255, 255, 232, 213),
  /*tertiary - contrast */
  tertiary: Color(0xffA782FF),
  onTertiary: Color.fromARGB(255, 117, 80, 211),
  tertiaryContainer: Color.fromARGB(255, 195, 170, 253),
  onTertiaryContainer: Color.fromARGB(255, 139, 111, 218),
  /*error*/
  error: Color.fromARGB(255, 255, 134, 121),
  onError: Color(0xff690005),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffdad6),
  background: Color(0xFF202020),
  onBackground: Color(0xffebe0d9),
  /*surface*/
  surface: Color(0xFF141414),
  surfaceVariant: Color(0xFF1b1b1b),
  onSurface: Color(0xffebe0d9),
);

ThemeData getThemeData(ColorScheme scheme, bool isDarkTheme) {
  final textTheme = TextTheme(
    titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    titleMedium: const TextStyle(fontSize: 18),
    titleSmall: const TextStyle(fontSize: 16),
    displayMedium: const TextStyle(fontSize: 22),
    bodyMedium: const TextStyle(fontSize: 16),
    bodySmall: const TextStyle(fontSize: 14),
    headlineLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: scheme.onSurface),
  );
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    colorSchemeSeed: null,
    scaffoldBackgroundColor: scheme.surface,
    dialogBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      surfaceTintColor: scheme.surface,
      elevation: 0,
      backgroundColor: scheme.surface,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    dialogTheme: const DialogTheme(
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
        iconTheme: const MaterialStatePropertyAll(IconThemeData()),
        backgroundColor: scheme.background,
        surfaceTintColor: Colors.transparent),
    bottomSheetTheme: BottomSheetThemeData(
      constraints: const BoxConstraints.expand(width: double.infinity),
      modalBackgroundColor: scheme.surface,
      backgroundColor: scheme.inverseSurface.withAlpha(100),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      backgroundColor: scheme.secondary,
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.fixed,
      insetPadding: const EdgeInsets.all(8),
      backgroundColor: scheme.secondary,
      contentTextStyle:
          textTheme.bodyMedium?.copyWith(color: scheme.onSecondary),
      elevation: 0,
      closeIconColor: scheme.onSecondary,
      showCloseIcon: true,
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
    ),
    cardTheme: CardTheme(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        side: BorderSide(width: 0, color: Colors.transparent),
      ),
      color: scheme.background,
      margin: const EdgeInsets.all(16),
      elevation: 0,
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      color: scheme.surfaceVariant,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(88, 56),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(color: scheme.onBackground.withAlpha(20)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary, foregroundColor: scheme.onPrimary),
    textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStatePropertyAll(
      TextStyle(fontSize: 16),
    ))),
    textTheme: textTheme,
    iconTheme: const IconThemeData(
        color: Colors.black, fill: 1, weight: 700, opticalSize: 48),
    dropdownMenuTheme: const DropdownMenuThemeData(
      menuStyle: MenuStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
        ),
      ),
    ),
  );
}

ThemeData get darkTheme => getThemeData(colorSchemeDark, true);
ThemeData get lightTheme => getThemeData(colorScheme, false);

EdgeInsets get screenPadding => const EdgeInsets.fromLTRB(24, 0, 24, 0);
