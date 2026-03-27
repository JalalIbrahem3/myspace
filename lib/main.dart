import 'package:flutter/material.dart';
import 'package:myspace/constants/routes.dart';
import 'package:myspace/services/auth/auth_service.dart';
import 'package:myspace/views/login_view.dart';
import 'package:myspace/views/notes_views.dart';
import 'package:myspace/views/register_view.dart';
import 'package:myspace/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context) => const LoginView(),
        registerRoute : (context) => const RegisterView(),
        notesRoute : (context) => const NotesView(),
        verifyEmailRoute : (context) => const VerifyEmailView()
      }
    )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
         future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null){
              if (user.isEmailVerified) {
                devtools.log('Hello World!');
              return const NotesView();
              } else {
              return VerifyEmailView();
               }
            } else {
             return const LoginView();            
             }
            /* final user = FirebaseAuth.instance.currentUser;
            if (user?.emailVerified ?? false) {
               return const Text('Done');
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const VerifyEmail View(),
                )
              );
              return const Text('Please verify your email');
            } */
            default: 
              return const CircularProgressIndicator();         
          }
       }
      );
  }
}
