import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculator.dart';
import 'constants.dart';
import 'theme.dart';
import 'widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: SushiColors.burgundy,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SushiApp());
}

class SushiApp extends StatelessWidget {
  const SushiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sushi Calculator',
      debugShowCheckedModeBanner: false,
      theme: buildSushiTheme(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;
  final _maki = TextEditingController();
  final _nigiri = TextEditingController();
  final _rice = TextEditingController();

  double get _makiRice =>
      SushiCalculator.makiUncookedRice(SushiCalculator.parse(_maki.text));
  double get _nigiriRice =>
      SushiCalculator.nigiriUncookedRice(SushiCalculator.parse(_nigiri.text));

  @override
  void dispose() {
    _maki.dispose();
    _nigiri.dispose();
    _rice.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _setRice(double grams) {
    setState(() => _rice.text = SushiCalculator.fmt(grams));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: IndexedStack(
          index: _tab,
          children: [_makiTab(), _nigiriTab(), _seasoningTab()],
        ),
        bottomNavigationBar: SushiBottomNavigation(
          index: _tab,
          onSelected: (i) {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() => _tab = i);
          },
        ),
      ),
    );
  }

  /// Header scrolls with the content so the keyboard never squeezes the layout.
  Widget _page({required Widget header, required List<Widget> children}) =>
      ListView(
        padding: EdgeInsets.zero,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          header,
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final c in children) ...[c, const SizedBox(height: 12)],
              ],
            ),
          ),
        ],
      );

  Widget _makiTab() => _page(
    header: const SushiHeader(
      color: SushiColors.maki,
      badge: 'Maki',
      asset: SushiArt.makiRolls,
    ),
    children: [
      QuantityStepper(
        controller: _maki,
        label: 'Number of maki rolls',
        unit: 'rolls',
        onChanged: _refresh,
      ),
      RiceResultCard(
        asset: SushiArt.riceBowl,
        label: 'Uncooked rice',
        value: _makiRice,
      ),
      InfoRow(
        '${SushiCalculator.fmt(SushiConstants.makiRiceGramsPerRoll)} g of uncooked rice per maki roll.',
      ),
      const TunaSaltwaterPanel(),
      Align(
        alignment: Alignment.centerRight,
        child: Image.asset(SushiArt.tunaBlock, height: 80, fit: BoxFit.contain),
      ),
    ],
  );

  Widget _nigiriTab() {
    final pieces = SushiCalculator.parse(_nigiri.text);
    return _page(
      header: const SushiHeader(
        color: SushiColors.nigiri,
        badge: 'Nigiri',
        asset: SushiArt.nigiri,
      ),
      children: [
        QuantityStepper(
          controller: _nigiri,
          label: 'Number of nigiri pieces',
          unit: 'pieces',
          onChanged: _refresh,
        ),
        RiceResultCard(
          asset: SushiArt.riceBowl,
          label: 'Uncooked rice',
          value: _nigiriRice,
          valueColor: SushiColors.nigiri,
        ),
        RiceResultCard(
          asset: SushiArt.saltBowl,
          label: 'Cooked rice (est.)',
          value: SushiCalculator.nigiriCookedRice(pieces),
          large: false,
          valueColor: SushiColors.nigiri,
        ),
        InfoRow(
          '≈ ${SushiCalculator.fmt(SushiConstants.nigiriCookedGramsPerPiece)} g of cooked rice per nigiri. '
          'Cooked rice is ≈ ${SushiConstants.cookedToUncookedFactor}× the uncooked weight.',
        ),
        const TunaSaltwaterPanel(),
      ],
    );
  }

  Widget _seasoningTab() {
    final s = SushiCalculator.seasoning(SushiCalculator.parse(_rice.text));
    return _page(
      header: const SushiHeader(
        color: SushiColors.seasoning,
        badge: 'Rice Seasoning',
        asset: SushiArt.riceTub,
      ),
      children: [
        QuantityStepper(
          controller: _rice,
          label: 'Uncooked rice',
          unit: 'g',
          decimal: true,
          step: 10,
          onChanged: _refresh,
        ),
        SeasoningResultRow(
          asset: SushiArt.vinegar,
          label: 'Rice vinegar',
          value: s.vinegarMl,
          unit: 'ml',
        ),
        SeasoningResultRow(
          asset: SushiArt.sugar,
          label: 'Sugar',
          value: s.sugarGrams,
          unit: 'g',
        ),
        SeasoningResultRow(
          asset: SushiArt.saltBowl,
          label: 'Salt',
          value: s.saltGrams,
          unit: 'g',
        ),
        InfoRow(
          'Ratio per ${SushiCalculator.fmt(SushiConstants.seasoningReferenceRiceGrams)} g of uncooked rice: '
          '${SushiCalculator.fmt(SushiConstants.seasoningVinegarMl)} ml rice vinegar, '
          '${SushiCalculator.fmt(SushiConstants.seasoningSugarGrams)} g sugar, '
          '${SushiCalculator.fmt(SushiConstants.seasoningSaltGrams)} g salt.',
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: QuickActionButton(
                  asset: SushiArt.navMaki,
                  label: 'Use Maki Amount',
                  amount: _makiRice,
                  color: const Color(0xFFE3EDC2),
                  onPressed: () => _setRice(_makiRice),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: QuickActionButton(
                  asset: SushiArt.navNigiri,
                  label: 'Use Nigiri Amount',
                  amount: _nigiriRice,
                  color: const Color(0xFFFFD9BC),
                  onPressed: () => _setRice(_nigiriRice),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: QuickActionButton(
                  asset: SushiArt.navRice,
                  label: 'Combine Both',
                  amount: _makiRice + _nigiriRice,
                  color: const Color(0xFFC9E6F7),
                  onPressed: () => _setRice(_makiRice + _nigiriRice),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
