import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myspace/constants/routes.dart';
import 'package:myspace/firebase_options.dart';
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
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
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
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                    /* devtools.log(userCredential.toString());
                  devtools.log('login successful!');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (router) => false
                  ); */
                    if (userCredential.user?.emailVerified ?? false) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(notesRoute, (router) => false);
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (router) => false,
                      );
                    }
                  } on FirebaseException catch (e) {
                    if (e.code == 'invalid-credential') {
                      await showErrorDialog(context, 'User not found');
                    } else if (e.code == 'wrong-password') {
                      await showErrorDialog(context, 'Incorrect Password');
                    } else {
                      await showErrorDialog(
                        context,
                        "Something happens while logging in \n please try again \n Error code: ${e.code}",
                      );
                    }
                  } catch (e) {
                    await showErrorDialog(
                      context,
                      e.toString(),
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

