import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavigationScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/a',
          builder: (context, state) => const ScreenA(),
        ),
        GoRoute(
          path: '/b',
          builder: (context, state) => const ScreenB(),
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

class BottomNavigationScaffold extends StatelessWidget {
  const BottomNavigationScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_outlined),
            label: 'Screen A',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.message),
            icon: Icon(Icons.message_outlined),
            label: 'Screen B',
          ),
        ],
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (destination) =>
            _onDestinationSelected(context, destination),
      ),
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
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen'),
    );
  }
}

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Screen A'),
      ),
    );
  }
}

class ScreenB extends StatelessWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Screen B'),
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