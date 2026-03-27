import 'package:flutter/material.dart';
import 'package:myspace/constants/routes.dart';
import 'package:myspace/services/auth/auth_exception.dart';
import 'package:myspace/services/auth/auth_service.dart';
import 'package:myspace/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              break;

            case ConnectionState.done:
              break;

            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
          }
          return Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password here',
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    await AuthService.firebase().logIn(
                      email: email,
                      password: password,
                    );
                    final user = AuthService.firebase().currentUser;
                    // User Email is Verified
                    if (user?.isEmailVerified ?? false) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(notesRoute, (router) => false);
                    } else {
                      //User Email is NOT Verified
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (router) => false,
                      );
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(context, 'User not found');
                  } on WrongPasswordAuthSException {
                    await showErrorDialog(context, 'Incorrect Password');
                  } on GenericAuthException {
                    await showErrorDialog(
                        context,
                        "Authentication Error",
                      );
                  }
                },
                child: const Text('Login babe'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(registerRoute, (router) => false);
                },
                child: const Text('Not registered yet? Register here'),
              ),
            ],
          );
        },
      ),
    );
  }
}
