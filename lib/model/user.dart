import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/api.dart';

enum UserRole { patient, admin }

class User {
  String email;
  String? password;
  String name;

  UserRole? role;

  User({required this.email, this.password, required this.name, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    UserRole _role;

    if (json['role'] == 0) {
      _role = UserRole.patient;
    } else {
      _role = UserRole.admin;
    }

    return User(
        email: json['email'],
        password: json['password'],
        name: json['name'],
        role: _role);
  }
}

class CurrentUser extends ChangeNotifier {
  User? _user;

  User? get user {
    return _user;
  }

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  CurrentUser() {
    try {
      _loadSavedUser();
    } catch (ex) {
      log('Loading user from storage failed.', name: 'tracer.user.constructor');
    }
  }

  /// Load a user saved in current device's local storage
  void _loadSavedUser() async {
    await SharedPreferences.getInstance().then((prefs) async {
      var email = prefs.getString('email');
      var name = prefs.getString('name');

      if (email != null && name != null) {
        _user = User(email: email, name: name);
      }
    });
  }

  /// Load save user into current device's local storage
  void _saveUser() async {
    if (_user != null) {
      final user = _user as User;

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

  void logIn(String username, String password, UserRole role) async {
    await Api.logIn(username, password, role).catchError((error) {
      log('Logging in to user $username failed.',
          name: 'tracer.user.constructor');

      throw Exception('Could not log in.');
    }).then((user) {
      _user = user;
      _saveUser();
    });
  }

  void logOut() async {
    if (_user != null) {
      await SharedPreferences.getInstance().then((prefs) async {
        await Future.wait([prefs.remove('email'), prefs.remove('name')]);
        user = null;
      });
    }
  }
}
