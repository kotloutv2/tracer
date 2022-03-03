import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/data.dart';
import 'models/user.dart';
import 'views/home.dart';
import 'views/login.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentUser()),
        ChangeNotifierProvider(create: (context) => DataStore()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  Route? _appRoutes(RouteSettings settings) {
    // Handle '/login'
    if (settings.name == "/login") {
      return MaterialPageRoute(builder: (context) => const LoginRegisterPage());
    }

    // Handle '/register'
    if (settings.name == "/register") {
      return MaterialPageRoute(
          builder: (context) => const LoginRegisterPage(
                isLogin: false,
              ));
    }

    // Handle '/details/:id'
    // var uri = Uri.parse(settings.name);
    // if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'details') {
    //   var id = uri.pathSegments[1];
    //   return MaterialPageRoute(builder: (context) => DetailScreen(id: id));
    // }

    // return MaterialPageRoute(builder: (context) => UnknownScreen());

    // If unknown URL, return homepage.
    return MaterialPageRoute(builder: (context) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RVMS Tracer',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      onGenerateRoute: _appRoutes,
    );
  }
}
