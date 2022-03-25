import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'services/current_user.dart';
import 'services/data_store.dart';
import 'ui/view/home.dart';
import 'ui/view/login.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CurrentUser>(create: (_) => CurrentUser()),
      Provider<DataStore>(create: (_) => DataStore())
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(initialLocation: '/', routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomePage(),
        // redirect: (state) {
        //   var currentUser = context.read<CurrentUser>();

        //   if (currentUser.user == null) {
        //     return state.namedLocation('home');
        //   }

        //   return null;
        // }
      ),
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
