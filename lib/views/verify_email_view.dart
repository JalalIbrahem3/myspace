import 'package:flutter/material.dart';
import 'package:myspace/constants/routes.dart';
import 'package:myspace/enums/menu_action.dart';
import 'package:myspace/services/auth/auth_service.dart';
import 'package:myspace/views/notes_views.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (router) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
            child: null,
          ),
        ],
      ),

      body: Column(
        children: [
          const Text(
            "We've sent you an emailverification, Please open it to verify your account",
          ),
          const Text(
            "If you haven't received a verification email yet, press the button below",
          ),
          TextButton(
            onPressed: () async {
              final user = AuthService.firebase().currentUser;
              AuthService.firebase().sendEmailVerification();
              if (user != null) {
                if (user.isEmailVerified) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (router) => false);
                }
              } else {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(loginRoute, (router) => false);
              }
            },
            child: const Text('Send Email Verification'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                 (route) => false
                 );
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
