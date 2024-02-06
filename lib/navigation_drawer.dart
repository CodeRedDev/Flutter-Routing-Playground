import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _sectionNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _sectionNavigatorKey,
      builder: (context, state, child) {
        return NavigationDrawerScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const ScaffoldScreen(text: 'Home Screen'),
        ),
        GoRoute(
          path: '/a',
          builder: (context, state) => const ScaffoldScreen(text: 'Screen A'),
        ),
        GoRoute(
          path: '/b',
          builder: (context, state) => const ScaffoldScreen(text: 'Screen B'),
        ),
      ],
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class NavigationDrawerScaffold extends StatelessWidget {
  NavigationDrawerScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(Icons.menu),
          //   onPressed: () {
          //     // Could also be done with
          //     // Scaffold.of(context).openDrawer();
          //     _scaffoldKey.currentState?.openDrawer();
          //   },
          // ),
          ),
      drawer: NavigationDrawer(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (destination) =>
            _onDestinationSelected(context, destination),
        children: const [
          NavigationDrawerDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: Text('Home'),
          ),
          NavigationDrawerDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_outlined),
            label: Text('Screen A'),
          ),
          NavigationDrawerDestination(
            selectedIcon: Icon(Icons.message),
            icon: Icon(Icons.message_outlined),
            label: Text('Screen B'),
          ),
        ],
      ),
      body: child,
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) {
      return 0;
    }

    if (location.startsWith('/a')) {
      return 1;
    }

    if (location.startsWith('/b')) {
      return 2;
    }

    return 0;
  }

  void _onDestinationSelected(BuildContext context, int destination) {
    _scaffoldKey.currentState?.closeDrawer();

    switch (destination) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/a');
        break;
      case 2:
        context.go('/b');
        break;
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({this.text = 'Home Screen', super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Screen A'),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'X',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_outlined),
            label: 'Y',
          ),
        ],
      ),
    );
  }
}

class ScaffoldScreen extends StatelessWidget {
  const ScaffoldScreen({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}
