import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_food/Pages/auth_service.dart';
import 'package:recipe_food/Pages/login.dart';

import '../CommenWidget/app_text.dart';
import '../Helpers/googlsignin.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: AppText(
          text: 'Setting',
          textColor: Colors.black,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () async {
              // Sign out from Firebase
              await auth.signOut();

              // Sign out from Google if the user is signed in with Google
              final googleSignInProvider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              googleSignInProvider.signOut();

              // Navigate to the login screen
              goToLogin(context);
            },
            title: AppText(
              text: 'Sigout',
              textColor: Colors.black,
              fontSize: 18,
            ),
            leading: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
}
