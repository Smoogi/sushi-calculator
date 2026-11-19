import 'package:flutter/material.dart';

/// Visual constants for the redesign. Calculation constants stay in constants.dart.
class SushiColors {
  SushiColors._();

  static const maki = Color(0xFFC62828);
  static const nigiri = Color(0xFFEF6C00);
  static const seasoning = Color(0xFF8E24AA);

  static const surface = Color(0xFFFFF8E1);
  static const card = Color(0xFFFFF3D6);
  static const result = Color(0xFFFFEBB0);
  static const accent = Color(0xFFFFD54F);
  static const burgundy = Color(0xFF4A151B);
  static const ink = Color(0xFF3B1F1A);
  static const inkSoft = Color(0xFF7A5C52);
  static const panelLavender = Color(0xFFE9DDF3);
}

class SushiArt {
  SushiArt._();
  static const _p = 'assets/art/';
  static const makiRolls = '${_p}maki_rolls.png';
  static const nigiri = '${_p}nigiri.png';
  static const riceBowl = '${_p}rice_bowl.png';
  static const riceTub = '${_p}rice_tub.png';
  static const tunaBlock = '${_p}tuna_block.png';
  static const vinegar = '${_p}vinegar_bottle.png';
  static const sugar = '${_p}sugar_cubes.png';
  static const saltBowl = '${_p}salt_bowl.png';
  static const waterDrop = '${_p}water_drop.png';
  static const info = '${_p}info_icon.png';
  static const warning = '${_p}warning_icon.png';
  static const navMaki = '${_p}nav_maki.png';
  static const navNigiri = '${_p}nav_nigiri.png';
  static const navRice = '${_p}nav_rice.png';
  static const minus = '${_p}btn_minus.png';
  static const plus = '${_p}btn_plus.png';
  static const wave = '${_p}wave.png';
}

ThemeData buildSushiTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: SushiColors.maki,
    brightness: Brightness.light,
    surface: SushiColors.surface,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: SushiColors.surface,
    textTheme: Typography.blackMountainView.apply(
      bodyColor: SushiColors.ink,
      displayColor: SushiColors.ink,
    ),
    dividerColor: const Color(0x22000000),
  );
}

/// Soft shadow shared by cards.
const softShadow = [
  BoxShadow(color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 4)),
];
