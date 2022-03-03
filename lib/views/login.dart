import 'package:flutter/material.dart';

class LoginRegisterPage extends StatelessWidget {
  final bool isLogin;

  const LoginRegisterPage({Key? key, this.isLogin = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      const Text("Welcome to RVMS"),
      isLogin ? const LoginForm() : const RegisterForm()
    ]));
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [TextFormField(), TextFormField()],
    ));
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        TextFormField(),
        TextFormField(),
        TextFormField(),
        TextFormField()
      ],
    ));
  }
}
