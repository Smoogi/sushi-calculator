/// All adjustable ratios live here.
class SushiConstants {
  SushiConstants._();

  /// Uncooked rice per maki roll (g).
  static const double makiRiceGramsPerRoll = 30;

  /// Cooked rice per nigiri piece (g).
  static const double nigiriCookedGramsPerPiece = 18;

  /// Cooked rice weight / uncooked rice weight.
  static const double cookedToUncookedFactor = 2.35;

  /// Seasoning reference: amounts per [seasoningReferenceRiceGrams] uncooked rice.
  static const double seasoningReferenceRiceGrams = 350;
  static const double seasoningVinegarMl = 75;
  static const double seasoningSugarGrams = 30;
  static const double seasoningSaltGrams = 9;

  /// Tuna saltwater: grams of salt per liter of water (~3%).
  static const double saltwaterSaltGramsPerLiter = 30;
}
