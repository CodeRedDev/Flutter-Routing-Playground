import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _sectionNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

class SomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // TODO: implement build
    return super.build(context, state);
  }
}

class MyNavObserver extends NavigatorObserver {
  /// Creates a [MyNavObserver].
  MyNavObserver(String identifier) : log = Logger('NavObserver_$identifier') {
    log.onRecord.listen((LogRecord e) => debugPrint('$e'));
  }

  /// The logged message.
  final Logger log;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => log.info(
      'didPush: ${route.settings.name}, previousRoute= ${previousRoute?.settings.name}');

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => log.info(
      'didPop: ${route.settings.name}, previousRoute= ${previousRoute?.settings.name}');

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) => log.info(
      'didRemove: ${route.settings.name}, previousRoute= ${previousRoute?.settings.name}');

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => log.info(
      'didReplace: new= ${newRoute?.settings.name}, old= ${oldRoute?.settings.name}');

  @override
  void didStartUserGesture(
      Route<dynamic> route,
      Route<dynamic>? previousRoute,
      ) =>
      log.info('didStartUserGesture: ${route.settings.name}, '
          'previousRoute= ${previousRoute?.settings.name}');

  @override
  void didStopUserGesture() => log.info('didStopUserGesture');
}

final rootObserver = MyNavObserver('Root');
final branchObserver = MyNavObserver('Branch_A');

final _router = GoRouter(
  // observers: [rootObserver],
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationDrawerScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _sectionNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) =>
                  const ScaffoldScreen(text: 'Home Screen'),
            ),
          ],
        ),
        StatefulShellBranch(
          observers: [branchObserver],
          routes: [
            GoRoute(
              path: '/a',
              builder: (context, state) => const ScreenA(),
              routes: [
                GoRoute(
                  path: 'details',
                  builder: (context, state) => const ScreenADetails(),
                )
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/b',
              builder: (context, state) =>
                  const ScaffoldScreen(text: 'Screen B'),
            ),
          ],
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
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('NavigationDrawerScaffold'));

  final StatefulNavigationShell navigationShell;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // print('NavigationDrawerScaffold build!');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _resolveAppBarTitle(context),
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
      body: navigationShell,
    );
  }

  Widget? _resolveAppBarTitle(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) {
      return const Text('Home Screen');
    }

    if (location.startsWith('/a')) {
      return const Text('Screen A');
    }

    if (location.startsWith('/b')) {
      return const Text('Screen B');
    }

    return null;
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

    navigationShell.goBranch(
      destination,
      // this leads to navigation to the root of this branch
      initialLocation: destination == navigationShell.currentIndex,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({this.text = 'Home Screen', super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    print('HomeScreen build!');
    return Center(
      child: Text(text),
    );
  }
}

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    print('Screen A build!');
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () {
            context.go('/a/details');
          },
          child: const Text('Details'),
        ),
      ),
    );
  }
}

class ScreenADetails extends StatelessWidget {
  const ScreenADetails({super.key});

  @override
  Widget build(BuildContext context) {
    print('Screen A Details build!');
    return Scaffold(
      body: const Center(
        child: Text('Screen A Details'),
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
    print('ScaffoldScreen $text build!');
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}
