import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currentUserProvider = Provider<CurrentUser>((ref) => CurrentUser());

enum UserType { admin, patient }

class User {
  String username;
  UserType type;

  String token;

  String? name;

  User(this.username, this.token, this.type);
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
  void _loadSavedUser() {}

  /// Load save user into current device's local storage
  void _saveUser() async {
    if (_user != null) {
      final user = _user as User;

      await SharedPreferences.getInstance().then((prefs) async {
        var futures = [
          prefs.setString('username', user.username),
          prefs.setString('token', user.token)
        ];

        futures.add(prefs.setString('name', user.name ?? ''));

        await Future.wait(futures);
      });
    }
  }

  void logIn(String username, String password) {
    try {
      if (username == 'asd' && password == 'asd') {
        _user = User(username, password, UserType.admin);
      }

      _saveUser();
    } catch (ex) {
      log('Logging in to user $username failed.',
          name: 'tracer.user.constructor');

      throw Exception('Could not log in.');
    }
  }

  void logOut() async {
    if (_user != null) {
      // TODO: Send logout message

      await SharedPreferences.getInstance().then((prefs) async {
        await Future.wait([
          prefs.remove('username'),
          prefs.remove('token'),
          prefs.remove('email'),
          prefs.remove('name')
        ]);

        user = null;
      });
    }
  }
}
