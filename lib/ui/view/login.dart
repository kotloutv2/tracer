import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tracer/models/user.dart';
import 'package:tracer/services/current_user.dart';
import 'package:tracer/services/data_store.dart';

class LoginRegisterPage extends StatelessWidget {
  final bool isLogin;

  final _textFieldPadding = const EdgeInsets.all(8);

  final _minPasswordLength = 8;
  final _maxPasswordLength = 71;

  final _maxEmailLength = 254;

  final _formKey = GlobalKey<FormState>();

  final emailFormFieldController = TextEditingController();
  final passwordFormFieldController = TextEditingController();
  final nameFormFieldController = TextEditingController();

  LoginRegisterPage({Key? key, required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailFormField = TextFormField(
      controller: emailFormFieldController,
      keyboardType: TextInputType.emailAddress,
      maxLength: _maxEmailLength,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (email) {
        if (email == null) {
          return 'Please enter an email';
        }

        // return EmailValidator.validate(email)
        //     ? 'Please enter a valid email'
        //     : null;
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
            final currentUser = context.read<CurrentUser>();
            try {
              await currentUser
                  .logIn(emailFormFieldController.text,
                      passwordFormFieldController.text, UserRole.patient)
                  .then((_) {
                var store = context.read<DataStore>();
                store.fetchData();
              });
              context.go('home');
            } catch (ex) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unable to log in.')));
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
                      context.go(context.namedLocation('register'));
                    },
                    child: const Text('Create an account?'))
                : TextButton(
                    onPressed: () {
                      context.go(context.namedLocation('login'));
                    },
                    child: const Text('Log in instead.'))
          ]),
    ));
  }
}
