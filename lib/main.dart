import 'package:flutter/material.dart';

import 'calculator.dart';
import 'widgets.dart';

void main() => runApp(const SushiApp());

class SushiApp extends StatelessWidget {
  const SushiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sushi Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC0392B), // vermilion
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
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

  static const _titles = ['Maki', 'Nigiri', 'Rice Seasoning'];

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
    setState(() {
      // Rounded to 1 decimal to match what the other tabs display.
      _rice.text = SushiCalculator.fmt(grams);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_tab]),
          centerTitle: false,
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _tab,
            children: [_makiTab(), _nigiriTab(), _seasoningTab()],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() => _tab = i);
          },
          destinations: const [
            NavigationDestination(
              icon: _TabIcon('assets/tab_maki.png', selected: false),
              selectedIcon: _TabIcon('assets/tab_maki.png', selected: true),
              label: 'Maki',
            ),
            NavigationDestination(
              icon: _TabIcon('assets/tab_nigiri.png', selected: false),
              selectedIcon: _TabIcon('assets/tab_nigiri.png', selected: true),
              label: 'Nigiri',
            ),
            NavigationDestination(
              icon: _TabIcon('assets/tab_seasoning.png', selected: false),
              selectedIcon:
                  _TabIcon('assets/tab_seasoning.png', selected: true),
              label: 'Rice Seasoning',
            ),
          ],
        ),
      ),
    );
  }

  Widget _scroll(List<Widget> children) => ListView(
        padding: const EdgeInsets.all(16),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: children,
      );

  Widget _makiTab() => _scroll([
        SectionCard(children: [
          NumberField(
            controller: _maki,
            label: 'Number of maki rolls',
            suffix: 'rolls',
            onChanged: _refresh,
          ),
          const SizedBox(height: 8),
          ResultTile(label: 'Uncooked rice', value: _makiRice, unit: 'g'),
        ]),
        const SaltwaterCard(),
      ]);

  Widget _nigiriTab() => _scroll([
        SectionCard(children: [
          NumberField(
            controller: _nigiri,
            label: 'Number of nigiri pieces',
            suffix: 'pieces',
            onChanged: _refresh,
          ),
          const SizedBox(height: 8),
          ResultTile(label: 'Uncooked rice', value: _nigiriRice, unit: 'g'),
          ResultTile(
            label: 'Cooked rice (est.)',
            value: SushiCalculator.nigiriCookedRice(
                SushiCalculator.parse(_nigiri.text)),
            unit: 'g',
            big: false,
          ),
        ]),
        const SaltwaterCard(),
      ]);

  Widget _seasoningTab() {
    final s = SushiCalculator.seasoning(SushiCalculator.parse(_rice.text));
    return _scroll([
      SectionCard(children: [
        NumberField(
          controller: _rice,
          label: 'Uncooked rice',
          suffix: 'g',
          decimal: true,
          onChanged: _refresh,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => _setRice(_makiRice),
              child: const Text('Use Maki Amount'),
            ),
            OutlinedButton(
              onPressed: () => _setRice(_nigiriRice),
              child: const Text('Use Nigiri Amount'),
            ),
            FilledButton.tonal(
              onPressed: () => _setRice(_makiRice + _nigiriRice),
              child: const Text('Combine Both'),
            ),
          ],
        ),
      ]),
      SectionCard(title: 'Seasoning', children: [
        ResultTile(label: 'Rice vinegar', value: s.vinegarMl, unit: 'ml'),
        ResultTile(label: 'Sugar', value: s.sugarGrams, unit: 'g'),
        ResultTile(label: 'Salt', value: s.saltGrams, unit: 'g'),
      ]),
    ]);
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon(this.asset, {required this.selected});
  final String asset;
  final bool selected;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: selected ? 1 : 0.6,
        child: Image.asset(asset,
            width: 32, height: 32, fit: BoxFit.contain,
            filterQuality: FilterQuality.medium),
      );
}
