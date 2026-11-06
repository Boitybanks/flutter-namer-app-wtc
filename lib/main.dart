import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const ink = Color(0xFF183D35);
const canvas = Color(0xFFF7F7EF);
const lime = Color(0xFFD9F279);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyAppState(),
      child: MaterialApp(
        title: 'Namer · A little wordplay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ink,
            primary: ink,
            surface: canvas,
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.8,
              color: ink,
            ),
            headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: ink),
            titleLarge: TextStyle(fontWeight: FontWeight.w700, color: ink),
            bodyLarge: TextStyle(height: 1.6, color: ink),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: canvas,
            indicatorColor: lime,
          ),
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();
  final List<WordPair> favorites = [];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  void restoreFavorite(WordPair pair, int index) {
    // Undo restores its original position and never duplicates a saved pair.
    if (favorites.contains(pair)) return;
    favorites.insert(index.clamp(0, favorites.length), pair);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                if (wide)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 0, 24),
                    child: NavigationRail(
                      backgroundColor: canvas,
                      indicatorColor: lime,
                      extended: constraints.maxWidth >= 1100,
                      leading: const Padding(
                        padding: EdgeInsets.only(bottom: 32),
                        child: BrandMark(),
                      ),
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (value) =>
                          setState(() => selectedIndex = value),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.auto_awesome_outlined),
                          selectedIcon: Icon(Icons.auto_awesome),
                          label: Text('Generator'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.favorite_border),
                          selectedIcon: Icon(Icons.favorite),
                          label: Text('Favorites'),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: selectedIndex == 0
                      ? const GeneratorPage()
                      : FavoritesPage(
                          onExplore: () => setState(() => selectedIndex = 0),
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) =>
                      setState(() => selectedIndex = value),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.auto_awesome_outlined),
                      selectedIcon: Icon(Icons.auto_awesome),
                      label: 'Generator',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) => const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.bubble_chart_rounded, color: ink, size: 30),
      SizedBox(width: 8),
      Text(
        'namer.',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: ink,
        ),
      ),
    ],
  );
}

class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 24 : 40),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandMark(),
            const SizedBox(height: 40),
            ...children,
          ],
        ),
      ),
    ),
  );
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();
    final pair = state.current;
    final saved = state.favorites.contains(pair);
    return PageFrame(
      children: [
        const Eyebrow(text: 'A LITTLE WORDPLAY'),
        const SizedBox(height: 12),
        Text(
          'Small words.\nBig possibilities.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Find a spark for your next project, character, or just-because idea.',
          style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF566B63)),
        ),
        const SizedBox(height: 28),
        NameCard(pair: pair),
        const SizedBox(height: 20),
        // Wrap keeps both actions reachable with large text or a narrow viewport.
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              key: const Key('next-name'),
              onPressed: state.getNext,
              icon: const Icon(Icons.shuffle_rounded),
              label: const Text('Next'),
            ),
            OutlinedButton.icon(
              key: const Key('toggle-favorite'),
              onPressed: state.toggleFavorite,
              icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
              label: Text(saved ? 'Unlike' : 'Like'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              saved ? Icons.check_circle_outline : Icons.lightbulb_outline,
              size: 20,
              color: ink,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                saved
                    ? 'Saved to Favorites. Keep exploring — it’s waiting for you there.'
                    : 'Something click? Like a name to keep it in your collection.',
                style: const TextStyle(height: 1.5, color: Color(0xFF566B63)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Divider(color: Color(0xFFDCE2D5)),
        const SizedBox(height: 12),
        const Text(
          'Made for curious minds. No perfect answers required.',
          style: TextStyle(fontSize: 12, color: Color(0xFF566B63)),
        ),
      ],
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 2,
      color: ink,
    ),
  );
}

class NameCard extends StatelessWidget {
  const NameCard({super.key, required this.pair});
  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ink,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -55,
            top: -75,
            child: ExcludeSemantics(
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF32574B), width: 35),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'YOUR NEXT WHAT-IF',
                          style: TextStyle(
                            color: lime,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('copy-name'),
                      tooltip: 'Copy name',
                      onPressed: () async {
                        // Copy is explicit: the app never reads clipboard contents.
                        await Clipboard.setData(
                          ClipboardData(text: pair.asLowerCase),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Name copied. Go make something.'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: lime,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: reduceMotion ? 0 : 220),
                  // Keep the old word out of the accessibility tree during transitions.
                  layoutBuilder: (current, previous) =>
                      current ?? const SizedBox.shrink(),
                  child: Semantics(
                    key: ValueKey(pair.asLowerCase),
                    liveRegion: true,
                    label: '${pair.first} ${pair.second}',
                    child: ExcludeSemantics(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '${pair.first}\n'),
                            TextSpan(
                              text: pair.second,
                              style: const TextStyle(color: lime),
                            ),
                          ],
                        ),
                        key: const Key('generated-name'),
                        style: const TextStyle(
                          fontSize: 48,
                          height: 1.08,
                          letterSpacing: -1.8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Two words. A fresh starting point.',
                  style: TextStyle(
                    color: Color(0xFFCAD8CF),
                    fontSize: 13,
                    height: 1.5,
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

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, this.onExplore});
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();
    return PageFrame(
      children: [
        const Eyebrow(text: 'THE KEEPERS'),
        const SizedBox(height: 12),
        Text(
          'Your little\ncollection.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Good ideas deserve a place to land.',
          style: TextStyle(fontSize: 16, color: Color(0xFF566B63)),
        ),
        const SizedBox(height: 28),
        if (state.favorites.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFDCE2D5)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: lime,
                  child: Icon(Icons.favorite_border, size: 32, color: ink),
                ),
                const SizedBox(height: 20),
                Text(
                  'No favorites yet.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Find a name that feels like something.\nTap Like, and it will be right here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.6, color: Color(0xFF566B63)),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onExplore,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Find your first idea'),
                ),
              ],
            ),
          )
        else ...[
          Text(
            '${state.favorites.length} ${state.favorites.length == 1 ? 'idea' : 'ideas'} worth keeping',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          for (final pair in state.favorites)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFDCE2D5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: ink, size: 20),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          pair.asLowerCase,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove ${pair.asLowerCase}',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          final index = state.favorites.indexOf(pair);
                          state.removeFavorite(pair);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${pair.asLowerCase} removed'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () =>
                                    state.restoreFavorite(pair, index),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        const SizedBox(height: 24),
        const Text(
          'A collection for this session. Names reset when the app restarts.',
          style: TextStyle(fontSize: 12, height: 1.5, color: Color(0xFF566B63)),
        ),
      ],
    );
  }
}
