import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'model/user.dart';
import 'view/home.dart';
import 'view/login.dart';

void main() {
  runApp(const ProviderScope(
    child: App(),
  ));
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _router = GoRouter(initialLocation: '/', routes: [
      GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const HomePage(),
          redirect: (state) {
            var currentUser = ref.read(currentUserProvider);

            if (currentUser.user == null) {
              return state.namedLocation('login');
            }

            return null;
          }),
      GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => LoginRegisterPage(
                isLogin: true,
              )),
      GoRoute(
          name: 'register',
          path: '/register',
          builder: (context, state) => LoginRegisterPage(
                isLogin: false,
              )),
    ]);

    return MaterialApp.router(
      title: 'RVMS Tracer',
      theme: ThemeData.dark(),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
