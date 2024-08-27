import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../routes/route_name.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Save user info in Firestore
      await saveUserInfo(userCredential.user!);
      Get.offAllNamed(
          RouteName.bottomNavigationBar); // Use Get to navigate to Home

      notifyListeners();
    } catch (e) {
      print("Google Sign-In failed: $e");
    }
  }

  Future<void> saveUserInfo(User user) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('User').doc(user.uid);

    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      // User doesn't exist, so create a new record
      await userDoc.set({
        'userId': user.uid,
        'email': user.email,
        'imageUrl': user.photoURL,
        'name': user.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'signInMethod': 'google',
        // Add other fields as needed
      });
    }
  }

  void signOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }
}
