import 'package:flutter_test/flutter_test.dart';
import 'package:sushi_calculator/calculator.dart';

void main() {
  test('maki rice', () {
    expect(SushiCalculator.makiUncookedRice(3), 90);
    expect(SushiCalculator.makiUncookedRice(6), 180);
    expect(SushiCalculator.makiUncookedRice(9), 270);
    expect(SushiCalculator.makiUncookedRice(12), 360);
  });

  test('nigiri rice', () {
    expect(SushiCalculator.fmt(SushiCalculator.nigiriUncookedRice(5)), '38.3');
    expect(SushiCalculator.fmt(SushiCalculator.nigiriUncookedRice(10)), '76.6');
    expect(SushiCalculator.fmt(SushiCalculator.nigiriUncookedRice(20)), '153.2');
    expect(SushiCalculator.nigiriCookedRice(10), 180);
  });

  test('seasoning for 270 g', () {
    final s = SushiCalculator.seasoning(270);
    expect(SushiCalculator.fmt(s.vinegarMl), '57.9');
    expect(SushiCalculator.fmt(s.sugarGrams), '23.1');
    expect(SushiCalculator.fmt(s.saltGrams), '6.9');
    final ref = SushiCalculator.seasoning(350);
    expect(ref.vinegarMl, closeTo(75, 1e-9));
    expect(ref.sugarGrams, closeTo(30, 1e-9));
    expect(ref.saltGrams, closeTo(9, 1e-9));
  });

  test('saltwater', () {
    expect(SushiCalculator.saltForWater(0.5), 15);
    expect(SushiCalculator.saltForWater(1), 30);
    expect(SushiCalculator.saltForWater(1.5), 45);
    expect(SushiCalculator.saltForWater(2), 60);
  });

  test('zero, empty and invalid inputs', () {
    expect(SushiCalculator.makiUncookedRice(0), 0);
    expect(SushiCalculator.nigiriUncookedRice(0), 0);
    expect(SushiCalculator.seasoning(0).vinegarMl, 0);
    expect(SushiCalculator.saltForWater(0), 0);
    expect(SushiCalculator.parse(''), 0);
    expect(SushiCalculator.parse('abc'), 0);
    expect(SushiCalculator.parse('-5'), 0);
    expect(SushiCalculator.parse('1,5'), 1.5);
    expect(SushiCalculator.makiUncookedRice(-3), 0);
  });

  test('combined maki + nigiri', () {
    expect(SushiCalculator.combinedUncookedRice(9, 10),
        closeTo(270 + 180 / 2.35, 1e-9));
    expect(SushiCalculator.combinedUncookedRice(0, 0), 0);
  });
}
