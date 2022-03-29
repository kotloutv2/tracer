import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracer/models/user.dart';

import 'api.dart';

class AuthService {
  Future<User> logIn(String email, String password, UserRole role) async {
    final user = await Api.logIn(email, password, role).catchError((error) {
      log('Logging in with email $email failed.',
          name: 'tracer.user.constructor');

      throw error;
    });

    await _saveUser(user);

    return user;
  }

  /// Load a user saved in current device's local storage
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('email');
    final name = prefs.getString('name');

    if (email != null && name != null) {
      return User(email: email, name: name);
    }

    return null;
  }

  /// Load save user into current device's local storage
  Future<void> _saveUser(User user) async {
    await SharedPreferences.getInstance().then((prefs) async {
      var futures = [
        prefs.setString('email', user.email),
        prefs.setString('name', user.name),
      ];

      futures.add(prefs.setString('name', user.name));

      await Future.wait(futures);
    });
  }
}
