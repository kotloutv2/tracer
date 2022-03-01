import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;

  String token;

  String? email;
  String? name;

  User(this.username, this.token);
}

class CurrentUserProvider extends ChangeNotifier {
  User? _user;

  User get user {
    return _user as User;
  }

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  CurrentUserProvider() {
    try {
      _loadSavedUser();
    } catch (ex) {
      developer.log("Loading user from storage failed.",
          name: "tracer.user.constructor");
    }
  }

  /// Load a user saved in current device's local storage
  void _loadSavedUser() {}

  /// Load save user into current device's local storage
  void _saveUser() async {
    if (_user != null) {
      final user = _user as User;

      await SharedPreferences.getInstance().then((prefs) async {
        var futures = [
          prefs.setString("username", user.username),
          prefs.setString("token", user.token)
        ];

        futures.add(prefs.setString("email", user.email ?? ""));
        futures.add(prefs.setString("name", user.name ?? ""));

        await Future.wait(futures);
      });
    }
  }

  void logIn(String username, String password) {
    try {
      // TODO: Try to log in.
      _user = User("asd", "asd");

      _saveUser();
    } catch (ex) {
      developer.log("Logging in to user $username failed.",
          name: "tracer.user.constructor");

      throw Exception("Could not log in.");
    }
  }

  void logOut() async {
    if (_user != null) {
      // TODO: Send logout message

      await SharedPreferences.getInstance().then((prefs) async {
        await Future.wait([
          prefs.remove("username"),
          prefs.remove("token"),
          prefs.remove("email"),
          prefs.remove("name")
        ]);

        user = null;
      });
    }
  }
}
