import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

const _serverBaseUri = 'https://bastion.azurewebsites.net';

class Api {
  /// Get data for user with [email]. Avoid using for vitals.
  static Future<User> getUser(String email, UserRole role) async {
    Uri uri;

    if (role == UserRole.admin) {
      uri = Uri.https(_serverBaseUri, '/api/user/hcp/$email');
    } else {
      uri = Uri.https(_serverBaseUri, '/api/user/patient/$email');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('User not found.');
    }
    throw Exception('Could not get data for $email.');
  }

  /// Log In to a user as a [role] with their [email] and [password].
  ///
  /// The [password] passed in should be in plaintext.
  static Future<User> logIn(
      String email, String password, UserRole role) async {
    Uri uri;

    if (role == UserRole.admin) {
      uri = Uri.https(_serverBaseUri, '/api/user/auth/hcp/login');
    } else {
      uri = Uri.https(_serverBaseUri, '/api/user/auth/patient/login');
    }

    final response =
        await http.post(uri, headers: {email: email, password: password});

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Incorrect password.');
    } else if (response.statusCode == 404) {
      throw Exception('User not found.');
    }
    throw Exception('Could not log in for $email.');
  }

  /// Register a user with [email] and [password] as a [role].
  ///
  /// [password] must be plaintext.
  static Future<User> register(
      String email, String password, String name, UserRole role) async {
    Uri uri;

    if (role == UserRole.admin) {
      uri = Uri.https(_serverBaseUri, '/api/user/auth/hcp/register');
    } else {
      uri = Uri.https(_serverBaseUri, '/api/user/auth/patient/register');
    }

    final response =
        await http.post(uri, headers: {email: email, password: password});

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Incorrect password.');
    } else if (response.statusCode == 404) {
      throw Exception('User not found.');
    }
    throw Exception('Could not log in for $email.');
  }

  static Future<Map<String, dynamic>> getVitals(String email) async {
    final uri = Uri.https(_serverBaseUri, '/api/vitals/$email');

    final response = await http.get(uri);

    return jsonDecode(response.body);
  }

  static Future<void> putVitals(String email) async {
    final uri = Uri.https(_serverBaseUri, '/api/vitals/$email');

    final response = await http.get(uri);

    return jsonDecode(response.body);
  }
}
