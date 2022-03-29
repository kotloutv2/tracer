import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tracer/services/ble.dart';
import 'package:tracer/ui/viewmodel/auth.dart';

import 'models/user.dart';
import 'ui/view/home.dart';
import 'ui/view/auth.dart';

void main() {
  runApp(MultiProvider(
    providers: [],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select<AuthViewModel, User?>(((viewModel) => viewModel.user));

    final authViewModel = context.read<AuthViewModel>();

    final _router = GoRouter(initialLocation: '/', routes: [
      GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const HomePage(),
          redirect: (state) {
            if (currentUser == null) {
              return state.namedLocation('login');
            }

            return null;
          }),
      GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) {
            authViewModel.pageMode = AuthPageMode.LogIn;
            return AuthPage();
          }),
      GoRoute(
          name: 'register',
          path: '/register',
          builder: (context, state) {
            authViewModel.pageMode = AuthPageMode.Register;
            return AuthPage();
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
