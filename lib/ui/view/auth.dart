import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';

class AuthPage extends StatelessWidget {
  final _textFieldPadding = const EdgeInsets.all(8);

  final _minPasswordLength = 8;
  final _maxPasswordLength = 71;

  final _maxEmailLength = 254;

  final _formKey = GlobalKey<FormState>();

  final emailFormFieldController = TextEditingController();
  final passwordFormFieldController = TextEditingController();
  final nameFormFieldController = TextEditingController();

  final bool isLogin;

  AuthPage({Key? key, this.isLogin = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    var emailFormField = TextFormField(
      controller: emailFormFieldController,
      keyboardType: TextInputType.emailAddress,
      maxLength: _maxEmailLength,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (email) {
        if (email == null) {
          return 'Please enter an email';
        }

        return EmailValidator.validate(email)
            ? null
            : 'Please enter a valid email';
      },
    );

    var passwordFormField = TextFormField(
      controller: passwordFormFieldController,
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
      controller: nameFormFieldController,
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (password) {
        if (password == null) {
          return 'Please enter a name';
        }
        return null;
      },
    );

    var saveButton = ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              await authService.logIn(emailFormFieldController.text,
                  passwordFormFieldController.text);
              context.goNamed('home');
            } catch (ex) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(ex.toString())));
            }
          }
        },
        child: isLogin ? const Text('Log In') : const Text('Register'));

    var loginInputWidgets = [emailFormField, passwordFormField, saveButton];
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
                      context.goNamed('register');
                    },
                    child: const Text('Create an account?'))
                : TextButton(
                    onPressed: () {
                      context.goNamed('login');
                    },
                    child: const Text('Log in instead.'))
          ]),
    ));
  }
}
