import 'package:flutter/material.dart';
import 'package:recipe_food/Pages/auth_service.dart';
import 'package:recipe_food/Pages/login.dart';

import '../CommenWidget/app_text.dart';

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
              await auth.signOut();
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
