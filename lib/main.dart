import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tracer/ui/view/home.dart';

import 'models/data_packet.dart';
import 'models/user.dart';
import 'services/auth.dart';
import 'services/ble.dart';
import 'services/data_store.dart';
import 'ui/view/auth.dart';
import 'ui/view/ble.dart';
import 'ui/view/graph.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
      ChangeNotifierProvider(create: (context) => BleService()),
      ChangeNotifierProvider(create: (context) => Datastore())
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select<AuthService, User?>(((auth) => auth.user));

    if (currentUser != null) {
      final datastore = context.read<Datastore>();
      datastore.fetchData(currentUser);
    }

    final _router = GoRouter(
        initialLocation: '/',
        redirect: (state) {
          if (currentUser == null) {
            return state.namedLocation('login');
          }

          return null;
        },
        routes: [
          GoRoute(
            name: 'home',
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
              name: 'login',
              path: '/login',
              builder: (context, state) {
                return AuthPage(
                  isLogin: true,
                );
              }),
          GoRoute(
              name: 'register',
              path: '/register',
              builder: (context, state) {
                return AuthPage(
                  isLogin: false,
                );
              }),
          GoRoute(
              name: 'bluetooth',
              path: '/bluetooth',
              builder: (context, state) {
                return const BleConnectScreen();
              }),
          GoRoute(
              name: 'temp1Graph',
              path: '/graph/:type',
              builder: (context, state) {
                final map = VitalsType.values.asNameMap();
                final type = map[state.params['type']]!;
                return GraphPage(type: type);
              }),
        ]);

    return MaterialApp.router(
      title: 'RVMS Tracer',
      theme: ThemeData.dark(),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
