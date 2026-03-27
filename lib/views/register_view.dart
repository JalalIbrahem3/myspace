import 'package:flutter/material.dart';
import 'package:myspace/constants/routes.dart';
import 'package:myspace/services/auth/auth_exception.dart';
import 'package:myspace/services/auth/auth_service.dart';

import 'package:myspace/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final _email;
  late final _password;

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
      appBar: AppBar(title: const Text('Register')),
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
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on WeakPasswordAuthException catch (e) {
                    await showErrorDialog(
                      context,
                      "the least password should be 6 characters long at least \n Error code: ${e.toString()}",
                    );
                  } on EmailAlreadyInUseAuthException catch (e){
                    await showErrorDialog(
                      context,
                      "This Email is Taken by another user \n please try another email \n Error code: ${e.toString()}",
                    );
                  } on InvalidEmailAuthException catch (e){
                    await showErrorDialog(
                      context,
                      "You have entered an invalid email \n Error code: ${e.toString()}",
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      "Authintication Error",
                    );
                  }
                },
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(loginRoute, (router) => false);
                },
                child: const Text('You already have an account? Login here!'),
              ),
            ],
          );
        },
      ),
    );
  }
}
