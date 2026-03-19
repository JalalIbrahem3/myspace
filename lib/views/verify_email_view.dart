import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myspace/main.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

enum MenuAction{
  logout
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          PopupMenuButton<MenuAction> (
            onSelected:(value) async{
              switch(value) {
                case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout){
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                    (router) => false
                  );

                }
                break;
              }
            }, itemBuilder: (context) { 
              return const [
                const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Logout')
              )
            ];
             },
             child: null,
            )
        ],
        ),
        
        body: Column(
          children: [
            Text('Pleae verify your email to continue'),
            TextButton(onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              if (user != null){
                if (user.emailVerified){
                  devtools.log('Hello World');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/notes/',
                    (router) => false
                  );
                }
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login/',
                  (router) => false
                );
              }
            }, 
            child: const Text('Send Email Verification'),
            ),
          ],
        ),
      );
  }
}