import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myspace/constants/routes.dart';
import 'package:myspace/firebase_options.dart';
import 'dart:developer' as devtools show log;

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
      appBar: AppBar(
        title: const Text('Register'),
        ),
      body: FutureBuilder(
         future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
         ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
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
              decoration : 
              const InputDecoration(
                hintText: 'Enter your email here'
                ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
              const InputDecoration(
                hintText: 'Enter your password here'
                ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, password: password
                  );
                  devtools.log(userCredential.toString());
                  devtools.log('register successful!');
                } on FirebaseException catch (e){
                  devtools.log(e.code);
                  if (e.code == 'weak-passwors'){
                    devtools.log('Your Passowrd is too WEAK');
                  } else if (e.code == 'email-already-in-use'){
                    devtools.log('This email is taken by someone else');
                    } else if (e.code == 'invalid-email'){
                      devtools.log('You have entered a wrong email');
                    } else {
                    devtools.log('SOMETHING BAD HAPPERNS !');
                  }
                }
              },
               child: const Text('Register'), 
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (router) => false
                    );
                },
                 child: const Text('You already have an account? Login here!')
                 )
          ],
        );
        },
      )
      );
  }
}