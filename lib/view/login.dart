import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginRegisterPage extends StatelessWidget {
  final bool isLogin;

  final _textFieldPadding = const EdgeInsets.all(8);

  final _minPasswordLength = 8;
  final _maxPasswordLength = 71;

  final _maxUsernameLength = 254;

  final _formKey = GlobalKey<FormState>();

  LoginRegisterPage({Key? key, required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usernameFormField = TextFormField(
      maxLength: _maxUsernameLength,
      decoration: const InputDecoration(labelText: 'Username'),
      validator: (username) {
        if (username == null) {
          return 'Please enter an email';
        }

        return EmailValidator.validate(username)
            ? 'Please enter a valid email'
            : null;
      },
    );

    var passwordFormField = TextFormField(
      maxLength: _maxPasswordLength,
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (password) {
        if (password == null) {
          return 'Please enter a password';
        }

        return password.length < _minPasswordLength
            ? 'Minimum password length is $_minPasswordLength characters'
            : null;
      },
    );

    var nameFormField = TextFormField(
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (password) {
        if (password == null) {
          return 'Please enter a name';
        }
        return null;
      },
    );

    var saveButton = ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging In')),
            );
          }
        },
        child: const Text('Submit'));

    var loginInputWidgets = [usernameFormField, passwordFormField, saveButton];
    var registerInputWidgets = [nameFormField, ...loginInputWidgets];

    var inputWidgets =
        (isLogin ? loginInputWidgets : registerInputWidgets).map((widget) {
      return Container(padding: _textFieldPadding, width: 300, child: widget);
    }).toList();

    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200.0,
              width: 200.0,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: Center(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(children: inputWidgets),
            ),
            isLogin
                ? TextButton(
                    onPressed: () {
                      context.go(context.namedLocation('register'));
                    },
                    child: const Text('Create an account?'))
                : TextButton(
                    onPressed: () {
                      context.go(context.namedLocation('login'));
                    },
                    child: const Text('Log in instead'))
          ]),
    ));
  }
}
