import 'constants.dart';

typedef Seasoning = ({double vinegarMl, double sugarGrams, double saltGrams});

/// Pure calculation logic, no UI dependencies.
class SushiCalculator {
  SushiCalculator._();

  static double _safe(double v) => (v.isNaN || v.isInfinite || v < 0) ? 0 : v;

  static double makiUncookedRice(num rolls) =>
      _safe(rolls.toDouble()) * SushiConstants.makiRiceGramsPerRoll;

  static double nigiriCookedRice(num pieces) =>
      _safe(pieces.toDouble()) * SushiConstants.nigiriCookedGramsPerPiece;

  static double nigiriUncookedRice(num pieces) =>
      nigiriCookedRice(pieces) / SushiConstants.cookedToUncookedFactor;

  static double combinedUncookedRice(num makiRolls, num nigiriPieces) =>
      makiUncookedRice(makiRolls) + nigiriUncookedRice(nigiriPieces);

  static Seasoning seasoning(double uncookedRiceGrams) {
    final f =
        _safe(uncookedRiceGrams) / SushiConstants.seasoningReferenceRiceGrams;
    return (
      vinegarMl: f * SushiConstants.seasoningVinegarMl,
      sugarGrams: f * SushiConstants.seasoningSugarGrams,
      saltGrams: f * SushiConstants.seasoningSaltGrams,
    );
  }

  static double saltForWater(double liters) =>
      _safe(liters) * SushiConstants.saltwaterSaltGramsPerLiter;

  /// Parses user input; empty or invalid text yields 0. Accepts "," as decimal.
  static double parse(String text) {
    final v = double.tryParse(text.trim().replaceAll(',', '.'));
    return (v == null) ? 0 : _safe(v);
  }

  /// One decimal place, trailing ".0" dropped (e.g. 90, 38.3).
  static String fmt(double v) {
    final s = _safe(v).toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }
}
