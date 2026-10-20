import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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
        final destinations = [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Generator'),
          const NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
        ];
        final wide = constraints.maxWidth >= 600;
        return Scaffold(
          body: Row(
            children: [
              if (wide)
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 850,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) => setState(() => selectedIndex = value),
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.home), label: Text('Generator')),
                      NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                    ],
                  ),
                ),
              Expanded(
                child: selectedIndex == 0
                    ? const GeneratorPage()
                    : const FavoritesPage(),
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  destinations: destinations,
                  onDestinationSelected: (value) => setState(() => selectedIndex = value),
                ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();
    final pair = state.current;
    final saved = state.favorites.contains(pair);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('A random idea:'),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                pair.asLowerCase,
                style: Theme.of(context).textTheme.headlineMedium,
                semanticsLabel: pair.asPascalCase,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: state.toggleFavorite,
                icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
                label: Text(saved ? 'Unlike' : 'Like'),
              ),
              ElevatedButton(
                onPressed: state.getNext,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();
    if (state.favorites.isEmpty) {
      return const Center(child: Text('No favorites yet.'));
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${state.favorites.length} ${state.favorites.length == 1 ? 'favorite' : 'favorites'}:',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        for (final pair in state.favorites)
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
            trailing: IconButton(
              tooltip: 'Remove ${pair.asLowerCase}',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => state.removeFavorite(pair),
            ),
          ),
      ],
    );
  }
}
