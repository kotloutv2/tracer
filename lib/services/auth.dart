import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/user.dart';
import 'api.dart';

class AuthService extends ChangeNotifier {
  User? user;

  AuthService() {
    getSavedUser().then((savedUser) {
      user = savedUser;
      if (savedUser != null) {
        notifyListeners();
      }
    });
  }

  Future<void> logIn(String email, String password) async {
    const role = kIsWeb ? UserRole.admin : UserRole.patient;

    await Api.logIn(email, password, role).then((user) {
      this.user = user;
      _saveUser(user);
      notifyListeners();
    }).catchError((error) {
      log('Logging in with email $email failed.',
          name: 'tracer.user.constructor');

      throw error;
    });
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

  void logOut() async {
    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.clear();
    });

    user = null;
    notifyListeners();
  }
}
