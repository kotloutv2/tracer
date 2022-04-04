import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/auth.dart';

class Greeter extends StatelessWidget {
  const Greeter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select<AuthService, User?>((service) => service.user);
    var greeterText = 'Hello';
    if (currentUser != null) {
      greeterText = 'Hello, ${currentUser.name}';
    }
    return Text(greeterText,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30));
  }
}
