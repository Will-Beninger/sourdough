import 'dart:math' as math;

/// Unit of weight used in calculator.
enum WeightUnit {
  /// Grams
  grams,

  /// Kilograms
  kilograms,

  /// Ounces
  ounces,

  /// Pounds
  pounds,
}

/// Helper methods for [WeightUnit].
extension WeightUnitDetails on WeightUnit {
  /// Short string representation of the unit.
  String get abbreviation {
    switch (this) {
      case WeightUnit.grams:
        return 'g';
      case WeightUnit.kilograms:
        return 'kg';
      case WeightUnit.ounces:
        return 'oz';
      case WeightUnit.pounds:
        return 'lbs';
    }
  }
}

/// Calculates required bread components.
class SourdoughCalculator {
  /// Converts a value into grams based on its current unit.
  static double toGrams(double value, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.grams:
        return value;
      case WeightUnit.kilograms:
        return value * 1000.0;
      case WeightUnit.ounces:
        return value * 28.349523125;
      case WeightUnit.pounds:
        return value * 453.59237;
    }
  }

  /// Converts a gram value into the requested unit.
  static double fromGrams(double grams, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.grams:
        return grams;
      case WeightUnit.kilograms:
        return grams / 1000.0;
      case WeightUnit.ounces:
        return grams / 28.349523125;
      case WeightUnit.pounds:
        return grams / 453.59237;
    }
  }

  /// Entry point for computing the recipe requirements.
  static RecipeResult calculate({
    required double totalWeightTarget,
    required WeightUnit totalWeightUnit,
    required double discardWeight,
    required WeightUnit componentWeightUnit,
    required double hydrationPercent,
    required double saltPercent,
  }) {
    if (totalWeightTarget <= 0 || hydrationPercent <= 0) {
      return RecipeResult.empty(componentWeightUnit);
    }

    final tWg = toGrams(totalWeightTarget, totalWeightUnit);
    final dWg = toGrams(discardWeight, componentWeightUnit);

    final hRatio = hydrationPercent / 100.0;
    final sRatio = saltPercent / 100.0;

    final totalFlourGrams = tWg / (1.0 + hRatio + sRatio);
    final totalWaterGrams = totalFlourGrams * hRatio;
    final totalSaltGrams = totalFlourGrams * sRatio;

    final starterFlourGrams = dWg / 2.0;
    final starterWaterGrams = dWg / 2.0;

    final recipeFlourGrams = math
        .max(0, totalFlourGrams - starterFlourGrams)
        .toDouble();
    final recipeWaterGrams = math
        .max(0, totalWaterGrams - starterWaterGrams)
        .toDouble();

    final discardRatioPercent = (tWg > 0) ? (dWg / tWg) * 100.0 : 0.0;

    return RecipeResult(
      recipeFlour: fromGrams(recipeFlourGrams, componentWeightUnit),
      recipeWater: fromGrams(recipeWaterGrams, componentWeightUnit),
      recipeSalt: fromGrams(totalSaltGrams, componentWeightUnit),
      starter: fromGrams(dWg, componentWeightUnit),
      discardRatioPercent: discardRatioPercent,
      componentUnit: componentWeightUnit,
    );
  }
}

/// The result of a sourdough computation.
class RecipeResult {
  /// Default constructor
  const RecipeResult({
    required this.recipeFlour,
    required this.recipeWater,
    required this.recipeSalt,
    required this.starter,
    required this.discardRatioPercent,
    required this.componentUnit,
  });

  /// Factory for returning a blank result
  factory RecipeResult.empty(WeightUnit unit) {
    return RecipeResult(
      recipeFlour: 0,
      recipeWater: 0,
      recipeSalt: 0,
      starter: 0,
      discardRatioPercent: 0,
      componentUnit: unit,
    );
  }

  /// Flour to add
  final double recipeFlour;

  /// Water to add
  final double recipeWater;

  /// Salt to add
  final double recipeSalt;

  /// Starter to add
  final double starter;

  /// Percentage of total weight that is discard
  final double discardRatioPercent;

  /// Unit of the outputs
  final WeightUnit componentUnit;
}
