import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final nestedNavigatorKey = GlobalKey<NavigatorState>();

const entryPointRoute = '/entrypoint';
const loginRoute = '/login';
const nestedAreaRoute = '/nested-area';
const nestedDashboardRoute = 'dashboard';
const nestedContactsRoute = 'contacts';
const nestedContactDetailsRoute = 'contacts/detail';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Legacy Nested Nav',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      navigatorKey: rootNavigatorKey,
      initialRoute: entryPointRoute,
      routes: {
        entryPointRoute: (_) => const EntryPoint(),
        loginRoute: (_) => const LoginScreen(),
        nestedAreaRoute: (_) => const NestedArea(),
      },
    );
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Point'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, loginRoute, (route) => false);
          },
          child: const Text('To Login'),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                  label: Text('Password'), hintText: 'This could hold state?'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, nestedAreaRoute);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class NestedArea extends StatefulWidget {
  const NestedArea({super.key});

  @override
  State<NestedArea> createState() => _NestedAreaState();
}

class _NestedAreaState extends State<NestedArea> {
  final _drawerKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedDestination = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Nested Area'),
      ),
      drawer: NavigationDrawer(
        selectedIndex: _selectedDestination,
        onDestinationSelected: (value) {
          if (_selectedDestination == value) {
            return;
          }

          late String routeName;
          switch (value) {
            case 0:
              routeName = nestedDashboardRoute;
            case 1:
              routeName = nestedContactsRoute;
            default:
              throw Exception('Invalid destination!');
          }

          nestedNavigatorKey.currentState
              ?.pushNamedAndRemoveUntil(routeName, (route) => false);

          // TODO: Maybe switch?
          setState(() => _selectedDestination = value);
          _scaffoldKey.currentState?.closeDrawer();
        },
        children: const [
          NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text('Dashboard'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.perm_contact_cal_outlined),
            selectedIcon: Icon(Icons.perm_contact_cal),
            label: Text('Contacts'),
          ),
        ],
      ),
      body: Navigator(
        key: nestedNavigatorKey,
        initialRoute: nestedDashboardRoute,
        onGenerateRoute: (settings) {
          late Widget page;
          switch (settings.name) {
            case nestedDashboardRoute:
              page = const DashboardScreen();
            case nestedContactsRoute:
              page = const ContactsScreen();
            case nestedContactDetailsRoute:
              page = const ContactDetails();
            default:
              throw Exception('Invalid route: ${settings.name}');
          }

          return MaterialPageRoute(
            builder: (context) => page,
            settings: settings,
          );
        },
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  int _selectedDestination = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: _selectedDestination,
      onDestinationSelected: (value) {
        if (_selectedDestination == value) {
          return;
        }

        late String routeName;
        switch (value) {
          case 0:
            routeName = nestedDashboardRoute;
          case 1:
            routeName = nestedContactsRoute;
          default:
            throw Exception('Invalid destination!');
        }

        nestedNavigatorKey.currentState
            ?.pushNamedAndRemoveUntil(routeName, (route) => false);

        // TODO: Maybe switch?
        setState(() => _selectedDestination = value);
        Scaffold.of(context).closeDrawer();
      },
      children: const [
        NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Dashboard'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.perm_contact_cal_outlined),
          selectedIcon: Icon(Icons.perm_contact_cal),
          label: Text('Contacts'),
        ),
      ],
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Some dashboard things here'),
      ),
    );
  }
}

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Some contacts here'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, nestedContactDetailsRoute);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
        ),
      ),
    );
  }
}
