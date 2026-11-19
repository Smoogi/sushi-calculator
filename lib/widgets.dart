import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculator.dart';

final intFormatter = FilteringTextInputFormatter.digitsOnly;
final decimalFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}'));

class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.controller,
    required this.label,
    required this.suffix,
    required this.onChanged,
    this.decimal = false,
  });

  final TextEditingController controller;
  final String label;
  final String suffix;
  final bool decimal;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [decimal ? decimalFormatter : intFormatter],
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}

class ResultTile extends StatelessWidget {
  const ResultTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.big = true,
  });

  final String label;
  final double value;
  final String unit;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final scheme = t.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(child: Text(label, style: t.textTheme.titleMedium)),
          Text(
            SushiCalculator.fmt(value),
            style: (big ? t.textTheme.displaySmall : t.textTheme.headlineSmall)
                ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Text(unit, style: t.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.children, this.title});
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(title!, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Reusable tuna saltwater calculator (collapsed by default).
class SaltwaterCard extends StatefulWidget {
  const SaltwaterCard({super.key});

  @override
  State<SaltwaterCard> createState() => _SaltwaterCardState();
}

class _SaltwaterCardState extends State<SaltwaterCard> {
  final _water = TextEditingController();

  @override
  void dispose() {
    _water.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final salt = SushiCalculator.saltForWater(SushiCalculator.parse(_water.text));
    const steps = [
      'Use cold water (0–5°C).',
      'Dissolve the calculated amount of salt.',
      'Immerse the tuna for one minute.',
      'Remove and pat dry.',
      'Continue thawing in the refrigerator.',
    ];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        leading: const Icon(Icons.water_drop_outlined),
        title: const Text('Tuna Saltwater'),
        subtitle: const Text('30 g salt per 1 L water (~3%)'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NumberField(
            controller: _water,
            label: 'Water volume',
            suffix: 'L',
            decimal: true,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 8),
          ResultTile(label: 'Salt needed', value: salt, unit: 'g'),
          const Divider(),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('${i + 1}. ${steps[i]}'),
            ),
          const SizedBox(height: 10),
          Text(
            'Saltwater treatment does not eliminate parasites or pathogens and '
            'does not make unsafe fish suitable for raw consumption. Use '
            'properly handled fish intended for raw consumption.',
            style: t.textTheme.bodySmall
                ?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
