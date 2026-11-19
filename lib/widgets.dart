import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculator.dart';
import 'theme.dart';

final intFormatter = FilteringTextInputFormatter.digitsOnly;
final decimalFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d*[.,]?\d{0,2}'),
);

Widget _art(String asset, {double? height, double? width}) => Image.asset(
  asset,
  height: height,
  width: width,
  fit: BoxFit.contain,
  filterQuality: FilterQuality.medium,
);

BoxDecoration _cardDecoration(Color color) => BoxDecoration(
  color: color,
  borderRadius: BorderRadius.circular(20),
  boxShadow: softShadow,
);

/// Lightweight decorative wave strip (purely visual).
class DecorativeWave extends StatelessWidget {
  const DecorativeWave({super.key, this.opacity = 0.25, this.height = 44});
  final double opacity;
  final double height;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Opacity(
      opacity: opacity,
      child: Image.asset(
        SushiArt.wave,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    ),
  );
}

/// Tab-specific gradient header with title, badge and food illustration.
class SushiHeader extends StatelessWidget {
  const SushiHeader({
    super.key,
    required this.color,
    required this.badge,
    required this.asset,
  });

  final Color color;
  final String badge;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, top + 12, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.black, 0.28)!],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: softShadow,
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecorativeWave(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sushi\nCalculator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: SushiColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: color,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _art(asset, height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Labeled card containing an editable value with yellow − / + buttons.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.controller,
    required this.label,
    required this.unit,
    required this.onChanged,
    this.decimal = false,
    this.step = 1,
  });

  final TextEditingController controller;
  final String label;
  final String unit;
  final bool decimal;
  final double step;
  final VoidCallback onChanged;

  void _bump(double delta) {
    final next = (SushiCalculator.parse(controller.text) + delta);
    controller.text = SushiCalculator.fmt(next < 0 ? 0 : next);
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: _cardDecoration(SushiColors.card),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StepButton(SushiArt.minus, () => _bump(-step)),
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: decimal,
                  ),
                  inputFormatters: [decimal ? decimalFormatter : intFormatter],
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    suffixText: unit,
                    suffixStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => onChanged(),
                ),
              ),
              _StepButton(SushiArt.plus, () => _bump(step)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton(this.asset, this.onTap);
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkResponse(
    onTap: onTap,
    radius: 36,
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: _art(asset, width: 58),
    ),
  );
}

/// Large result with illustration and prominent value.
class RiceResultCard extends StatelessWidget {
  const RiceResultCard({
    super.key,
    required this.asset,
    required this.label,
    required this.value,
    this.unit = 'g',
    this.large = true,
    this.valueColor = SushiColors.maki,
  });

  final String asset;
  final String label;
  final double value;
  final String unit;
  final bool large;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: large ? 14 : 10),
      decoration: _cardDecoration(SushiColors.result),
      child: Row(
        children: [
          _art(asset, height: large ? 76 : 56, width: large ? 96 : 72),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${SushiCalculator.fmt(value)} $unit',
                    style: TextStyle(
                      fontSize: large ? 50 : 36,
                      fontWeight: FontWeight.w900,
                      color: valueColor,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact ingredient result for the seasoning tab.
class SeasoningResultRow extends StatelessWidget {
  const SeasoningResultRow({
    super.key,
    required this.asset,
    required this.label,
    required this.value,
    required this.unit,
  });

  final String asset;
  final String label;
  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _cardDecoration(SushiColors.result),
      child: Row(
        children: [
          SizedBox(width: 64, child: Center(child: _art(asset, height: 52))),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '${SushiCalculator.fmt(value)} $unit',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: SushiColors.seasoning,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    child: Row(
      children: [
        _art(SushiArt.info, height: 26),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: SushiColors.inkSoft),
          ),
        ),
      ],
    ),
  );
}

/// Expandable tuna saltwater calculator (collapsed by default).
class TunaSaltwaterPanel extends StatefulWidget {
  const TunaSaltwaterPanel({super.key});

  @override
  State<TunaSaltwaterPanel> createState() => _TunaSaltwaterPanelState();
}

class _TunaSaltwaterPanelState extends State<TunaSaltwaterPanel> {
  final _water = TextEditingController();

  static const _steps = [
    'Use cold water (0–5°C).',
    'Dissolve the calculated amount of salt.',
    'Immerse the tuna for one minute.',
    'Remove and pat dry.',
    'Continue thawing in the refrigerator.',
  ];

  @override
  void dispose() {
    _water.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salt = SushiCalculator.saltForWater(
      SushiCalculator.parse(_water.text),
    );
    return Container(
      decoration: _cardDecoration(SushiColors.panelLavender),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          iconColor: SushiColors.seasoning,
          collapsedIconColor: SushiColors.seasoning,
          leading: _art(SushiArt.waterDrop, height: 38),
          title: const Text(
            'Tuna Saltwater',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          subtitle: const Text('30 g salt per 1 L water (~3%)'),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _water,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [decimalFormatter],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Water volume',
                      suffixText: 'L',
                      filled: true,
                      fillColor: SushiColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Salt',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${SushiCalculator.fmt(salt)} g',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: SushiColors.seasoning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < _steps.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('${i + 1}. ${_steps[i]}'),
              ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _art(SushiArt.warning, height: 26),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Saltwater treatment does not eliminate parasites or '
                    'pathogens and does not make unsafe fish suitable for raw '
                    'consumption. Use properly handled fish intended for raw '
                    'consumption.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: SushiColors.inkSoft,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Illustrated button that copies a rice amount into the seasoning input.
class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.asset,
    required this.label,
    required this.amount,
    required this.color,
    required this.onPressed,
  });

  final String asset;
  final String label;
  final double amount;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: softShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _art(asset, height: 40),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '(${SushiCalculator.fmt(amount)} g)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fixed bottom navigation: burgundy bar, illustrated icons, yellow highlight.
class SushiBottomNavigation extends StatelessWidget {
  const SushiBottomNavigation({
    super.key,
    required this.index,
    required this.onSelected,
  });

  final int index;
  final ValueChanged<int> onSelected;

  static const _items = [
    (SushiArt.navMaki, 'Maki'),
    (SushiArt.navNigiri, 'Nigiri'),
    (SushiArt.navRice, 'Rice Seasoning'),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: SushiColors.burgundy,
        indicatorColor: SushiColors.accent,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        height: 74,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: s.contains(WidgetState.selected)
                ? SushiColors.accent
                : Colors.white70,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onSelected,
        destinations: [
          for (final (asset, label) in _items)
            NavigationDestination(icon: _art(asset, height: 30), label: label),
        ],
      ),
    );
  }
}
