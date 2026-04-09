import 'package:flutter_test/flutter_test.dart';
import 'package:sourdough/calculator/calculator_logic.dart';

void main() {
  group('SourdoughCalculator', () {
    test('Calculates standard metric recipe from imperial total correctly', () {
      final result = SourdoughCalculator.calculate(
        totalWeightTarget: 2.5, // lbs
        totalWeightUnit: WeightUnit.pounds,
        discardWeight: 100, // grams
        componentWeightUnit: WeightUnit.grams,
        hydrationPercent: 70, // %
        saltPercent: 2, // %
      );

      // tWg = 2.5 * 453.59237 = 1133.980925
      // F = 1133.980925 / 1.72 = 659.291235
      // W = F * 0.7 = 461.503864
      // S = F * 0.02 = 13.185824
      // starterFlour = 50, starterWater = 50
      // recipeFlour = 609.291235
      // recipeWater = 411.503864

      expect(result.recipeFlour, closeTo(609.29, 0.01));
      expect(result.recipeWater, closeTo(411.50, 0.01));
      expect(result.recipeSalt, closeTo(13.19, 0.01));
      expect(result.starter, closeTo(100, 0.01));
      expect(result.discardRatioPercent, closeTo((100 / 1133.98) * 100, 0.1));
    });

    test('Calculates correctly entirely in metric', () {
      final result = SourdoughCalculator.calculate(
        totalWeightTarget: 1, // kg
        totalWeightUnit: WeightUnit.kilograms,
        discardWeight: 100, // grams
        componentWeightUnit: WeightUnit.grams,
        hydrationPercent: 70, // %
        saltPercent: 2, // %
      );

      // tWg = 1000g
      // F = 1000 / 1.72 = 581.395
      // W = 581.395 * 0.7 = 406.976
      // S = 581.395 * 0.02 = 11.627
      // recipeFlour = 531.395
      // recipeWater = 356.976

      expect(result.recipeFlour, closeTo(531.395, 0.01));
      expect(result.recipeWater, closeTo(356.976, 0.01));
      expect(result.recipeSalt, closeTo(11.627, 0.01));
    });

    test('Handles 0 or negative correctly', () {
      final result = SourdoughCalculator.calculate(
        totalWeightTarget: 0,
        totalWeightUnit: WeightUnit.pounds,
        discardWeight: 100,
        componentWeightUnit: WeightUnit.grams,
        hydrationPercent: 70,
        saltPercent: 2,
      );

      expect(result.recipeFlour, 0);
      expect(result.recipeWater, 0);
      expect(result.recipeSalt, 0);
    });
  });
}
