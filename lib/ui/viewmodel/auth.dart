import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tracer/models/user.dart';
import 'package:tracer/services/auth.dart';
import 'package:tracer/services/locator.dart';
import 'package:tracer/ui/view/auth.dart';

enum AuthPageMode { LogIn, Register }

class AuthViewModel extends ChangeNotifier {
  User? user;

  final _authService = locator<AuthService>();
  AuthPageMode _pageMode = AuthPageMode.LogIn;

  AuthPageMode get pageMode => _pageMode;
  set pageMode(AuthPageMode mode) {
    _pageMode = mode;
    notifyListeners();
  }

  AuthViewModel() {
    _authService.getSavedUser().then((savedUser) {
      user = savedUser;
      if (savedUser != null) {
        notifyListeners();
      }
    });
  }

  // Model related functions

  Future<void> logIn(String email, String password) async {
    final role = (Platform.isAndroid || Platform.isIOS)
        ? UserRole.patient
        : UserRole.admin;

    await _authService.logIn(email, password, role).then((user) {
      this.user = user;
      notifyListeners();
    });
  }

  // View related functions

  void changePageMode() {
    if (_pageMode == AuthPageMode.LogIn) {
      AuthPageMode.Register;
    } else {
      AuthPageMode.LogIn;
    }

    notifyListeners();
  }
}
