import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sourdough/calculator/calculator_logic.dart';

/// Main screen for the Sourdough Calculator
class CalculatorScreen extends StatefulWidget {
  /// Default constructor
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _totalWeightController = TextEditingController(
    text: '2.5',
  );
  final TextEditingController _discardController = TextEditingController(
    text: '100',
  );
  final TextEditingController _hydrationController = TextEditingController(
    text: '70',
  );
  final TextEditingController _saltController = TextEditingController(
    text: '2',
  );

  WeightUnit _totalUnit = WeightUnit.pounds;
  WeightUnit _componentUnit = WeightUnit.grams;

  RecipeResult _result = RecipeResult.empty(WeightUnit.grams);

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _totalWeightController.dispose();
    _discardController.dispose();
    _hydrationController.dispose();
    _saltController.dispose();
    super.dispose();
  }

  String _formatValue(double val) {
    final str = val.toStringAsFixed(2);
    if (str.endsWith('.00')) {
      return str.substring(0, str.length - 3);
    } else if (str.endsWith('0')) {
      return str.substring(0, str.length - 1);
    }
    return str;
  }

  void _changeTotalUnit(WeightUnit newUnit) {
    if (newUnit == _totalUnit) return;
    final currentVal = double.tryParse(_totalWeightController.text) ?? 0.0;
    if (currentVal > 0) {
      final inGrams = SourdoughCalculator.toGrams(currentVal, _totalUnit);
      final newVal = SourdoughCalculator.fromGrams(inGrams, newUnit);
      _totalWeightController.text = _formatValue(newVal);
    }
    setState(() => _totalUnit = newUnit);
    _calculate();
  }

  void _changeComponentUnit(WeightUnit newUnit) {
    if (newUnit == _componentUnit) return;
    final currentVal = double.tryParse(_discardController.text) ?? 0.0;
    if (currentVal > 0) {
      final inGrams = SourdoughCalculator.toGrams(currentVal, _componentUnit);
      final newVal = SourdoughCalculator.fromGrams(inGrams, newUnit);
      _discardController.text = _formatValue(newVal);
    }
    setState(() => _componentUnit = newUnit);
    _calculate();
  }

  void _calculate() {
    final tWg = double.tryParse(_totalWeightController.text) ?? 0.0;
    final dWg = double.tryParse(_discardController.text) ?? 0.0;
    final hyd = double.tryParse(_hydrationController.text) ?? 0.0;
    final s = double.tryParse(_saltController.text) ?? 0.0;

    setState(() {
      _result = SourdoughCalculator.calculate(
        totalWeightTarget: tWg,
        totalWeightUnit: _totalUnit,
        discardWeight: dWg,
        componentWeightUnit: _componentUnit,
        hydrationPercent: hyd,
        saltPercent: s,
      );
    });
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0x0DFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0x19FFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    Widget? suffixWidget,
    String? suffixText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => _calculate(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white70),
          suffix: suffixText != null ? Text(suffixText) : null,
          suffixIcon: suffixWidget != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: suffixWidget,
                )
              : null,
          filled: true,
          fillColor: const Color(0x14FFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(
    WeightUnit currentUnit,
    List<WeightUnit> units,
    ValueChanged<WeightUnit> onChanged,
  ) {
    return PopupMenuButton<WeightUnit>(
      initialValue: currentUnit,
      tooltip: '',
      onSelected: onChanged,
      color: const Color(0xFF2C1B4D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      itemBuilder: (context) {
        return units.map((u) {
          return PopupMenuItem(
            value: u,
            child: Text(
              u.abbreviation,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentUnit.abbreviation,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputsSection(bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recipe Inputs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.tune, color: Colors.white38),
          ],
        ),
        const SizedBox(height: 16),
        if (isNarrow) ...[
          _buildTextField(
            label: 'Goal Weight',
            controller: _totalWeightController,
            icon: Icons.scale,
            suffixWidget: _buildUnitDropdown(
              _totalUnit,
              const [WeightUnit.pounds, WeightUnit.kilograms],
              _changeTotalUnit,
            ),
          ),
          _buildTextField(
            label: 'Discard Weight',
            controller: _discardController,
            icon: Icons.water_drop,
            suffixWidget: _buildUnitDropdown(
              _componentUnit,
              const [WeightUnit.grams, WeightUnit.ounces],
              _changeComponentUnit,
            ),
          ),
          _buildTextField(
            label: 'Hydration',
            controller: _hydrationController,
            icon: Icons.opacity,
            suffixWidget: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('%', style: TextStyle(fontSize: 16)),
            ),
          ),
          _buildTextField(
            label: 'Salt',
            controller: _saltController,
            icon: Icons.scatter_plot,
            suffixWidget: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('%', style: TextStyle(fontSize: 16)),
            ),
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Goal Weight',
                  controller: _totalWeightController,
                  icon: Icons.scale,
                  suffixWidget: _buildUnitDropdown(
                    _totalUnit,
                    const [WeightUnit.pounds, WeightUnit.kilograms],
                    _changeTotalUnit,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'Discard Weight',
                  controller: _discardController,
                  icon: Icons.water_drop,
                  suffixWidget: _buildUnitDropdown(
                    _componentUnit,
                    const [WeightUnit.grams, WeightUnit.ounces],
                    _changeComponentUnit,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Hydration',
                  controller: _hydrationController,
                  icon: Icons.opacity,
                  suffixWidget: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('%', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'Salt',
                  controller: _saltController,
                  icon: Icons.scatter_plot,
                  suffixWidget: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('%', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Recipe Requirements',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _ResultRow(
          icon: Icons.grass,
          label: 'Flour',
          value: _result.recipeFlour,
          unit: _result.componentUnit,
        ),
        _ResultRow(
          icon: Icons.water_drop,
          label: 'Water',
          value: _result.recipeWater,
          unit: _result.componentUnit,
        ),
        _ResultRow(
          icon: Icons.science,
          label: 'Starter (Discard)',
          value: _result.starter,
          unit: _result.componentUnit,
        ),
        _ResultRow(
          icon: Icons.scatter_plot,
          label: 'Salt',
          value: _result.recipeSalt,
          unit: _result.componentUnit,
        ),
        const Divider(color: Colors.white24, height: 32),
        _ResultRow(
          icon: Icons.pie_chart,
          label: 'Discard Ratio',
          value: _result.discardRatioPercent,
          overrideUnit: '%',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > 900;
          final isNarrow = constraints.maxWidth < 450;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Baking Calculator',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2C1B4D), Color(0xFF121212)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isLandscape
                        ? Row(
                            key: const ValueKey('landscape'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildGlassCard(
                                  child: _buildInputsSection(isNarrow),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _buildGlassCard(
                                  child: _buildResultsSection(),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            key: const ValueKey('portrait'),
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildGlassCard(
                                child: _buildInputsSection(isNarrow),
                              ),
                              const SizedBox(height: 24),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: _buildGlassCard(
                                  child: _buildResultsSection(),
                                ),
                              ),
                              const SizedBox(height: 60),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.overrideUnit,
  });

  final IconData icon;
  final String label;
  final double value;
  final WeightUnit? unit;
  final String? overrideUnit;

  @override
  Widget build(BuildContext context) {
    final unitStr = overrideUnit ?? unit?.abbreviation ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFBB86FC), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)} $unitStr',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
